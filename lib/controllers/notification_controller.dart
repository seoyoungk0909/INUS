import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<dynamic>> getTokenAndStatus(String? uid) async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken = await firebaseMessaging.getToken();
  bool notificationTurnedOn;
  if (fcmToken == null || uid == null) {
    notificationTurnedOn = false;
  } else {
    notificationTurnedOn = await checkNotificationTurnedOn(fcmToken, uid);
  }
  return [fcmToken, notificationTurnedOn];
}

Future<void> updateDeviceToken(String? token, bool add, String? uid) async {
  if (token == null || token == 'dummy_token') return;
  if (add) {
    FirebaseFirestore.instance.collection('user_info').doc(uid).update({
      'tokens': FieldValue.arrayUnion([token])
    });
  } else {
    FirebaseFirestore.instance.collection('user_info').doc(uid).update({
      'tokens': FieldValue.arrayRemove([token])
    });
  }
}

Future<bool> checkNotificationTurnedOn(String token, String uid) async {
  var res =
      await FirebaseFirestore.instance.collection('user_info').doc(uid).get();
  try {
    List tokens = res['tokens'];
    return tokens.contains(token);
  } catch (e) {
    return false;
  }
}
