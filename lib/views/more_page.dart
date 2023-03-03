import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'components/popup_dialog.dart';
import 'terms_and_conditions.dart';

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
                      title: Text('Sign Out'),
                      content: Text("Are you sure you want to sign out?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
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
            title: Text("Sign Out"),
            trailing: Icon(Icons.arrow_forward_ios_outlined),
          )
        ],
      ),
    );
  }
}
