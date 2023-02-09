import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_login_state.dart';
import '../components/popup_dialog.dart';

class NickNameFormPage extends StatefulWidget {
  const NickNameFormPage({Key? key}) : super(key: key);

  @override
  State<NickNameFormPage> createState() => NickNameFormPageState();
}

class NickNameFormPageState extends State<NickNameFormPage> {
  final TextEditingController nickNameController = TextEditingController();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String firstName = arguments['first'];
    String lastName = arguments['last'];
    String? email = arguments['email'];
    String? school = arguments['school'];
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
                  "Almost Done! What is your nickname?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "How should others call you?",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor("##A3A3A3")),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 48, 0, 0),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: BorderDirectional(
                        top: BorderSide(color: hexStringToColor("#2C2C31")),
                        bottom: BorderSide(color: hexStringToColor("#2C2C31")),
                        start: BorderSide(color: hexStringToColor("#2C2C31")),
                        end: BorderSide(color: hexStringToColor("#2C2C31")),
                      )),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: TextFormField(
                      controller: nickNameController,
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsetsDirectional.only(
                            start: 20, bottom: 10),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      onChanged: (value) {
                        if (value.trim().isNotEmpty) {
                          setState(() {
                            buttonEnabled = true;
                          });
                        } else {
                          setState(() {
                            buttonEnabled = false;
                          });
                        }
                      },
                    ),
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
                        "5",
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
                      backgroundColor: buttonEnabled
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
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
                      if (nickNameController.text.isEmpty) {
                        popUpDialog(context, 'Field Required',
                            "Please input your username.");
                      } else {
                        DocumentReference ref = FirebaseFirestore.instance
                            .collection("user_info")
                            .doc(FirebaseAuth.instance.currentUser?.uid);

                        bool fromSignup = true;
                        if (email == null) {
                          // this means that the user's email is verified, but
                          // some of the information was not registered, so
                          // they are re-registering here. Therefore, it is not
                          // from sign up stage.
                          email = FirebaseAuth.instance.currentUser?.email;
                          school = verifyEmail(email!);
                          fromSignup = false;
                        }
                        ref.set({
                          "email": email,
                          "firstName": firstName,
                          "lastName": lastName,
                          "name": nickNameController.text,
                          "school": school,
                        });
                        appState.updateCurrentUser();
                        Navigator.pushNamed(context, 'welcome',
                            arguments: {'signup': fromSignup});
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
