import 'package:aus/firebase_login_state.dart';
import 'package:aus/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import 'post_ui.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.title}) : super(key: key);
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  User defaultUser = User(userName: "", userSchool: School.PolyU);

  List<PostController> myPostsController = [
    PostController(Post(
      postWriter: User(userName: "John Doe", userSchool: School.HKUST),
      commentList: [
        Comment(content: "Good", isPostWriter: false),
        Comment(content: "Thank you", isPostWriter: true),
      ],
    )),
    PostController(Post(
      postWriter: User(userName: "Apple Seed", userSchool: School.CUHK),
      commentList: [Comment(content: "Good", isPostWriter: false)],
    )),
  ];

  List<PostController> savedPostsController = [
    PostController(
        Post(postWriter: User(userName: "Claire Eve", userSchool: School.HKU))),
  ];

  Widget userGreetings(User currentUser) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 20),
            child: Text(
              "Welcome, ${currentUser.name}",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Text(
                currentUser.getSchool(),
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w100,
                    color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
              child: TextButton(
                onPressed: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sign Out'),
                          content: Text("Are you sure you want to sign out?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "No",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  fbauth.FirebaseAuth.instance.signOut();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, 'login', (route) => false);
                                },
                                child: const Text("Yes")),
                          ],
                        );
                      });
                },
                child: Text(
                  "sign out",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: hexStringToColor("##57AD9E")),
                ),
              ),
            ),
          ],
        ),
      ],
    );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            Consumer<LoginState>(
                builder: (context, state, _) =>
                    userGreetings(state.currentUser ?? defaultUser)),
            const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "My Post"),
                Tab(text: "Saved"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: myPostsController.length,
                    itemBuilder: (BuildContext context, int index) {
                      return postUI(context, myPostsController[index],
                          setState: setState);
                    },
                  ),
                  ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: savedPostsController.length,
                    itemBuilder: (BuildContext context, int index) {
                      return postUI(context, savedPostsController[index],
                          setState: setState);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
