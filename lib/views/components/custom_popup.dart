import 'package:aus/controllers/event_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../views/more_page.dart';
import 'package:aus/views/components/event_ui.dart';
import '../../controllers/post_controller.dart';
import '../../utils/color_utils.dart';
import '../../models/comment_model.dart';
// import 'popup_dialog.dart';

BoxDecoration boxDeco = const BoxDecoration(
  color: Color(0x1C1C1C),
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(8.0),
    topRight: Radius.circular(8.0),
  ),
);

ElevatedButton leftButton(BuildContext context, String text) {
  return ElevatedButton(
    onPressed: () => Navigator.pop(context),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(hexStringToColor('#282828')),
        textStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 16,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ))),
    child: Text(text),
  );
}

ButtonStyle rightButtonStyle() {
  return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(hexStringToColor('#4CA88F')),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontSize: 16,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
      )));
}

Widget signOutPopUp(BuildContext context, {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Sign Out?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText("Are you sure you want to sign out?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#A3A3A3'),
                      fontSize: 14,
                      fontWeight: FontWeight.w400))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "Go Back"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      userSignOut(context);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes, Sign Out",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget deletePopUp(BuildContext context, {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Delete your account",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#FFFFFF'),
                        fontSize: 20,
                      ))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText(
                  "Once you delete your account, it can't be restored.",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "Go Back"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      //delete user
                      userDelete(context);
                      //popup - "sorry to see you go"
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            decoration: boxDeco,
                            child: Column(children: [
                              Center(
                                child: Container(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 30),
                                    child: SelectableText(
                                        "Sorry to see you go!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                                fontFamily: 'Roboto',
                                                color:
                                                    hexStringToColor('#FFFFFF'),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))),
                              ),
                              Center(
                                child: Container(
                                    padding:
                                        EdgeInsetsDirectional.only(top: 10),
                                    child: SelectableText(
                                        "Your account has been successfully deleted.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            ?.copyWith(
                                              fontFamily: 'Roboto',
                                              color:
                                                  hexStringToColor('#A3A3A3'),
                                              fontSize: 14,
                                            ))),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsetsDirectional.only(top: 30),
                                  child: Center(
                                    child: SizedBox(
                                      width: 170,
                                      height: 50,
                                      child: ElevatedButton(
                                        //return to login page
                                        onPressed: () => userSignOut(context),
                                        style: rightButtonStyle(),
                                        child: const Text('Close'),
                                      ),
                                    ),
                                  ))
                            ]),
                          );
                        },
                      );
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes, Delete",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget commentDeletePopUp(BuildContext context, Comment comment) {
  return Container(
    height: 100,
    decoration: BoxDecoration(
      color: ApdiColors.darkBackground,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return deleteCommentPopUp(context, comment);
                          });
                      // popUpDialog(
                      //   context,
                      //   "Delete reply?",
                      //   "Once you delete this reply, it can’t be restored.",
                      //   closeText: 'No',
                      //   action: TextButton(
                      //     onPressed: () {
                      //       //delete comment
                      //       comment.commentReference?.update({'deleted': true});
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //     },
                      //     child: Text(
                      //       'Yes',
                      //       style: TextStyle(color: ApdiColors.themeGreen),
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text("Delete",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: ApdiColors.errorRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget blockPostPopUp(
    BuildContext context, PostController controller, Function? setState) {
  bool isCurrentUserWriter = FirebaseAuth.instance.currentUser?.uid ==
      controller.post.writer.userReference?.id;
  return Container(
      height: isCurrentUserWriter ? 100 : 140,
      decoration: BoxDecoration(
        color: ApdiColors.darkBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
          padding: EdgeInsetsDirectional.only(top: 20),
          child: Column(children: [
            // Block User
            isCurrentUserWriter
                ? SizedBox.shrink()
                : Center(
                    child: InkWell(
                    onTap: () {
                      DocumentReference userRef = FirebaseFirestore.instance
                          .collection('user_info')
                          .doc(FirebaseAuth.instance.currentUser!.uid);
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return blockHideUserPopUp(
                                context,
                                "Block the user of this post",
                                "Do you want to block the user of this post?\n(All the posts of this user will not appear on your feed.)",
                                userRef,
                                controller,
                                true);
                          });
                      // popUpDialog(context, "Block the user of this post",
                      //     "Do you want to block the user of this post?\n(All the posts of this user will not appear on your feed.)",
                      //     action: TextButton(
                      //       onPressed: () {
                      //         if (userRef !=
                      //             controller.post.writer.userReference) {
                      //           userRef.update({
                      //             'blockedUsers': FieldValue.arrayUnion(
                      //                 [controller.post.writer.userReference])
                      //           });
                      //           Navigator.pop(context);
                      //           Navigator.pop(context);
                      //         } else {
                      //           showDialog<void>(
                      //               context: context,
                      //               builder: (BuildContext context) {
                      //                 return AlertDialog(
                      //                   title: const Text(
                      //                     'Warning',
                      //                     style: TextStyle(fontSize: 16),
                      //                   ),
                      //                   content: const Text(
                      //                     'You cannot block yourself. Please check again.',
                      //                     style: TextStyle(fontSize: 12),
                      //                   ),
                      //                   actions: <Widget>[
                      //                     TextButton(
                      //                         onPressed: () {
                      //                           Navigator.pop(context);
                      //                           Navigator.pop(context);
                      //                         },
                      //                         child: Text(
                      //                           'OK',
                      //                           style: TextStyle(
                      //                               color:
                      //                                   ApdiColors.themeGreen),
                      //                         ))
                      //                   ],
                      //                 );
                      //               });
                      //         }
                      //   },
                      //   child: const Text("Yes"),
                      // ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: const Text(
                        "Block User",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  )),
            // Hide Post
            isCurrentUserWriter
                ? SizedBox.shrink()
                : Center(
                    child: InkWell(
                    onTap: () {
                      DocumentReference userRef = FirebaseFirestore.instance
                          .collection('user_info')
                          .doc(FirebaseAuth.instance.currentUser!.uid);
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return blockHideUserPopUp(
                                context,
                                "Don't show this post",
                                "Do you want to remove this post from your feed?\n(This will also remove this post from your saved posts.)",
                                userRef,
                                controller,
                                false);
                          });
                      // popUpDialog(context, "Don't show this post",
                      //     "Do you want to remove this post from your feed?\n(This will also remove this post from your saved posts.)",
                      //     action: TextButton(
                      //         onPressed: () {
                      //           userRef.update({
                      //             'blockedPosts': FieldValue.arrayUnion(
                      //                 [controller.post.firebaseDocRef])
                      //           });
                      //           // remove from saved
                      //           userRef.update({
                      //             'savedPosts': FieldValue.arrayRemove(
                      //                 [controller.post.firebaseDocRef])
                      //           });
                      //           // TODO: need to decrement saveCount of the post
                      //           Navigator.pop(context);
                      //           Navigator.pop(context);

                      //           popUpDialog(context, "Removed Post",
                      //               "Do you also want to report this post?",
                      //               action: TextButton(
                      //                   onPressed: () {
                      //                     Navigator.pop(context);
                      //                     Navigator.pushNamed(context, 'report',
                      //                         arguments: {
                      //                           'post': controller.post
                      //                         });
                      //                   },
                      //                   child: const Text("Yes")));
                      //         },
                      //         child: const Text("Yes")));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: const Text(
                        "Hide Post",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  )),
            // Delete
            isCurrentUserWriter
                ? Center(
                    child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return deletePostPopUp(
                                context, controller, setState);
                          });
                      // DocumentReference userRef = FirebaseFirestore.instance
                      //     .collection('user_info')
                      //     .doc(FirebaseAuth.instance.currentUser!.uid);
                      // popUpDialog(context, "Delete post?",
                      //     "Once you delete this post, it cannot be restored.",
                      //     action: TextButton(
                      //       onPressed: () {
                      //         if (setState != null) {
                      //           setState(() {
                      //             print('delete');
                      //             controller.lazyDeletePost();
                      //           });
                      //         }
                      //         Navigator.pop(context);
                      //         Navigator.pop(context);
                      //       },
                      //       child: Text(
                      //         "Yes",
                      //         style: TextStyle(color: ApdiColors.errorRed),
                      //       ),
                      //     ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ApdiColors.errorRed),
                      ),
                    ),
                  ))
                : SizedBox.shrink(),
          ])));
}

Widget hideEventPopUp(BuildContext context, EventController controller,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Don't show this event",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText(
                  "Do you want to remove this event from your feed?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "Close"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // hide event
                      hideEvent(context, controller);

                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return reportEventPopUp(context, controller);
                          });
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget reportEventPopUp(BuildContext context, EventController controller,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Removed event",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText("Do you also want to report this event?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "Close"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // report event
                      reportEvent(context, controller);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget reportPostPopUp(
    BuildContext context, DocumentReference userRef, PostController controller,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Removed post",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText("Do you also want to report this post?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "Close"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // report post
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'report',
                          arguments: {'post': controller.post});
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget createPopUp(BuildContext context, String title, String body,
    void Function(BuildContext) function,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText(title,
                  // "Create Event"
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              child: SelectableText(body,
                  // "Are you sure you want to create this event?"
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        color: hexStringToColor('#A3A3A3'),
                        fontSize: 14,
                      ))),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "No"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // create event
                      function(context);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget discardWritingsPopUp(BuildContext context, {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Discard Writings",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: SelectableText(
                "Are you sure you want to go back to the main page? (All you have written will be lost!)",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: hexStringToColor('#A3A3A3'),
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              )),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "No"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget blockHideUserPopUp(BuildContext context, String title, String body,
    DocumentReference userRef, PostController controller, bool isBlock,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText(title,
                  // "Block the user of this post"
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: SelectableText(
                body,
                // "Do you want to block the user of this post?\n(All the posts of this user will not appear on your feed.)"
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: hexStringToColor('#A3A3A3'),
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              )),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "No"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (isBlock) {
                        userRef.update({
                          'blockedUsers': FieldValue.arrayUnion(
                              [controller.post.writer.userReference])
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        userRef.update({
                          'blockedPosts': FieldValue.arrayUnion(
                              [controller.post.firebaseDocRef])
                        });
                        // remove from saved
                        userRef.update({
                          'savedPosts': FieldValue.arrayRemove(
                              [controller.post.firebaseDocRef])
                        });
                        // TODO: need to decrement saveCount of the post
                        Navigator.pop(context);
                        Navigator.pop(context);

                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return reportPostPopUp(
                                  context, userRef, controller);
                            });
                      }
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget deleteCommentPopUp(BuildContext context, Comment comment,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Delete reply?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: SelectableText(
                "Once you delete this reply, it can’t be restored.",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: hexStringToColor('#A3A3A3'),
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              )),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "No"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      comment.commentReference?.update({'deleted': true});
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget deletePostPopUp(
    BuildContext context, PostController controller, Function? setState,
    {Widget? action}) {
  return Container(
    height: 200,
    decoration: boxDeco,
    child: Column(
      children: [
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.only(top: 30),
              child: SelectableText("Delete post?",
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      color: hexStringToColor('#FFFFFF'),
                      fontSize: 20,
                      fontWeight: FontWeight.w500))),
        ),
        Center(
          child: Container(
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: SelectableText(
                "Once you delete this post, it cannot be restored.",
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      color: hexStringToColor('#A3A3A3'),
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              )),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //go back
              SizedBox(
                width: 170,
                height: 50,
                child: leftButton(context, "No"),
              ),
              //sign out
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (setState != null) {
                        setState(() {
                          print('delete');
                          controller.lazyDeletePost();
                        });
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: rightButtonStyle(),
                    child: SelectableText("Yes",
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontFamily: 'Roboto',
                            color: hexStringToColor('#FFFFFF'),
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
