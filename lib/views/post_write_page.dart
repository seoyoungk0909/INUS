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
      'catagory': trueCategories,
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
    'Relationship': false,
    '19+': false,
    'Just Talk': false,
    'Academic': false,
    'Tips': false
  };
  final List trueCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          ),
          Text(
            " Category",
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          ),
          Container(
            height: 50,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(4.0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (var category in categories.keys)
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5,
                            color: categories[category]!
                                ? Colors.blue
                                : Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      onPressed: () {
                        trueCategories.add(category);
                        setState(() {
                          categories[category] == true
                              ? categories[category] = false
                              : categories[category] = true;
                        });
                      },
                      child: Text(
                        category,
                        style: TextStyle(
                            fontSize: 20,
                            color: categories[category]!
                                ? Colors.blue
                                : Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          ),
          Text(
            " Title",
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          ),
          Center(
            child: SizedBox(
              width: 370,
              child: TextField(
                  controller: postTitle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Write Your Title Here",
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
          ),
          Text(
            " Content",
            style: TextStyle(fontSize: 25),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          ),
          Center(
            child: SizedBox(
              width: 370,
              child: TextField(
                  controller: postContent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Write Your Contents Here",
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
          ),
          Center(
            child: SizedBox(
                width: 370,
                height: 50,
                child: ElevatedButton(
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
                                    uploadPost(currentUser.uid);
                                    setState(() {});
                                    Navigator.pushNamed(
                                      context,
                                      '/',
                                    );
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
