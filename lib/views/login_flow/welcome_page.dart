import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
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
                      "Welcome to AUS!",
                      style: TextStyle(fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
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
