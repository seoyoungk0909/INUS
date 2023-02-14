import 'package:aus/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../firebase_login_state.dart';
import '../components/popup_dialog.dart';

class EmailFormPage extends StatefulWidget {
  const EmailFormPage({Key? key}) : super(key: key);

  @override
  State<EmailFormPage> createState() => EmailFormPageState();
}

class EmailFormPageState extends State<EmailFormPage> {
  final TextEditingController emailController = TextEditingController();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    String firstName = arguments['first'];
    String lastName = arguments['last'];

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
                  "What is your school email?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "We will send an authentication link to your school email.",
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
                      controller: emailController,
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'School email',
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
                        "2",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(" / 5"),
                    ],
                  )),
              TextButton(
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                    if (emailController.text.trim().isEmpty) {
                      popUpDialog(context, 'Field Required',
                          "Please input your email.");
                    } else {
                      String school;
                      try {
                        school = verifyEmail(emailController.text.trim());
                      } on Exception catch (error) {
                        popUpDialog(context, 'Wrong email',
                            error.toString().split(':')[1]);
                        return;
                      }
                      // check if email is already in use
                      bool emailInUse = true;
                      // this will result in error b/c password is so random.
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password:
                                  "vlkjh1gh%jqo&uiyer*nnlk(jhf-heu+wjn[klho]vjhqoi")
                          .then((value) => null)
                          .catchError((error, stackTrace) {
                        print(error.code);
                        switch (error.code) {
                          case "user-not-found":
                            // Thrown if there is no user corresponding to the given email.
                            emailInUse = false;
                            break;
                          case "wrong-password":
                            // Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
                            emailInUse = true;
                            break;
                          default:
                            popUpDialog(context, 'Wrong email',
                                error.toString().split(':')[1]);
                        }
                      }).then((value) {
                        if (emailInUse) {
                          popUpDialog(context, 'Email already in use',
                              "This email is already registered. Please sign in.");
                        } else {
                          Navigator.pushNamed(context, 'password_form',
                              arguments: {
                                'first': firstName,
                                'last': lastName,
                                'email': emailController.text,
                                'school': school,
                              });
                        }
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
