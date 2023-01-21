import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../firebase_login_state.dart';
import '../components/popup_dialog.dart';

class PasswordFormPage extends StatefulWidget {
  const PasswordFormPage({Key? key}) : super(key: key);

  @override
  State<PasswordFormPage> createState() => PasswordFormPageState();
}

class PasswordFormPageState extends State<PasswordFormPage> {
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();

  bool passwordVisibility1 = false;
  bool passwordVisibility2 = false;

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
                  "Enter your password.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "It needs to be at least 6 letters.",
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
                      controller: passwordController1,
                      obscureText: !passwordVisibility1,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: 'Enter your password',
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility1 = !passwordVisibility1,
                          ),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            passwordVisibility1
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
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
                      controller: passwordController2,
                      obscureText: !passwordVisibility2,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        labelText: 'confirm your password',
                        labelStyle: Theme.of(context).textTheme.labelMedium,
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            20, 24, 20, 24),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility2 = !passwordVisibility2,
                          ),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            passwordVisibility2
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "3",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const Text(" / 5"),
                    ],
                  )),
              Consumer<LoginState>(
                  builder: (context, appState, _) => TextButton(
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
                        if (passwordController1.text.isEmpty ||
                            passwordController1.text.isEmpty) {
                          popUpDialog(context, 'Field Required',
                              "Please input your password.");
                        } else if (passwordController1.text !=
                            passwordController2.text) {
                          popUpDialog(context, 'Password Mismatch',
                              "Please check your password again.");
                        } else {
                          appState
                              .registerAccount(email, passwordController1.text)
                              .then((value) {
                            Navigator.pushNamed(context, 'verify', arguments: {
                              'first': firstName,
                              'last': lastName,
                              'email': email,
                              'school': school,
                            });
                          }).catchError((error) {
                            popUpDialog(
                                context, 'Sign Up Failed', error.message);
                          });
                        }
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
