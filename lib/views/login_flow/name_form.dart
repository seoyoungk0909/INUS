import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';

import '../components/popup_dialog.dart';

class NameFormPage extends StatefulWidget {
  const NameFormPage({Key? key}) : super(key: key);

  @override
  State<NameFormPage> createState() => NameFormPageState();
}

class NameFormPageState extends State<NameFormPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool buttonEnabled = false;

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    bool skip_email = arguments['skip_email'] ?? false;
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
                  "Hello! What is your name?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Enter your name on student ID.",
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
                      controller: firstNameController,
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsetsDirectional.only(
                            start: 20, bottom: 10),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      onChanged: (value) {
                        if (lastNameController.text.trim().isNotEmpty &&
                            value.trim().isNotEmpty) {
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
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
                      controller: lastNameController,
                      obscureText: false,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: Theme.of(context).textTheme.labelMedium,
                        contentPadding: const EdgeInsetsDirectional.only(
                            start: 20, bottom: 10),
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 1,
                      onChanged: (value) {
                        if (firstNameController.text.trim().isNotEmpty &&
                            value.trim().isNotEmpty) {
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
                        "1",
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
                    if (firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty) {
                      popUpDialog(
                          context, 'Field Required', "Please input your name.");
                    } else if (skip_email) {
                      Navigator.pushNamed(context, 'nickname_form', arguments: {
                        'first': firstNameController.text,
                        'last': lastNameController.text
                      });
                    } else {
                      Navigator.pushNamed(context, 'email_form', arguments: {
                        'first': firstNameController.text,
                        'last': lastNameController.text
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
