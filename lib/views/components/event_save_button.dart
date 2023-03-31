import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../controllers/event_controller.dart';

class EventSaveButton extends StatefulWidget {
  const EventSaveButton(
      {Key? key,
      required this.controller,
      required this.currentUser,
      this.saved = false})
      : super(key: key);

  final bool saved;
  final EventController controller;
  final User currentUser;

  @override
  State<EventSaveButton> createState() => EventSaveButtonState();
}

class EventSaveButtonState extends State<EventSaveButton> {
  bool saved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saved = widget.saved;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (saved) {
          widget.controller.deleteEvent(widget.currentUser.uid);
        } else {
          widget.controller.saveEvent(widget.currentUser.uid);
        }
        setState(() {
          saved = !saved;
        });
      },
      icon: saved
          ? SvgPicture.asset(
              'assets/icons/save_true.svg',
              width: 36,
              height: 36,
            )
          : SvgPicture.asset(
              'assets/icons/save_false.svg',
              width: 36,
              height: 36,
            ),
    );
  }
}
