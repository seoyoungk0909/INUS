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
}

const String APDI_TEST_ACCOUNT = "apdi-dev@connect.ust.hk";

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
        _currentUser = await um.User.fromUserRef(
            FirebaseFirestore.instance.doc('user_info/${user.uid}'));
      } else {
        _loginState = ApplicationLoginState.loggedOut;
      }
      notifyListeners();
    });
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  String? _displayName;
  String? get username => _displayName;

  um.User? _currentUser;
  um.User? get currentUser => _currentUser;

  void verifyEmail(
    String email,
  ) {
    if (email.isEmpty) {
      throw Exception(
          "Please enter your ITSC (@connect.ust.hk) email address.");
    }
    if (email.split('@')[1] != 'connect.ust.hk') {
      throw Exception(
          "You can only use ITSC (@connect.ust.hk) email address for this app.");
    }
  }

  Future<bool> isUserSetupComplete(User? user) async {
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
        doc.get("displayName");
        setupComplete = true;
      } catch (e) {
        setupComplete = false;
      }
    }
    return setupComplete;
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
      if (!userCred.user!.emailVerified && email != APDI_TEST_ACCOUNT) {
        throw Exception("Please verify your email.");
      }
      registerState = RegisterState.emailVerified;
      _email = email;
      _displayName = userCred.user?.displayName;
      notifyListeners();
      return userCred;
    });

    // user_info collection
    if (await isUserSetupComplete(userCred.user)) {
      registerState = RegisterState.setupComplete;
    }

    return registerState;
  }

  Future<void> registerAccount(String email, String password) async {
    verifyEmail(email);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      user.user?.sendEmailVerification();
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
