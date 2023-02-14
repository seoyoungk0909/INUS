import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event_model.dart';

class EventController {
  Event event = Event();

  // void changeSave() => event.save = !event.save;

  EventController(this.event);

  Future<void> saveEvent(String currentUserId) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('user_info').doc(currentUserId);
    userDoc.update({
      'savedPosts': FieldValue.arrayUnion([event.firebaseDocRef])
    });
    event.firebaseDocRef?.update({"saveCount": FieldValue.increment(1)});
  }

  Future<void> deleteEvent(String currentUserId) async {
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('user_info').doc(currentUserId);
    userDoc.update({
      'savedPosts': FieldValue.arrayRemove([event.firebaseDocRef])
    });
    event.firebaseDocRef?.update({"saveCount": FieldValue.increment(-1)});
  }
}
