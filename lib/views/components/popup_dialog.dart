import 'package:flutter/material.dart';
import '../../utils/color_utils.dart';

void popUpDialog(BuildContext context, String title, String body,
    {Widget? action, String? closeText}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                body,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              closeText ?? 'Close',
              style: TextStyle(color: ApdiColors.themeGreen),
            ),
          ),
          action ?? SizedBox.shrink(),
        ],
      );
    },
  );
}
