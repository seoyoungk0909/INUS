import 'package:cloud_firestore/cloud_firestore.dart';

const List EVENT_CATEGORY = [
  "Event",
  "Seminar",
  "Workshop",
  "Competition",
  "Webinar",
  "Party"
];

class Event {
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
  bool save = false;
  DocumentReference<Map<String, dynamic>>? firebaseDocRef;

  Event({
    String? eventTitle,
    String? eventCategory,
    String? eventTag,
    String? eventDescription,
    String? eventLanguage,
    String? eventLocation,
    DateTime? eventHeldTime,
    DateTime? eventUploadTime,
    bool? eventFormality,
    bool? savedEvent,
    DocumentReference<Map<String, dynamic>>? docRef,
  }) {
    title = eventTitle ?? title;
    category = eventCategory ?? category;
    tag = eventTag ?? tag;
    description = eventDescription ?? description;
    language = eventLanguage ?? language;
    location = eventLocation ?? location;
    uploadTime = eventUploadTime ?? DateTime.now();
    eventTime = eventHeldTime ?? DateTime.now();
    formal = eventFormality ?? formal;
    save = savedEvent ?? save;
    firebaseDocRef = docRef;
  }

  // factory for events
  static Future<Event> fromDocRef(
      DocumentReference<Map<String, dynamic>> firebaseDoc) async {
    DocumentSnapshot<Map<String, dynamic>> eventData = await firebaseDoc.get();

    return Event(
        eventTitle: eventData.get('title'),
        eventCategory: eventData.get('category'),
        eventTag: eventData.get('tag'),
        eventDescription: eventData.get('body'),
        eventLanguage: eventData.get('language'),
        eventLocation: eventData.get('location'),
        eventUploadTime: (eventData.get('timestamp') as Timestamp).toDate(),
        eventHeldTime: (eventData.get('timestamp') as Timestamp).toDate(),
        eventFormality: (eventData.get('formal')),
        savedEvent: (eventData.get('save')),
        docRef: firebaseDoc);
  }

  // factory for list of events, filter by formality
  static Future<List<Event>> getEventsFromFirebase(
      {bool formal = false}) async {
    List<Event> events = [];
    CollectionReference<Map<String, dynamic>> eventCollection =
        FirebaseFirestore.instance.collection('events');

    Query<Map<String, dynamic>> firebaseQuery;
    if (formal) {
      firebaseQuery = eventCollection
          .where('formal', isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .limit(20);
    } else {
      firebaseQuery =
          eventCollection.orderBy('timestamp', descending: true).limit(20);
    }

    QuerySnapshot<Map<String, dynamic>> firebaseEvents =
        await firebaseQuery.get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> fbEvent
        in firebaseEvents.docs) {
      events.add(await Event.fromDocRef(fbEvent.reference));
    }
    return events;
  }
}
