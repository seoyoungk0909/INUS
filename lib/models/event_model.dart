import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

const List EVENT_CATEGORY = [
  "Event",
  "Seminar",
  "Workshop",
  "Competition",
  "Webinar",
  "Party"
];

class Event {
  User writer = User();
  String title = "Tissue-engineering Integrated";
  String category = "Event";
  String tag = "#environment #education";
  String description =
      "Since their first direct discovery in 2015, gravitational waves have contributed significantly to knowledge about astrophysics and fundamental physics. This talk will first introduce the Open... ";
  String language = "English, Cantonese";
  String location =
      "IAS4042, 4/F, Lo Ka Chung Building, Lee Shau Kee Campus, HKUST";
  late DateTime eventTime;
  late DateTime uploadTime;
  bool formal = false;
  String registerLink = "www.google.com";
  // bool save = false;
  DocumentReference<Map<String, dynamic>>? firebaseDocRef;

  Event({
    User? eventWriter,
    String? eventTitle,
    String? eventCategory,
    String? eventTag,
    String? eventDescription,
    String? eventLanguage,
    String? eventLocation,
    DateTime? eventHeldTime,
    DateTime? eventUploadTime,
    bool? eventFormality,
    String? eventRegisterLink,
    // bool? savedEvent,
    DocumentReference<Map<String, dynamic>>? docRef,
  }) {
    writer = eventWriter ?? writer;

    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = eventTag ?? tag;
    description = eventDescription ?? description;
    language = eventLanguage ?? language;
    location = eventLocation ?? location;
    uploadTime = eventUploadTime ?? DateTime.now();
    eventTime = eventHeldTime ?? DateTime.now();
    formal = eventFormality ?? formal;
    registerLink = eventRegisterLink ?? registerLink;
    // save = savedEvent ?? save;
    firebaseDocRef = docRef;
  }

  // factory for events
  static Future<Event> fromDocRef(
      {DocumentReference<Map<String, dynamic>>? firebaseDoc,
      QueryDocumentSnapshot<Map<String, dynamic>>? firebaseSnap}) async {
    DocumentSnapshot<Map<String, dynamic>> eventData;

    if (firebaseSnap == null) {
      assert(firebaseDoc != null);
      eventData = await firebaseDoc!.get();
    } else {
      eventData = firebaseSnap;
      firebaseDoc ??= eventData.reference;
    }
    User eventWriter;
    try {
      eventWriter = await User.fromUserRef(eventData.get('user'));
    } catch (e) {
      eventWriter = User(userName: "Anonymous");
    }

    return Event(
        eventWriter: eventWriter,
        eventTitle: eventData.get('title'),
        eventCategory: eventData.get('category'),
        eventTag: eventData.get('tag'),
        eventDescription: eventData.get('event detail'),
        eventLanguage: eventData.get('language'),
        eventLocation: eventData.get('location'),
        eventUploadTime: (eventData.get('uploadTime') as Timestamp).toDate(),
        eventHeldTime: (eventData.get('eventTime') as Timestamp).toDate(),
        eventFormality: (eventData.get('formal')),
        eventRegisterLink: eventData.get('registration link'),
        // savedEvent: (eventData.get('save')),
        docRef: firebaseDoc);
  }

  // factory for list of events, filter by formality
  static Future<List<Event>> getEventsFromFirebase(
      {bool formal = false}) async {
    List<Event> events = [];
    Query<Map<String, dynamic>> firebaseQuery = getEventsQuery(formal: formal);

    QuerySnapshot<Map<String, dynamic>> firebaseEvents =
        await firebaseQuery.get(const GetOptions(source: Source.cache));

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbEvent
        in firebaseEvents.docs) {
      events.add(await Event.fromDocRef(firebaseDoc: fbEvent.reference));
    }
    return events;
  }

  static Query<Map<String, dynamic>> getEventsQuery({bool formal = false}) {
    CollectionReference<Map<String, dynamic>> eventCollection =
        FirebaseFirestore.instance.collection('event');

    Query<Map<String, dynamic>> firebaseQuery =
        eventCollection.orderBy('uploadTime', descending: true).limit(20);
    if (formal) {
      firebaseQuery = firebaseQuery.where('formal', isEqualTo: true);
    } else {
      firebaseQuery = firebaseQuery.where('formal', isEqualTo: false);
    }

    return firebaseQuery;
  }
}
