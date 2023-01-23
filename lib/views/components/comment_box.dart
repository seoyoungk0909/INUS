import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controllers/post_controller.dart';

class CommentBox extends StatefulWidget {
  const CommentBox({Key? key, required this.controller}) : super(key: key);

  final PostController controller;

  @override
  CommentBoxState createState() => CommentBoxState();
}

class CommentBoxState extends State<CommentBox> {
  String userEnterMessage = '';

  bool isWriter() {
    return widget.controller.post.writer.uid ==
        FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  // labelText: 'Write your comment',
                  hintText: 'Write your comment',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    userEnterMessage = value;
                  });
                },
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                if (userEnterMessage.trim().isEmpty) {
                  return;
                }
                FirebaseFirestore.instance.collection('post_comment').add({
                  'body': userEnterMessage,
                  'writerFlag': isWriter(),
                  'time': DateTime.now(),
                }).then((DocumentReference newComment) {
                  widget.controller.addComment(newComment);
                });
              },
              child: const Text("Post"),
            ),
          ],
        ));
  }
}
