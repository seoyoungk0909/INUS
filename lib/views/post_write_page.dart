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
  Future<void> uploadPost(String currentUserId) async {
    DocumentReference newPost =
        await FirebaseFirestore.instance.collection("post").add({
      'title': postTitle.text.trim(),
      'content': postContent.text.trim(),
      'category': trueCategories,
      'time': Timestamp.now(),
      'viewCount': 0,
      'commentCount': 0,
      'saveCount': 0,
      'comments': [],
      'user': FirebaseFirestore.instance.doc('user_info/$currentUserId'),
    });
  }

  final TextEditingController postTitle = TextEditingController();
  final TextEditingController postContent = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, bool> categories = {
    'Just Talk': true,
    'Academic': false,
    '19+': false,
  };
  String trueCategories = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
            child: Text(
              " Category",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 55,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
              child: ListView(
                shrinkWrap: false,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (var category in categories.keys)
                    Row(children: <Widget>[
                      Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                            color: categories[category]!
                                ? Colors.white24
                                : Colors.transparent,
                            border: Border.all(
                                width: 0.5,
                                color: categories[category]!
                                    ? Colors.white24
                                    : Colors.white70),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                          onPressed: () {
                            for (var reset in categories.keys) {
                              categories[reset] = false;
                            }
                            setState(() {
                              categories[category] == true
                                  ? categories[category] = false
                                  : categories[category] = true;
                            });
                          },
                          child: Text(
                            category,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: categories[category]!
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                color: categories[category]!
                                    ? Color(0xff57AD9E)
                                    : Colors.white70),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 30, 0, 0),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          ),
          Center(
            child: SizedBox(
              width: 350,
              height: 48,
              child: TextField(
                  controller: postTitle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your title here.",
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.white24),
                  )),
            ),
          ),
          const Divider(
            color: Colors.white24,
            height: 0,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          ),
          Center(
            child: SizedBox(
              width: 350,
              height: 247,
              child: TextField(
                controller: postContent,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write your contents here.",
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.white24),
                ),
                maxLines: 10,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
          ),
          Center(
            child: SizedBox(
                width: 350,
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white60),
                  ),
                  onPressed: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Create Post'),
                            content: Text(
                                "Are you sure you want to create this post?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("No"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    for (var category in categories.keys) {
                                      categories[category] == true
                                          ? trueCategories = category
                                          : {};
                                    }
                                    uploadPost(currentUser.uid);
                                    setState(() {});
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/', (route) => false);
                                  },
                                  child: Text("yes"))
                            ],
                          );
                        });
                  },
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
