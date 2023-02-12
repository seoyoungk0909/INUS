import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/comment_model.dart';
import '../../utils/color_utils.dart';

Widget CommentUI(Comment comment, {bool first = false}) {
  double topPad = first ? 8 : 16;
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(28, 0, 28, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, topPad, 8, 0),
          child: Row(
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
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
          child: Text(comment.body),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Color.fromARGB(255, 74, 74, 74),
        ),
      ],
    ),
  );
  // return Text(text);
}
