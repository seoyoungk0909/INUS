import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
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
  Stream<QuerySnapshot<Map<String, dynamic>>> recentStream =
      Post.getPostsQuery(popular: false).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> popularStream =
      Post.getPostsQuery(popular: true).snapshots();

  Future<DocumentSnapshot> snapshots = FirebaseFirestore.instance
      .collection('user_info')
      .doc(fba.FirebaseAuth.instance.currentUser?.uid)
      .get();
  // Future<void> refreshPosts({bool popular = false}) async {
  // List<Post> posts = await Post.getPostsFromFirebase(popular: popular);
  // List<PostController> _controllers = [];
  // for (Post post in posts) {
  //   _controllers.add(PostController(post));
  // }
  // setState(() {
  //   if (popular) {
  //     popularPostsControllers = _controllers;
  //   } else {
  //     recentPostsControllers = _controllers;
  //   }
  // });
  // }

  Widget postsStreamView(Stream<QuerySnapshot<Map<String, dynamic>>> postStream,
      {List? savedPosts}) {
    return
        // RefreshIndicator(
        //   onRefresh: () async {
        //     refreshPosts(popular: popular);
        //   },
        //   color: Theme.of(context).backgroundColor,
        //   child:
        StreamBuilder(
      stream: postStream,
      builder:
          (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
        if (snap.data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          // physics: const AlwaysScrollableScrollPhysics(),
          itemCount: snap.data!.size,
          itemBuilder: (BuildContext context, int i) {
            return FutureBuilder<Post>(
              future: Post.fromDocRef(firebaseSnap: snap.data!.docs[i]),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink(); //NOTE: empty widget
                }
                bool saved =
                    savedPosts?.contains(snapshot.data!.firebaseDocRef) ??
                        false;
                return postUI(context, PostController(snapshot.data!),
                    setState: setState, saved: saved);
              },
            );
          },
        );
      },
      // ),
    );
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
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        Map documentdata = snapshot.data!.data() as Map;
                        List? savedPosts =
                            documentdata.containsKey('savedPosts')
                                ? documentdata['savedPosts']
                                : null;
                        return postsStreamView(recentStream,
                            savedPosts: savedPosts);
                      }),
                  KeepAliveFutureBuilder(
                      future: snapshots,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        Map documentdata = snapshot.data!.data() as Map;
                        List? savedPosts =
                            documentdata.containsKey('savedPosts')
                                ? documentdata['savedPosts']
                                : null;
                        return postsStreamView(popularStream,
                            savedPosts: savedPosts);
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
