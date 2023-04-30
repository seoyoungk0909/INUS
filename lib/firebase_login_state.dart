import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/user_model.dart' as um;

enum ApplicationLoginState {
  loggedOut,
  loggedIn,
}

enum RegisterState {
  unRegistered,
  emailVerified,
  setupComplete,
  TandCConfirmed,
}

const String APDI_TEST_ACCOUNT = "apdi-dev@connect.ust.hk";
const String APPSTORE_REVIEW_ACCOUNT = "appstore-review@connect.ust.hk";

String verifyEmail(String email) {
  if (email.isEmpty) {
    throw Exception("Please enter your School email address.");
  }
  String domain = email.split('@')[1];
  String school;
  switch (domain) {
    case 'connect.ust.hk':
      school = 'HKUST';
      break;
    case 'ust.hk':
      // staff email
      school = 'HKUST';
      break;
    case 'connect.polyu.hk':
      school = 'PolyU';
      break;
    case 'connect.hku.hk':
      school = 'HKU';
      break;
    case 'my.cityu.edu.hk':
      school = 'CityU';
      break;
    case 'link.cuhk.edu.hk':
      school = 'CUHK';
      break;
    // case 'gmail.com':  // for debugging
    //   school = 'HKU';
    //   break;

    default:
      throw Exception("You can only use School email address for this app.");
  }
  return school;
}

Future<bool> isUserSetupComplete(User? user, String? email) async {
  bool setupComplete = false;
  DocumentReference ref =
      FirebaseFirestore.instance.collection("user_info").doc(user?.uid);
  var doc = await ref.get();
  // if user do not exist in firestore, create
  if (!doc.exists) {
    ref.set({
      "email": email,
    });
  } else {
    // if displayName does not exist, register incomplete.
    try {
      doc.get("firstName");
      doc.get("lastName");
      doc.get("name");
      doc.get("school");
      setupComplete = true;
    } catch (e) {
      setupComplete = false;
    }
  }
  return setupComplete;
}

class LoginState extends ChangeNotifier {
  LoginState() {
    init();
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        _displayName = user.displayName;
        _email = user.email;
        DocumentReference<Map<String, dynamic>> ref =
            FirebaseFirestore.instance.doc('user_info/${user.uid}');
        var doc = await ref.get();
        if (doc.exists) {
          _currentUser = await um.User.fromUserRef(ref);
        }
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  Future<void> updateCurrentUser() async {
    _currentUser = await um.User.fromUserRef(FirebaseFirestore.instance
        .collection('user_info')
        .doc('${FirebaseAuth.instance.currentUser?.uid}'));
    notifyListeners();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  String? _displayName;
  String? get username => _displayName;

  um.User? _currentUser;
  um.User? get currentUser => _currentUser;

  Future<bool> isUserTandCConfirmed(User? user) async {
    bool tc_confirmed = false;
    DocumentReference ref =
        FirebaseFirestore.instance.collection("user_info").doc(user?.uid);
    var doc = await ref.get();
    // if user do not exist in firestore, create
    if (!doc.exists) {
      ref.set({
        "email": email,
      });
    } else {
      // if displayName does not exist, register incomplete.
      try {
        bool confirmed = doc.get("tc_confirmed");
        tc_confirmed = confirmed;
      } catch (e) {
        tc_confirmed = false;
      }
    }
    return tc_confirmed;
  }

  Future<RegisterState> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    RegisterState registerState = RegisterState.unRegistered;
    // email verification
    verifyEmail(email);
    UserCredential userCred = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((userCred) {
      if (!userCred.user!.emailVerified &&
          !(email == APDI_TEST_ACCOUNT || email == APPSTORE_REVIEW_ACCOUNT)) {
        throw Exception("Please verify your email.");
      }
      registerState = RegisterState.emailVerified;
      _email = email;
      _displayName = userCred.user?.displayName;
      notifyListeners();
      return userCred;
    });

    // user_info collection
    if (await isUserSetupComplete(userCred.user, email)) {
      registerState = RegisterState.setupComplete;
    }

    if (await isUserTandCConfirmed(userCred.user)) {
      registerState = RegisterState.TandCConfirmed;
    }

    return registerState;
  }

  Future<void> registerAccount(
      String email, String password, String displayName) async {
    verifyEmail(email);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      user.user
          ?.updateDisplayName(displayName)
          .then((value) => user.user?.sendEmailVerification());
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
