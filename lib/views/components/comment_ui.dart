import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/comment_model.dart';
import '../../utils/color_utils.dart';

Widget CommentUI(Comment comment) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comment.writerToString(),
              style: TextStyle(
                  color: comment.writerFlag
                      ? hexStringToColor("#57AD9E")
                      : Colors.white),
            ),
            Text(timeago.format(DateTime.now()
                .subtract(DateTime.now().difference(comment.time))))
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 14, 0, 14),
          child: Text(comment.body),
        ),
        const Divider(
          height: 8,
          thickness: 1,
          color: Color.fromARGB(255, 74, 74, 74),
        ),
      ],
    ),
  );
  // return Text(text);
}
