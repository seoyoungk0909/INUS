import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';

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
  User currentUser = User(userName: "red bird", userSchool: School.HKU);

  List<PostController> MyPostsController = [
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

  List<PostController> SavedPostsController = [
    PostController(
        Post(postWriter: User(userName: "Claire Eve", userSchool: School.HKU))),
  ];

  // PostController controller1 = PostController(Post(
  //   postWriter: User(userName: "John Doe", userSchool: School.HKUST),
  // ));
  // PostController controller2 = PostController(
  //     Post(postWriter: User(userName: "Apple Seed", userSchool: School.CUHK)));

  // PostController controller3 = PostController(
  //     Post(postWriter: User(userName: "Claire Eve", userSchool: School.HKU)));

  Widget userGreetings() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 30, 20, 20),
              child: Text(
                "Welcome, ${currentUser.name}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  fbauth.FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'login', (route) => false);
                },
                child: const Text("sign out")),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Text(
              currentUser.getSchool(),
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w100,
                  color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            userGreetings(),
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
                    itemCount: MyPostsController.length,
                    itemBuilder: (BuildContext context, int index) {
                      return postUI(context, MyPostsController[index],
                          setState: setState);
                    },
                  ),
                  ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: SavedPostsController.length,
                    itemBuilder: (BuildContext context, int index) {
                      return postUI(context, SavedPostsController[index],
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
