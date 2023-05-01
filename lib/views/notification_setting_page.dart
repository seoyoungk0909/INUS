import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/notification_controller.dart';
import '../utils/color_utils.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingPage> createState() =>
      NotificationSettingPageState();
}

class NotificationSettingPageState extends State<NotificationSettingPage> {
  bool notificationTurnedOn = false;
  String? fcmToken;

  bool refreshing = true;

  @override
  void initState() {
    super.initState();
    getTokenAndStatus(FirebaseAuth.instance.currentUser?.uid).then((value) {
      if (mounted) {
        setState(() {
          fcmToken = value[0];
          notificationTurnedOn = value[1];
          refreshing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Notification Settings"),
        ),
        body: refreshing
            ? Center(
                child: CircularProgressIndicator(color: ApdiColors.themeGreen))
            : ListView(
                children: [
                  ListTile(
                    // onTap: () {},
                    title: const Text("New Comments"),
                    trailing: Switch(
                      onChanged: (value) {
                        updateDeviceToken(fcmToken, value,
                            FirebaseAuth.instance.currentUser?.uid);
                        setState(() {
                          notificationTurnedOn = value;
                        });
                      },
                      value: notificationTurnedOn,
                      activeColor: ApdiColors.pointGreen,
                      activeTrackColor: ApdiColors.themeGreen,
                      inactiveThumbColor: ApdiColors.greyText,
                      inactiveTrackColor: ApdiColors.darkBackground,
                    ),
                  ),
                ],
              ));
  }
}
