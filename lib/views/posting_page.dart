import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../utils/color_utils.dart';
import 'components/post_ui.dart';
import 'components/keep_alive_builder.dart';

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
  bool refreshing = false;
  List<PostController> popularPostsControllers = [];
  List<PostController> recentPostsControllers = [];

  Future<DocumentSnapshot> snapshots = FirebaseFirestore.instance
      .collection('user_info')
      .doc(fba.FirebaseAuth.instance.currentUser?.uid)
      .get();

  Future<void> refreshPosts({bool popular = false}) async {
    setState(() {
      refreshing = true;
    });
    List<Post> posts = await Post.getPostsFromFirebase(popular: popular);
    List<PostController> _controllers = [];
    for (Post post in posts) {
      _controllers.add(PostController(post));
    }
    setState(() {
      if (popular) {
        popularPostsControllers = _controllers;
      } else {
        recentPostsControllers = _controllers;
      }
      refreshing = false;
    });
  }

  Widget postsStreamView({List? savedPosts, bool popular = false}) {
    List<PostController> controllers =
        popular ? popularPostsControllers : recentPostsControllers;
    return RefreshIndicator(
      onRefresh: () async {
        refreshPosts(popular: popular);
      },
      color: ApdiColors.themeGreen,
      child: ListView.builder(
        // physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controllers.length,
        itemBuilder: (BuildContext context, int i) {
          bool saved =
              savedPosts?.contains(controllers[i].post.firebaseDocRef) ?? false;
          return postUI(context, controllers[i],
              setState: setState, saved: saved, first: i == 0);
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshPosts(popular: true);
    refreshPosts(popular: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Recent"),
                Tab(text: "Popular"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  KeepAliveFutureBuilder(
                      future: snapshots,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (recentPostsControllers.isEmpty ||
                            snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ApdiColors.themeGreen));
                        }
                        Map documentdata = snapshot.data!.data() as Map;
                        List? savedPosts =
                            documentdata.containsKey('savedPosts')
                                ? documentdata['savedPosts']
                                : null;
                        return postsStreamView(
                            popular: false, savedPosts: savedPosts);
                      }),
                  KeepAliveFutureBuilder(
                      future: snapshots,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (popularPostsControllers.isEmpty ||
                            snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ApdiColors.themeGreen));
                        }
                        Map documentdata = snapshot.data!.data() as Map;
                        List? savedPosts =
                            documentdata.containsKey('savedPosts')
                                ? documentdata['savedPosts']
                                : null;
                        return postsStreamView(
                            popular: true, savedPosts: savedPosts);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
