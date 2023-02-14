import 'package:aus/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../firebase_login_state.dart';
import '../components/popup_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisibility = false;
  bool loginButtonEnabled = false;

  void login(LoginState appState) {
    // do login
    appState
        .signInWithEmailAndPassword(
            emailController.text, passwordController.text)
        .then((registerState) {
      switch (registerState) {
        case RegisterState.emailVerified:
          // email verfied, but some of the information are missing.
          // start again from name form.
          Navigator.pushNamed(context, 'name_form',
              arguments: {'skip_email': true});
          break;
        case RegisterState.setupComplete:
          Navigator.pushNamed(context, 'welcome');
          break;
        case RegisterState.TandCConfirmed:
          Navigator.pushNamed(context, 'welcome');
          break;
        default:
          throw Exception("This should not happen: "
              "the signInWithEmailAndPassword function "
              "should've thrown another exception");
      }
    }).catchError((error) {
      Widget? action;
      if (error.message == "Please verify your email.") {
        action = TextButton(
          onPressed: () {
            FirebaseAuth.instance.currentUser?.sendEmailVerification();
            Navigator.pop(context);
          },
          child: const Text('Send verification again', softWrap: true),
        );
      }
      popUpDialog(context, 'Login Failed', error.message, action: action);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  "Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 60, 0, 0),
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
                        if (passwordController.text.trim().isNotEmpty &&
                            value.trim().isNotEmpty) {
                          setState(() {
                            loginButtonEnabled = true;
                          });
                        } else {
                          setState(() {
                            loginButtonEnabled = false;
                          });
                        }
                      },
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
                      controller: passwordController,
                      obscureText: !passwordVisibility,
                      autocorrect: false,
                      enableSuggestions: false,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: 'password',
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding:
                            const EdgeInsetsDirectional.only(start: 20, top: 5),
                        suffixIcon: InkWell(
                          onTap: () => setState(
                            () => passwordVisibility = !passwordVisibility,
                          ),
                          focusNode: FocusNode(skipTraversal: true),
                          child: Icon(
                            passwordVisibility
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF757575),
                            size: 22,
                          ),
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      onChanged: (value) {
                        if (emailController.text.trim().isNotEmpty &&
                            value.trim().isNotEmpty) {
                          setState(() {
                            loginButtonEnabled = true;
                          });
                        } else {
                          setState(() {
                            loginButtonEnabled = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'name_form');
                      },
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        elevation: 0,
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'password_reset');
                      },
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        elevation: 0,
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Consumer<LoginState>(builder: (context, appState, _) {
                return TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      backgroundColor: loginButtonEnabled
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
                          "Login",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () =>
                        loginButtonEnabled ? login(appState) : null);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
