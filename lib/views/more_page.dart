import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'components/popup_dialog.dart';
import 'terms_and_conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> userDelete(BuildContext context) async {
  fbauth.User currentUser = fbauth.FirebaseAuth.instance.currentUser!;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('user_info').doc(currentUser.uid);
  currentUser.delete().then((value) {
    Navigator.pop(context);
    FirebaseFirestore.instance
        .runTransaction(
            (transaction) async => transaction.delete(documentReference))
        .then((value) {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Sorry to see you go!",
              style: const TextStyle(fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    "Your account has been successfully deleted.",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (route) => false),
                child: Text(
                  'Close',
                  style: TextStyle(color: ApdiColors.themeGreen),
                ),
              ),
            ],
          );
        },
      );
    });
  });
}

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApdiColors.darkerBackground,
      appBar: AppBar(
        backgroundColor: ApdiColors.darkBackground,
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) {
                    return const TandCPage();
                  },
                ),
              );
              // Navigator.pushNamed(context, 't&c');
            },
            title: Text("Terms and Conditions"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          ),
          // ListTile(
          //   onTap: () {
          //     popUpDialog(context, "Leave Feedback", "Coming Soon!");
          //   },
          //   title: Text("Leave us Feedback"),
          //   trailing: Icon(Icons.arrow_forward_ios_outlined),
          // ),
          ListTile(
            onTap: () {
              showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text("Are you sure you want to sign out?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "No",
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              fbauth.FirebaseAuth.instance.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'login', (route) => false);
                            },
                            child: const Text("Yes")),
                      ],
                    );
                  });
            },
            title: const Text("Sign Out"),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          ),
          ListTile(
            onTap: () {
              popUpDialog(
                context,
                'Delete your account',
                "Once you delete your account, it can't be restored.",
                action: TextButton(
                    onPressed: () => userDelete(context),
                    child: const Text("Yes")),
              );
            },
            title: const Text("Delete Your Account"),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
          )
        ],
      ),
    );
  }
}
