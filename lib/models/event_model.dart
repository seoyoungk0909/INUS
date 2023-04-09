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

const List EVENT_LANGUAGE = ["English", "Cantonese", "Mandarin"];

class Event {
  User writer = User();
  String title = "Tissue-engineering Integrated";
  String category = "Event";
  List tag = ["#environment", "#education"];
  String description =
      "Since their first direct discovery in 2015, gravitational waves have contributed significantly to knowledge about astrophysics and fundamental physics. This talk will first introduce the Open... ";
  List language = ["English", "Cantonese"];
  String location =
      "IAS4042, 4/F, Lo Ka Chung Building, Lee Shau Kee Campus, HKUST";
  late DateTime eventTime;
  late DateTime uploadTime;
  bool formal = false;
  bool expired = false;
  String registerLink = "www.google.com";
  // bool save = false;
  DocumentReference<Map<String, dynamic>>? firebaseDocRef;

  Event({
    User? eventWriter,
    String? eventTitle,
    String? eventCategory,
    List? eventTag,
    String? eventDescription,
    List? eventLanguage,
    String? eventLocation,
    DateTime? eventHeldTime,
    DateTime? eventUploadTime,
    bool? eventFormality,
    bool? eventExpired,
    String? eventRegisterLink,
    DocumentReference<Map<String, dynamic>>? docRef,
  }) {
    writer = eventWriter ?? writer;

    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = (eventTag != null
        ? (eventTag.length >= 2 ? eventTag.sublist(0, 2) : eventTag)
        : tag);
    description = eventDescription ?? description;
    language = eventLanguage ?? language;
    location = eventLocation ?? location;
    uploadTime = eventUploadTime ?? DateTime.now();
    eventTime = eventHeldTime ?? DateTime.now();
    formal = eventFormality ?? formal;
    expired = eventExpired ?? expired;
    registerLink = eventRegisterLink ?? registerLink;
    firebaseDocRef = docRef;
  }

  // factory for events
  static Future<Event> fromDocRef(
      {DocumentReference<Map<String, dynamic>>? firebaseDoc,
      QueryDocumentSnapshot<Map<String, dynamic>>? firebaseSnap,
      bool expired = false}) async {
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

    // print(eventData.get('title'));
    // print(expired);

    return Event(
        eventWriter: eventWriter,
        eventTitle: eventData.get('title'),
        eventCategory: eventData.get('category'),
        eventTag: eventData.get('tag'),
        eventDescription: eventData.get('eventDetail'),
        eventLanguage: eventData.get('language'),
        eventLocation: eventData.get('location'),
        eventUploadTime: (eventData.get('uploadTime') as Timestamp).toDate(),
        eventHeldTime: (eventData.get('eventTime') as Timestamp).toDate(),
        eventFormality: (eventData.get('formal')),
        eventExpired: expired,
        eventRegisterLink: eventData.get('registrationLink'),
        docRef: firebaseDoc);
  }

  // factory for list of events, filter by formality
  static Future<List<Event>> getEventsFromFirebase(
      {bool formal = false}) async {
    List<Event> events = [];
    Query<Map<String, dynamic>> firebaseQuery = getEventsQuery(formal: formal);
    Query<Map<String, dynamic>> expiredQuery =
        getEventsQuery(formal: formal, expired: true);

    QuerySnapshot<Map<String, dynamic>> firebaseEvents =
        await firebaseQuery.get();
    QuerySnapshot<Map<String, dynamic>> expiredEvents =
        await expiredQuery.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbEvent
        in firebaseEvents.docs) {
      events.add(await Event.fromDocRef(firebaseDoc: fbEvent.reference));
    }
    for (QueryDocumentSnapshot<Map<String, dynamic>> fbEvent
        in expiredEvents.docs) {
      events.add(await Event.fromDocRef(
          firebaseDoc: fbEvent.reference, expired: true));
    }
    return events;
  }

  static Query<Map<String, dynamic>> getEventsQuery(
      {bool formal = false, bool expired = false}) {
    CollectionReference<Map<String, dynamic>> eventCollection =
        FirebaseFirestore.instance.collection('event');

    Query<Map<String, dynamic>> firebaseQuery;
    if (expired) {
      firebaseQuery = eventCollection
          .where('eventTime', isLessThan: DateTime.now())
          .orderBy('eventTime', descending: true)
          .limit(10);
    } else {
      firebaseQuery = eventCollection
          .where('eventTime', isGreaterThanOrEqualTo: DateTime.now())
          .orderBy('eventTime', descending: false)
          .limit(20);
    }
    firebaseQuery = firebaseQuery.where('formal', isEqualTo: formal);

    return firebaseQuery;
  }
}
