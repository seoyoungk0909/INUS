import 'package:aus/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_login_state.dart';
import '../components/popup_dialog.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => VerifyPageState();
}

class VerifyPageState extends State<VerifyPage> {
  bool emailVerified = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String firstName = arguments['first'];
    String lastName = arguments['last'];
    String email = arguments['email'];
    String school = arguments['school'];

    return Scaffold(
      backgroundColor: hexStringToColor("##121212"),
      appBar: AppBar(
        backgroundColor: hexStringToColor("##121212"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "The email has been sent.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Check your school email and come back after completing authentication.\n\n"
                    "If you can't find the email in your inbox, please check your spam folder.",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor("##A3A3A3")),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(" / 5"),
                    ],
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        elevation: 3,
                        // side: const BorderSide(
                        //   color: Colors.transparent,
                        //   width: 1,
                        // ),
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Check Status",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.currentUser?.reload().then((_) {
                          var user = FirebaseAuth.instance.currentUser;
                          print(user);
                          setState(() {
                            emailVerified = user != null && user.emailVerified;
                          });
                          if (emailVerified) {
                            popUpDialog(context, 'Email verified',
                                "You can now move on to the next step.");
                          } else {
                            Widget action = TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Send email again'),
                            );
                            popUpDialog(context, 'Email not verified',
                                "Please verify your email first.",
                                action: action);
                          }
                        });
                      }),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            emailVerified ? ApdiColors.themeGreen : Colors.grey,
                        elevation: 3,
                        // side: const BorderSide(
                        //   color: Colors.transparent,
                        //   width: 1,
                        // ),
                      ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Next",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: !emailVerified
                          ? null
                          : () {
                              Navigator.pushNamed(context, 'nickname_form',
                                  arguments: {
                                    'first': firstName,
                                    'last': lastName,
                                    'email': email,
                                    'school': school,
                                  });
                            }),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
