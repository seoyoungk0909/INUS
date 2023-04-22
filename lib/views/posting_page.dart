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
  bool popularEmptyConfirmed = false;
  bool recentEmptyConfirmed = false;

  Stream<DocumentSnapshot> snapshots = FirebaseFirestore.instance
      .collection('user_info')
      .doc(fba.FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  Future<void> refreshPosts({bool popular = false}) async {
    if (mounted) {
      setState(() {
        refreshing = true;
      });
    }
    List<Post> posts = await Post.getPostsFromFirebase(popular: popular);
    List<PostController> _controllers = [];
    for (Post post in posts) {
      _controllers.add(PostController(post));
    }
    if (mounted) {
      setState(() {
        if (popular) {
          popularEmptyConfirmed = _controllers.isEmpty;
          popularPostsControllers = _controllers;
        } else {
          recentEmptyConfirmed = _controllers.isEmpty;
          recentPostsControllers = _controllers;
        }
        refreshing = false;
      });
    }
  }

  Widget postsStreamView(List filteredPostControllers,
      {List? savedPosts, bool popular = false}) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshPosts(popular: popular);
      },
      color: ApdiColors.themeGreen,
      child: ListView.builder(
        // physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filteredPostControllers.length,
        itemBuilder: (BuildContext context, int i) {
          bool saved = savedPosts
                  ?.contains(filteredPostControllers[i].post.firebaseDocRef) ??
              false;
          return PostUI(
              controller: filteredPostControllers[i],
              saved: saved,
              first: i == 0);
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

  Widget postView(snapshot, {bool popular = false}) {
    if ((recentEmptyConfirmed && !popular) ||
        (popularEmptyConfirmed && popular)) {
      return RefreshIndicator(
          onRefresh: () async {
            refreshPosts(popular: popular);
          },
          color: ApdiColors.themeGreen,
          child: Center(child: Text("No posts")));
    }
    if (recentPostsControllers.isEmpty || snapshot.data == null) {
      return Center(
          child: CircularProgressIndicator(color: ApdiColors.themeGreen));
    }
    Map documentdata = snapshot.data!.data() as Map;
    List? savedPosts = documentdata.containsKey('savedPosts')
        ? documentdata['savedPosts']
        : null;
    List? blockedPosts = documentdata.containsKey('blockedPosts')
        ? documentdata['blockedPosts']
        : null;
    List? blockedUsers = documentdata.containsKey('blockedUsers')
        ? documentdata['blockedUsers']
        : null;

    List<PostController> _controllers =
        popular ? popularPostsControllers : recentPostsControllers;
    List<PostController> filteredPostControllers = [];
    for (PostController ctrl in _controllers) {
      bool postBlock =
          blockedPosts?.contains(ctrl.post.firebaseDocRef) ?? false;
      bool userBlock =
          blockedUsers?.contains(ctrl.post.writer.userReference) ?? false;
      if (!postBlock && !userBlock) {
        filteredPostControllers.add(ctrl);
      }
    }
    if (filteredPostControllers.isEmpty) {
      return RefreshIndicator(
          onRefresh: () async {
            refreshPosts(popular: popular);
          },
          color: ApdiColors.themeGreen,
          child: Center(child: Text("No posts")));
    }
    return postsStreamView(filteredPostControllers,
        popular: popular, savedPosts: savedPosts);
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
              labelStyle: (TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto')),
              unselectedLabelStyle: (TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffa3a3a3))),
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Recent"),
                Tab(text: "Popular"),
              ],
            ),
            Divider(
              color: ApdiColors.lineGrey,
              height: 0,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(
              child: KeepAliveStreamBuilder(
                stream: snapshots,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  return TabBarView(
                    children: [
                      //recent
                      postView(snapshot, popular: false),
                      postView(snapshot, popular: true),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
