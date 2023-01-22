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
                            "Get Started →",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: ApdiColors.lightText,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
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
