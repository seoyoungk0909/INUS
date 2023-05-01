import 'package:aus/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'terms_and_conditions.dart';
import 'components/custom_popup.dart';
import '../utils/color_utils.dart';
import 'notification_setting_page.dart';

void userSignOut(BuildContext context) {
  fbauth.FirebaseAuth.instance.signOut();
  Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
}

Future<void> userDelete(BuildContext context) async {
  fbauth.User currentUser = fbauth.FirebaseAuth.instance.currentUser!;
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection('user_info').doc(currentUser.uid);
  currentUser.delete().then((value) {
//     Navigator.pop(context);
//     FirebaseFirestore.instance
//         .runTransaction(
//             (transaction) async => transaction.delete(documentReference))
//         .then((value) {
//       showDialog<void>(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: const Text(
//               "Sorry to see you go!",
//               style: TextStyle(fontSize: 16),
//             ),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: const <Widget>[
//                   Text(
//                     "Your account has been successfully deleted.",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pushNamedAndRemoveUntil(
//                     context, 'login', (route) => false),
//                 child: Text(
//                   'Close',
//                   style: TextStyle(color: ApdiColors.themeGreen),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
    // });
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
            trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
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
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return signOutPopUp(context);
                  });
            },
            title: const Text("Sign Out"),
            trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
          ),
          ListTile(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return deletePopUp(context);
                },
              );
            },
            title: const Text("Delete Your Account"),
            trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute<void>(
          //         builder: (BuildContext context) => NotificationSettingPage(),
          //       ),
          //     );
          //   },
          //   title: const Text("Notification"),
          //   trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
          // ),
        ],
      ),
    );
  }
}
