import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class TCPopup extends StatefulWidget {
  const TCPopup({super.key});

  @override
  State<TCPopup> createState() => TCPopupState();
}

class TCPopupState extends State<TCPopup> {
  int _selectedIndex = 0;
  bool tc_confirmed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      decoration: BoxDecoration(
          color: ApdiColors.darkBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      child: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 56),
            child: Text(
              "Respect each other",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              "When communicating online, remember the other person is a human with feelings.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ApdiColors.greyText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Image.asset('assets/imgs/t&c.png'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                    value: tc_confirmed,
                    onChanged: (newValue) {
                      setState(() {
                        tc_confirmed = newValue!;
                      });
                    }),
                Text(
                  "I agree to the",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ApdiColors.greyText,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 't&c');
                    },
                    child: Text(
                      "INUS Terms",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ApdiColors.themeGreen),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 36),
            child: TextButton(
              // style: ButtonStyle(
              //     padding: MaterialStateProperty.all(EdgeInsets.zero)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                child: Text(
                  "Okay, I will",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tc_confirmed
                        ? ApdiColors.themeGreen
                        : hexStringToColor("#A3A3A3")),
              ),
              onPressed: !tc_confirmed
                  ? null
                  : () {
                      DocumentReference userRef = FirebaseFirestore.instance
                          .collection('user_info')
                          .doc(FirebaseAuth.instance.currentUser?.uid);

                      userRef.update({'tc_confirmed': true});
                      Navigator.pop(context);
                    },
            ),
          )
        ],
      )),
    );
  }
}
