import 'package:aus/utils/color_utils.dart';
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
                    if (emailController.text.isEmpty) {
                      popUpDialog(context, 'Field Required',
                          "Please input your email.");
                    } else {
                      try {
                        String school = verifyEmail(emailController.text);
                        Navigator.pushNamed(context, 'password_form',
                            arguments: {
                              'first': firstName,
                              'last': lastName,
                              'email': emailController.text,
                              'school': school,
                            });
                      } on Exception catch (error) {
                        popUpDialog(context, 'Login Failed',
                            error.toString().split(':')[1]);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
