import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'popup_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:aus/views/more_page.dart';

Widget signOutPopUp(BuildContext context, {Widget? action}) {
  return Container(
    height: 200,
    decoration: const BoxDecoration(
      color: Color(0x1C1C1C),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
    ),
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Sign Out?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w600))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText("Are you sure you want to sign out?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          hexStringToColor('#282828')),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ))),
                  child: const Text('Go Back'),
                ),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      userSignOut(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            hexStringToColor('#4CA88F')),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ))),
                    child: SelectableText("Yes, Sign Out",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget deletePopUp(BuildContext context, {Widget? action}) {
  return Container(
    height: 200,
    decoration: const BoxDecoration(
      color: Color(0x1C1C1C),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
    ),
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Delete your account",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w600))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText(
                  "Once you delete your account, it can't be restored.",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          hexStringToColor('#282828')),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ))),
                  child: const Text('Go Back'),
                ),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      //delete user
                      userDelete(context);
                      //popup - "sorry to see you go"
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              color: Color(0x1C1C1C),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Column(children: [
                              Center(
                                child: Container(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 30),
                                    child: SelectableText(
                                        "Sorry to see you go!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                                fontFamily: 'Roboto',
                                                color:
                                                    hexStringToColor('#FFFFFF'),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                              ),
                              Center(
                                child: Container(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 10),
                                    child: SelectableText(
                                        "Your account has been successfully deleted.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                              fontFamily: 'Roboto',
                                              color:
                                                  hexStringToColor('#A3A3A3'),
                                              fontSize: 14,
                                            ))),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(top: 30),
                                  child: Center(
                                    child: SizedBox(
                                      width: 170,
                                      height: 50,
                                      child: ElevatedButton(
                                        //return to login page
                                        onPressed: () => userSignOut(context),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    hexStringToColor(
                                                        '#4CA88F')),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                            ))),
                                        child: const Text('Close'),
                                      ),
                                    ),
                                  ))
                            ]),
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            hexStringToColor('#4CA88F')),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ))),
                    child: SelectableText("Yes, Delete",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
