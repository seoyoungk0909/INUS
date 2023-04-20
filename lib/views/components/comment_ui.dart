import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/comment_model.dart';
import '../../utils/color_utils.dart';
import 'custom_popup.dart';

Color writerStringColor(bool writerFlag, bool deleted) {
  if (deleted) {
    return Colors.grey;
  }
  if (writerFlag) {
    return hexStringToColor("#57AD9E");
  } else {
    return Colors.white;
  }
}

Widget CommentUI(Comment comment, BuildContext context, {bool first = false}) {
  // double topPad = first ? 8 : 16;
  return Container(
    decoration: BoxDecoration(
      border: BorderDirectional(bottom: BorderSide(color: ApdiColors.lineGrey)),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  comment.writerToString(),
                  style: TextStyle(
                    color:
                        writerStringColor(comment.writerFlag, comment.deleted),
                  ),
                ),
                Padding(padding: EdgeInsetsDirectional.only(end: 5)),
                Text(
                  timeago.format(DateTime.now()
                      .subtract(DateTime.now().difference(comment.time))),
                  style: TextStyle(
                    fontSize: 12,
                    color: ApdiColors.greyText,
                  ),
                ),
                Spacer(),
                FirebaseAuth.instance.currentUser?.uid ==
                        comment.writerReference?.id
                    ? GestureDetector(
                        onTap: () {
                          if (comment.deleted) {
                            return;
                          }
                          showModalBottomSheet(
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return commentDeletePopUp(context, comment);
                              });
                        },
                        child: SvgPicture.asset('assets/icons/more_vert.svg'))
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 20),
            child: comment.deleted
                ? Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/deleted.svg',
                        color: Colors.grey,
                        height: 12,
                      ),
                      Padding(padding: EdgeInsetsDirectional.only(end: 5)),
                      Text(
                        comment.deletedMessage,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : Text(comment.body),
          ),
        ],
      ),
    ),
  );
}
