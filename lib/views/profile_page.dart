import 'package:aus/firebase_login_state.dart';
import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/keep_alive_builder.dart';
import 'components/post_ui.dart';
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
  User defaultUser = User(userName: "", userSchool: School.Loading);

  // Stream<DocumentSnapshot<Map<String, dynamic>>> userInfoStream =
  //     FirebaseFirestore.instance
  //         .collection('user_info')
  //         .doc(fbauth.FirebaseAuth.instance.currentUser?.uid)
  //         .snapshots();

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

  Future<List<Post>> getPostsFromRefs(postRefs) async {
    List<Post> posts = [];
    for (DocumentReference<Map<String, dynamic>> ref in postRefs) {
      posts.add(await Post.fromDocRef(firebaseDoc: ref));
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () => Navigator.pushNamed(context, 'more'),
                icon: Icon(Icons.more_horiz_rounded))
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Consumer<LoginState>(
          builder: (context, state, _) => Column(
            children: [
              userGreetings(state.currentUser ?? defaultUser),
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
                    KeepAliveStreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_info')
                            .doc(state.currentUser?.uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<dynamic> snap) {
                          if (snap.data == null) {
                            print(snap);
                            print(snap.data);
                            return Center(
                                child: CircularProgressIndicator(
                                    color: ApdiColors.themeGreen));
                          }
                          try {
                            Map<String, dynamic> data = snap.data!.data()!;
                            List postRefs = data['myPosts'];
                            postRefs = postRefs.reversed.toList();
                            List savedPostRefs = [];
                            if (data.containsKey('savedPosts')) {
                              savedPostRefs = data['savedPosts'];
                            }
                            if (postRefs.isEmpty) {
                              return const Center(child: Text("No Posts"));
                            }
                            return FutureBuilder<List<Post>>(
                              future: getPostsFromRefs(postRefs),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.builder(
                                  // physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    bool saved = savedPostRefs.isNotEmpty &&
                                        savedPostRefs.contains(postRefs[idx]);
                                    return postUI(context,
                                        PostController(snapshot.data![idx]),
                                        setState: setState,
                                        saved: saved,
                                        first: idx == 0);
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            print(e);
                            return const Center(child: Text("No Posts"));
                          }
                        }),
                    KeepAliveStreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_info')
                            .doc(state.currentUser?.uid)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<dynamic> snap) {
                          if (snap.data == null) {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: ApdiColors.themeGreen));
                          }
                          try {
                            List postRefs = snap.data!.get('savedPosts');
                            postRefs = postRefs.reversed.toList();
                            if (postRefs.isEmpty) {
                              return const Center(
                                  child: Text("No Saved Posts"));
                            }
                            return FutureBuilder<List<Post>>(
                              future: getPostsFromRefs(postRefs),
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return const SizedBox.shrink();
                                }
                                return ListView.builder(
                                  // physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int idx) {
                                    return postUI(context,
                                        PostController(snapshot.data![idx]),
                                        setState: setState,
                                        saved: true,
                                        first: idx == 0);
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            print(e);
                            return const Center(child: Text("No Saved Posts"));
                          }
                        }),
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
