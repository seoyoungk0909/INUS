import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_login_state.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => VerifyPageState();
}

class VerifyPageState extends State<VerifyPage> {
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
                    "Check your school email and come back after completing authentication.",
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
              Consumer<LoginState>(
                builder: (context, appState, child) => TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
                    onPressed: () {
                      // if (FirebaseAuth.instance.currentUser!.emailVerified) {
                      Navigator.pushNamed(context, 'nickname_form', arguments: {
                        'first': firstName,
                        'last': lastName,
                        'email': email,
                        'school': school,
                      });
                      // } else {
                      //   print(FirebaseAuth.instance.currentUser);
                      //   popUpDialog(context, 'Field Required',
                      //       "Please verify your email first.");
                      // }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
