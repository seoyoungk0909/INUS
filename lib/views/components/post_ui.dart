import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/post_controller.dart';
// import 'package:timeago/timeago.dart' as timeago;
import '../../utils/color_utils.dart';
import '../../utils/math_utils.dart';
import 'custom_popup.dart';

class ViewCommentSave extends StatefulWidget {
  const ViewCommentSave(
      {Key? key,
      required this.hexButtonColor,
      required this.controller,
      this.showText = true,
      this.saved = false})
      : super(key: key);

  final String hexButtonColor;
  final PostController controller;
  final bool showText;
  final bool saved;

  @override
  State<ViewCommentSave> createState() => ViewCommentSaveState();
}

class ViewCommentSaveState extends State<ViewCommentSave> {
  bool saved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saved = widget.saved;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //view
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 8, 0, 8),
                // TODO: use eye-open
                child: Icon(
                  Icons.remove_red_eye_outlined,
                  color: hexStringToColor(widget.hexButtonColor),
                  size: 18,
                ),
              ),
              widget.showText
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(start: 4),
                      child: Text(
                        'View',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontFamily: 'Roboto',
                              color: hexStringToColor(widget.hexButtonColor),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 4),
                child: Text(
                  summarizeLongInt(widget.controller.post.views),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        color: hexStringToColor(widget.hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
        //comment
        Padding(
          padding: EdgeInsetsDirectional.only(end: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 8, 0, 8),
                // child: Icon(
                //   Icons.comment,
                //   color: hexStringToColor(hexButtonColor),
                //   size: 24,
                // ),
                child: SvgPicture.asset(
                  'assets/icons/message-square-typing.svg',
                  color: hexStringToColor(widget.hexButtonColor),
                  height: 18,
                ),
              ),
              widget.showText
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(start: 4),
                      child: Text(
                        'Comment',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              fontFamily: 'Roboto',
                              color: hexStringToColor(widget.hexButtonColor),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 4),
                child: Text(
                  summarizeLongInt(widget.controller.post.numComments()),
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        color: hexStringToColor(widget.hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
        //save
        TextButton(
          style: TextButton.styleFrom(
              primary: hexStringToColor(widget.hexButtonColor)),
          onPressed: () {
            setState(() {
              saved = !saved;
              DocumentReference userRef = FirebaseFirestore.instance
                  .collection('user_info')
                  .doc(FirebaseAuth.instance.currentUser?.uid);
              if (saved) {
                // saved = false -> true; now we save
                widget.controller.postSave();
                userRef.update({
                  'savedPosts': FieldValue.arrayUnion(
                      [widget.controller.post.firebaseDocRef])
                });
              } else {
                // saved = true -> false; now we remove
                widget.controller.postSaveCancel();
                userRef.update({
                  'savedPosts': FieldValue.arrayRemove(
                      [widget.controller.post.firebaseDocRef])
                });
              }
            });
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    // child: Icon(
                    //   Icons.bookmark_border,
                    //   color: hexStringToColor(hexButtonColor),
                    //   size: 24,
                    // ),
                    child: SvgPicture.asset(
                      saved
                          ? 'assets/icons/save_true.svg'
                          : 'assets/icons/save_false.svg',
                      color: hexStringToColor(widget.hexButtonColor),
                      height: 18,
                    )),
                widget.showText
                    ? Padding(
                        padding: EdgeInsetsDirectional.only(end: 30),
                        child: Text(
                          'Save',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                fontFamily: 'Roboto',
                                color: hexStringToColor(widget.hexButtonColor),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsDirectional.only(start: 4),
                        child: Text(
                          widget.controller.post.saveCount.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                fontFamily: 'Roboto',
                                color: hexStringToColor(widget.hexButtonColor),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget writerInfoUI(BuildContext context, PostController controller) {
  Widget profileImage;
  switch (controller.post.category) {
    case "Academic":
      // profileImage = SvgPicture.asset('assets/imgs/Academic.svg');
      profileImage = const Image(image: AssetImage('assets/imgs/Academic.png'));
      break;
    case "19+":
      profileImage = SvgPicture.asset('assets/imgs/19+.svg');
      break;
    case "Just Talk":
      // profileImage = SvgPicture.asset('assets/imgs/Just Talk.svg');
      profileImage =
          const Image(image: AssetImage('assets/imgs/Just Talk.png'));
      break;
    default:
      profileImage = const Image(image: AssetImage('assets/imgs/profile.jpeg'));
  }

  String timeAgoCustom(DateTime datetime) {
    Duration diff = DateTime.now().difference(datetime);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${(diff.inDays)} ${(diff.inDays) == 1 ? "days" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${(diff.inHours)} ${(diff.inHours) == 1 ? "hr" : "hrs"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "min" : "mins"} ago";
    }
    return "Just now";
  }

  return Column(children: [
    Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: profileImage,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                    child: Text(
                      controller.post.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 10, 0, 0),
                    child: Text(
                      // "• ${timeago.format(DateTime.now().subtract(DateTime.now().difference(controller.post.timestamp)))}",
                      timeAgoCustom(controller.post.timestamp),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: ApdiColors.greyText,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
              //       child: Text(
              //         !controller.post.anonymous
              //             ? controller.post.writer.name
              //             : "Anonymous",
              //         style: Theme.of(context).textTheme.bodyText2?.copyWith(
              //               color: hexStringToColor("#AAAAAA"),
              //               fontFamily: 'Outfit',
              //               fontSize: 12,
              //               fontWeight: FontWeight.normal,
              //             ),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
              //       child: Text(
              //         // !controller.post.anonymous
              //         //     ? "• ${controller.getPostWriterSchool()}"
              //         //     : "• (Not Specified)",
              //         "• ${controller.getPostWriterSchool()}",
              //         style: Theme.of(context).textTheme.bodyText2?.copyWith(
              //               fontFamily: 'Outfit',
              //               color: hexStringToColor("#AAAAAA"),
              //               fontSize: 12,
              //               fontWeight: FontWeight.normal,
              //             ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => blockPostPopUp(context, controller));
            },
            child: SvgPicture.asset('assets/icons/more_vert.svg'),
          ),
        ],
      ),
    ),
  ]);
}

Widget contentUI(BuildContext context, PostController controller,
    {bool isDetail = false}) {
  double topPad = isDetail ? 16 : 8;

  Text titleWidget = Text(
    controller.post.title.isEmpty ? "No Title" : controller.post.title,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontFamily: 'Roboto',
          color: ApdiColors.lightText,
          fontSize: isDetail ? 20 : 16,
          fontWeight: FontWeight.w500,
        ),
  );
  Text bodyWidget = Text(
    controller.post.text.isEmpty ? "No Content" : controller.post.text,
    maxLines: isDetail ? 1000 : 2,
    style: Theme.of(context).textTheme.bodyText2?.copyWith(
          fontFamily: 'Roboto',
          color: isDetail ? ApdiColors.lightText : hexStringToColor("#AAAAAA"),
          fontSize: isDetail ? 16 : 14,
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.ellipsis,
        ),
  );
  return Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: isDetail ? SelectionArea(child: titleWidget) : titleWidget,
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, topPad, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: isDetail ? SelectionArea(child: bodyWidget) : bodyWidget,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget postUI(BuildContext context, PostController controller,
    {Function? setState,
    bool isDetail = false,
    bool saved = false,
    bool first = false}) {
  double topPad = first ? 16 : 0;
  return Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0, topPad, 0, 0),
    child: Padding(
      padding: EdgeInsetsDirectional.only(top: first ? 0 : 20),
      child: Container(
        decoration: BoxDecoration(
          border:
              BorderDirectional(bottom: BorderSide(color: ApdiColors.lineGrey)),
        ),
        child: TextButton(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent)),
          onPressed: () {
            if (isDetail) return;
            Navigator.pushNamed(context, 'post_detail',
                arguments: {'post': controller.post, 'saved': saved});
            setState!(controller.incrementView);
          },
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                writerInfoUI(context, controller),
                contentUI(context, controller, isDetail: isDetail),
                ViewCommentSave(
                    hexButtonColor: "#AAAAAA",
                    controller: controller,
                    showText: false,
                    saved: saved),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
