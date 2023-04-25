import 'package:aus/views/components/custom_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

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
  bool isAnonymous = false;
  // bool isEnglish = false;

  Future<void> uploadPost(String currentUserId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.doc('user_info/$currentUserId');
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
      'user': userRef,
      'isAnonymous': isAnonymous,
      'deleted': false,
      'reportCount': 0,
      'reports': [],
      'points': (trueCategories == "19+") ? -50 : 0,
      // 'isEnglish': isEnglish,
    });
    userRef.update({
      'myPosts': FieldValue.arrayUnion([newPost])
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

  bool isButtonEnabled = false;

  Map<String, bool> textChecker = {
    'Title': false,
    'Contents': false,
  };
  void textChecking() {
    if (textChecker['Title']! && textChecker['Contents']!) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

  Widget categorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
              text: "Category",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600),
              children: [
                TextSpan(
                    text: ' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16))
              ]),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 16),
          child: SizedBox(
            height: 36,
            child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, idx) {
                List<String> keys = categories.keys.toList();
                var category = keys[idx];
                return Container(
                  width: 100,
                  height: 36,
                  margin: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
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
                      textStyle:
                          const TextStyle(fontSize: 14, color: Colors.white),
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
                          fontSize: 14,
                          fontWeight: categories[category]!
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: categories[category]!
                              ? Color(0xff57AD9E)
                              : Colors.white70),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget anonymousSelector() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          // NOTE: this is needed to remove default padding of checkbox
          // match the width with the page padding value.
          SizedBox(
            width: 20,
            child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
                value: isAnonymous,
                onChanged: (bool? value) {
                  setState(() {
                    isAnonymous = value!;
                  });
                }),
          ),
          const SizedBox(width: 8),
          const Text(
            "Anonymous Post",
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }

  Widget titleAndContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 20),
          child: Center(
            child: SizedBox(
              width: 350,
              height: 48,
              child: TextField(
                  controller: postTitle,
                  onChanged: (content) {
                    if (content != "") {
                      textChecker['Title'] = true;
                      textChecking();
                    } else {
                      textChecker['Title'] = false;
                      textChecking();
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your title here.",
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.white24),
                  )),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
          child: Divider(
            color: Colors.white24,
            height: 0,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
        ),
        Center(
          child: SizedBox(
            width: 350,
            height: 240,
            child: TextField(
              controller: postContent,
              onChanged: (content) {
                if (content != "") {
                  textChecker['Contents'] = true;
                  textChecking();
                } else {
                  textChecker['Contents'] = false;
                  textChecking();
                }
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Write your contents here.",
                hintStyle: TextStyle(fontSize: 16.0, color: Colors.white24),
              ),
              maxLines: null,
            ),
          ),
        ),
      ],
    );
  }

  void createPost(BuildContext context) {
    for (var category in categories.keys) {
      categories[category] == true ? trueCategories = category : {};
    }
    uploadPost(currentUser.uid);
    setState(() {});
    Navigator.pushNamedAndRemoveUntil(
        context, '/', arguments: {'postpage': true}, (route) => false);
  }

  Widget postButton() {
    return SizedBox(
        width: 350,
        height: 46,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            backgroundColor: MaterialStateProperty.all(
                isButtonEnabled ? ApdiColors.themeGreen : Colors.white60),
          ),
          onPressed: () {
            if (isButtonEnabled) {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return createPopUp(
                        context,
                        "Create Post",
                        "Are you sure you want to create this post?",
                        createPost);
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Warning',
                        style: TextStyle(fontSize: 16),
                      ),
                      content: const Text(
                        "You have not filled certain parts. Please check again.",
                        style: TextStyle(fontSize: 12),
                      ),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "OK",
                              style: TextStyle(color: ApdiColors.themeGreen),
                            ))
                      ],
                    );
                  });
            }
            //   showDialog<void>(
            //       context: context,
            //       builder: (BuildContext context) {
            //         if (isButtonEnabled) {
            //           return AlertDialog(
            //             title: const Text(
            //               'Create Post',
            //               style: TextStyle(fontSize: 16),
            //             ),
            //             content: const Text(
            //               "Are you sure you want to create this post?",
            //               style: TextStyle(fontSize: 12),
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () => Navigator.pop(context),
            //                 child: Text(
            //                   "No",
            //                   style: TextStyle(color: ApdiColors.errorRed),
            //                 ),
            //               ),
            //               TextButton(
            //                   onPressed: () {
            //                     for (var category in categories.keys) {
            //                       categories[category] == true
            //                           ? trueCategories = category
            //                           : {};
            //                     }
            //                     uploadPost(currentUser.uid);
            //                     setState(() {});
            //                     Navigator.pushNamedAndRemoveUntil(
            //                         context,
            //                         '/',
            //                         arguments: {'postpage': true},
            //                         (route) => false);
            //                   },
            //                   child: Text(
            //                     "Yes",
            //                     style: TextStyle(color: ApdiColors.themeGreen),
            //                   ))
            //             ],
            //           );
            //         }
            //         return AlertDialog(
            //           title: const Text(
            //             'Warning',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //           content: const Text(
            //             "You have not filled certain parts. Please check again.",
            //             style: TextStyle(fontSize: 12),
            //           ),
            //           actions: <Widget>[
            //             TextButton(
            //                 onPressed: () => Navigator.pop(context),
            //                 child: Text(
            //                   "OK",
            //                   style: TextStyle(color: ApdiColors.themeGreen),
            //                 ))
            //           ],
            //         );
            //       });
          },
          child: const Text(
            'Post',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Outfit',
              fontWeight: FontWeight.w600,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApdiColors.darkerBackground,
      appBar: AppBar(
        backgroundColor: ApdiColors.darkBackground,
        title: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return discardWritingsPopUp(context);
                });
            // showDialog<void>(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //         title: const Text(
            //           'Discard Writings',
            //           style: TextStyle(fontSize: 16),
            //         ),
            //         content: const Text(
            //           "Are you sure you want to go back to the main page? (All you have written will be lost!) ",
            //           style: TextStyle(fontSize: 12),
            //         ),
            //         actions: <Widget>[
            //           TextButton(
            //             onPressed: () => Navigator.pop(context),
            //             child: Text(
            //               "No",
            //               style: TextStyle(color: ApdiColors.errorRed),
            //             ),
            //           ),
            //           TextButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //                 Navigator.pop(context);
            //               },
            //               child: Text(
            //                 "Yes",
            //                 style: TextStyle(color: ApdiColors.themeGreen),
            //               ))
            //         ],
            //       );
            //     });
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    categorySelector(),
                    // anonymousSelector(),
                    titleAndContent(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 0, bottom: 8),
                child: Center(child: postButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
