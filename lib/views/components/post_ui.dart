import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/post_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //view
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
                  // TODO: use eye-open
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: hexStringToColor(widget.hexButtonColor),
                    size: 24,
                  ),
                ),
                widget.showText
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: Text(
                          'View',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                fontFamily: 'Outfit',
                                color: hexStringToColor(widget.hexButtonColor),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                  child: Text(
                    widget.controller.post.views.toString(),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontFamily: 'Outfit',
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
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 0, 8),
                  // child: Icon(
                  //   Icons.comment,
                  //   color: hexStringToColor(hexButtonColor),
                  //   size: 24,
                  // ),
                  child: SvgPicture.asset(
                    'assets/icons/message-square-typing.svg',
                    color: hexStringToColor(widget.hexButtonColor),
                    height: 24,
                  ),
                ),
                widget.showText
                    ? Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                        child: Text(
                          'Comment',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                fontFamily: 'Outfit',
                                color: hexStringToColor(widget.hexButtonColor),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                  child: Text(
                    widget.controller.post.numComments().toString(),
                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          fontFamily: 'Outfit',
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
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
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
                        height: 24,
                      )),
                  widget.showText
                      ? Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                          child: Text(
                            saved ? 'Saved' : 'Save',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                  fontFamily: 'Outfit',
                                  color:
                                      hexStringToColor(widget.hexButtonColor),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 6, 0),
                          child: Text(
                            widget.controller.post.saveCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.copyWith(
                                  fontFamily: 'Outfit',
                                  color:
                                      hexStringToColor(widget.hexButtonColor),
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
      ),
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
  return Column(children: [
    Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 40,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: profileImage,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Text(
                      controller.post.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Text(
                      "• ${timeago.format(DateTime.now().subtract(DateTime.now().difference(controller.post.timestamp)))}",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Outfit',
                            color: hexStringToColor("#AAAAAA"),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                    child: Text(
                      controller.post.writer.name,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            color: hexStringToColor("#AAAAAA"),
                            fontFamily: 'Outfit',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                    child: Text(
                      "• ${controller.getPostWriterSchool()}",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Outfit',
                            color: hexStringToColor("#AAAAAA"),
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  ]);
}

Widget contentUI(BuildContext context, PostController controller,
    {bool isDetail = false}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                controller.post.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                controller.post.text,
                maxLines: isDetail ? 1000 : 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Outfit',
                      color: hexStringToColor("#AAAAAA"),
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget postUI(BuildContext context, PostController controller,
    {Function? setState, bool isDetail = false, bool saved = false}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: hexStringToColor("#3E3E3E"),
        // boxShadow: const [
        //   BoxShadow(
        //     blurRadius: 5,
        //     color: Color(0x3416202A),
        //     offset: Offset(0, 3),
        //   )
        // ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            writerInfoUI(context, controller),
            GestureDetector(
              onTap: () {
                if (isDetail) return;
                Navigator.pushNamed(context, 'post_detail',
                    arguments: {'post': controller.post, 'saved': saved});
                setState!(controller.incrementView);
              },
              child: contentUI(context, controller, isDetail: isDetail),
            ),
            ViewCommentSave(
                hexButtonColor: "#AAAAAA",
                controller: controller,
                showText: !isDetail,
                saved: saved),
            const Divider(
              height: 8,
              thickness: 1,
              color: Color.fromARGB(255, 74, 74, 74),
            ),
          ],
        ),
      ),
    ),
  );
}
