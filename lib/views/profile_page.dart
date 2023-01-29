import 'package:aus/firebase_login_state.dart';
import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  User defaultUser = User(userName: "", userSchool: School.PolyU);

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
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_info')
                            .doc(state.currentUser?.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snap) {
                          if (snap.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                            return ListView.builder(
                              // physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: postRefs.length,
                              itemBuilder: (BuildContext context, int idx) {
                                bool saved = savedPostRefs.isNotEmpty &&
                                    savedPostRefs.contains(postRefs[idx]);
                                return FutureBuilder<Post>(
                                  future: Post.fromDocRef(
                                      firebaseDoc: postRefs[idx]),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return postUI(
                                        context, PostController(snapshot.data!),
                                        setState: setState, saved: saved);
                                  },
                                );
                              },
                            );
                          } catch (e) {
                            print(e);
                            return const Center(child: Text("No Posts"));
                          }
                        }),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user_info')
                            .doc(state.currentUser?.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snap) {
                          if (snap.data == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          try {
                            List postRefs = snap.data!.get('savedPosts');
                            postRefs = postRefs.reversed.toList();
                            if (postRefs.isEmpty) {
                              return const Center(
                                  child: Text("No Saved Posts"));
                            }
                            return ListView.builder(
                              // physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: postRefs.length,
                              itemBuilder: (BuildContext context, int idx) {
                                return FutureBuilder<Post>(
                                  future: Post.fromDocRef(
                                      firebaseDoc: postRefs[idx]),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return postUI(
                                        context, PostController(snapshot.data!),
                                        setState: setState, saved: true);
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
