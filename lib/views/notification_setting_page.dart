import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/notification_controller.dart';
import '../utils/color_utils.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage(
      {Key? key, this.fcmToken, this.notificationTurnedOn = false})
      : super(key: key);
  final String? fcmToken;
  final bool notificationTurnedOn;

  @override
  State<NotificationSettingPage> createState() =>
      NotificationSettingPageState();
}

class NotificationSettingPageState extends State<NotificationSettingPage> {
  bool notificationTurnedOn = false;

  @override
  void initState() {
    super.initState();
    notificationTurnedOn = widget.notificationTurnedOn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text("Notification Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              // onTap: () {},
              title: const Text("New Comments"),
              // trailing: SvgPicture.asset('assets/icons/chevron-right.svg'),
              trailing: Switch(
                onChanged: (value) {
                  updateDeviceToken(widget.fcmToken, value,
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
