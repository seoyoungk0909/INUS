import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../../controllers/post_controller.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({Key? key, required this.controller}) : super(key: key);

  final PostController controller;

  @override
  CommentBoxState createState() => CommentBoxState();
}

class CommentBoxState extends State<CommentBox> {
  // String userEnterMessage = '';
  bool typed = false;
  TextEditingController commentController = TextEditingController();

  bool isWriter() {
    return widget.controller.post.writer.uid ==
        FirebaseAuth.instance.currentUser?.uid;
  }

  Future<void> saveComments(post) async {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('user_info')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    userRef.update({
      'myComments': FieldValue.arrayUnion([post.firebaseDocRef])
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      double bottomPad = isKeyboardVisible ? 0 : 52;
      return Container(
          // margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.fromLTRB(20, 8, 16, bottomPad),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              border: BorderDirectional(
                  top: BorderSide(color: ApdiColors.lineGrey))),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    // labelText: 'Write your comment',
                    hintText: 'Write your comment',
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white30,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      typed = value.trim().isNotEmpty;
                    });
                  },
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: ApdiColors.themeGreen,
                    textStyle: TextStyle(fontSize: 15)),
                onPressed: !typed
                    ? null
                    : () {
                        FirebaseFirestore.instance
                            .collection('post_comment')
                            .add({
                          'body': commentController.text,
                          'writerFlag': isWriter(),
                          'time': DateTime.now(),
                          'writer': FirebaseFirestore.instance
                              .collection('user_info')
                              .doc(FirebaseAuth.instance.currentUser?.uid),
                        }).then((DocumentReference newComment) {
                          widget.controller.addComment(newComment);
                          commentController.clear();
                          setState(() {
                            typed = false;
                          });
                        });
                        saveComments(widget.controller.post);
                      },
                child: const Text("Post"),
              ),
            ],
          ));
    });
  }
}
