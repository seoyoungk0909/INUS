import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventWritePage extends StatefulWidget {
  const EventWritePage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventWritePage> createState() => EventWritePageState();
}

class EventWritePageState extends State<EventWritePage> {
  Future<void> uploadPost(String currentUserId) async {
    DocumentReference newPost =
        await FirebaseFirestore.instance.collection("post").add({
      'title': eventTitle.text.trim(),
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

  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController postContent = TextEditingController();
  final User currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, bool> categories = {
    'Party': true,
    'Workshop': false,
    'Seminar': false,
    'Webinar': false,
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
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
            child: Text(
              " Title",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: SizedBox(
              width: 340,
              height: 50,
              child: TextField(
                  controller: eventTitle,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.white24), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Input event name",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.white10),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
            child: Row(children: [
              Text(
                " Title",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                " (max. 1-2)",
                style: TextStyle(fontSize: 16, color: Colors.white10),
              ),
            ]),
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
