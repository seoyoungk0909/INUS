enum School {
  HKUST,
  HKU,
  CUHK,
  PolyU,
  CityU,
}

class User {
  String name = "test";
  School school = School.HKUST;

  User({String userName = "test", School userSchool = School.HKUST}) {
    name = userName;
    school = userSchool;
  }
}
