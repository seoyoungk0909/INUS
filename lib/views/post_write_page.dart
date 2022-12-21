import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PostWritePage> createState() => PostWritePageState();
}

class PostWritePageState extends State<PostWritePage> {
  Future<void> uploadPost() async {
    DocumentReference newPost =
        await FirebaseFirestore.instance.collection("post").add({
      'title': postTitle.text.trim(),
      'content': postContent.text.trim(),
      'catagory': '',
      'time': Timestamp.now(),
      'viewCount': 0,
      'commentCount': 0,
      'saveCount': 0,
      'comments': '',
      'user': currentUser.uid,
    });
  }

  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContent = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Category",
            ),
            Container(
              height: 50,
              child: ListView(
                itemExtent: 150,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Relationship',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Just Talk',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(
                        child: Text(
                      'Academic',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Title"),
            TextField(
                controller: postTitle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write Your Title Here",
                )),
            SizedBox(
              height: 50,
            ),
            Text("Content"),
            TextField(
                controller: postContent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Write Your Contents Here",
                )),
            SizedBox(
              height: 50,
            ),
            SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    uploadPost();
                    setState(() {});
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
