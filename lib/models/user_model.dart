// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum School {
  HKUST,
  HKU,
  CUHK,
  PolyU,
  CityU,
}

School string2School(String school) {
  switch (school) {
    case "HKUST":
      return School.HKUST;
    case "HKU":
      return School.HKU;
    case "CUHK":
      return School.CUHK;
    case "PolyU":
      return School.PolyU;
    case "CityU":
      return School.CityU;
    default:
      throw Exception("School Name Error");
  }
}

class User {
  String name = "test";
  School school = School.HKUST;
  String uid = "0";
  DocumentReference<Map<String, dynamic>>? userReference;

  User(
      {String userName = "test",
      School userSchool = School.HKUST,
      String? userID,
      DocumentReference<Map<String, dynamic>>? userRef}) {
    name = userName;
    school = userSchool;
    uid = userID ?? uid;
    userReference = userRef;
  }

  @override
  operator ==(covariant User other) => uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  // public factory
  static Future<User> fromUserRef(
      DocumentReference<Map<String, dynamic>> userRef) async {
    DocumentSnapshot<Map<String, dynamic>> userData = await userRef.get();
    return User(
      userName: userData.get('name'),
      userSchool: string2School(userData.get('school')),
      userID: userRef.id,
      userRef: userRef,
    );
  }
  String getSchool() => school.toString().split('.').last;
}
