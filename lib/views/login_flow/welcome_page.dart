import 'package:aus/utils/color_utils.dart';
import 'package:aus/views/components/popup_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../terms_and_conditions.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool tc_confirmed = false;
  bool alreadyConfirmed = false;

  Future<Widget> TCAgreeRow() async {
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance
        .collection('user_info')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    DocumentSnapshot<Map<String, dynamic>> dataMap = await userRef.get();
    bool confirmed =
        dataMap.data()!.containsKey('tc_confirmed') && dataMap['tc_confirmed'];
    if (confirmed) {
      setState(() {
        alreadyConfirmed = true;
        tc_confirmed = true;
      });
      return SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: tc_confirmed,
            onChanged: (newValue) {
              setState(() {
                tc_confirmed = newValue!;
              });
            }),
        Text(
          "I agree to the",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ApdiColors.greyText,
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return TandCPage();
                  },
                ),
              );
              // Navigator.pushNamed(context, 't&c');
            },
            child: Text(
              "INUS Terms (EULA)",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: ApdiColors.themeGreen),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    bool from_signup = arguments['signup'] ?? false;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      "Welcome to INUS!",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                FutureBuilder(
                    future: TCAgreeRow(),
                    builder: (context, AsyncSnapshot<Widget> snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox.shrink();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: snapshot.data!,
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColorLight,
                        backgroundColor: Theme.of(context).primaryColorDark,
                        elevation: 3,
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            from_signup ? "Go to Login" : "Get Started →",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: ApdiColors.lightText,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (!tc_confirmed) {
                          popUpDialog(context, "Terms and Conditions",
                              "Please agree to our terms and conditions first to use the app.");
                          return;
                        }
                        if (!alreadyConfirmed) {
                          DocumentReference userRef = FirebaseFirestore.instance
                              .collection('user_info')
                              .doc(FirebaseAuth.instance.currentUser?.uid);

                          userRef.update({'tc_confirmed': true});
                        }
                        if (from_signup) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'login', (route) => false);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
