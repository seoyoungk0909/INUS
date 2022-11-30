import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import 'post_ui.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  PostController controller1 = PostController(Post(
    postWriter: User(userName: "John Doe", userSchool: School.HKUST),
  ));
  PostController controller2 = PostController(
      Post(postWriter: User(userName: "Apple Seed", userSchool: School.CUHK)));

  PostController controller3 = PostController(
      Post(postWriter: User(userName: "Claire Eve", userSchool: School.HKU)));

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: const TabBar(
                  tabs: [
                    Tab(text: "Recent"),
                    Tab(text: "Popular"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    postListView([
                      postUI(context, controller1, setState: setState),
                      postUI(context, controller2, setState: setState)
                    ]),
                    postListView(
                        [postUI(context, controller3, setState: setState)]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
