import 'package:aus/firebase_login_state.dart';
import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

import 'components/keep_alive_builder.dart';
import 'components/post_ui.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import 'components/event_ui.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'package:flutter_svg/svg.dart';

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

  Stream<DocumentSnapshot<Map<String, dynamic>>> userInfoStream =
      FirebaseFirestore.instance
          .collection('user_info')
          .doc(fbauth.FirebaseAuth.instance.currentUser?.uid)
          .snapshots();

  Future<List<dynamic>> getFromDocRefs(refs) async {
    List<dynamic> eventsOrPosts = [];
    for (DocumentReference<Map<String, dynamic>> ref in refs) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await ref.get();
      if (!snapshot.exists) {
        continue;
      }
      Map<String, dynamic> data = snapshot.data()!;
      if (data.containsKey("eventDetail")) {
        eventsOrPosts.add(await Event.fromDocRef(firebaseDoc: ref));
      } else {
        eventsOrPosts.add(await Post.fromDocRef(firebaseDoc: ref));
      }
    }
    return eventsOrPosts;
  }

  Widget userGreetings(User currentUser) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Text(
              "${currentUser.name}'s Page",
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 130, 40),
                child: Text(
                  currentUser.getSchool(),
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffa3a3a3)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
    // });
  }

  Widget tabView(String type, AsyncSnapshot<dynamic> snap) {
    String nullMessage;
    switch (type) {
      case "myPosts":
        nullMessage = "No Posts";
        break;
      case "myComments":
        nullMessage = "No Comments";
        break;
      case "savedPosts":
        nullMessage = "No Saved Events or Posts";
        break;
      default:
        throw ArgumentError("Wrong type");
    }

    if (snap.data == null) {
      return Center(
          child: CircularProgressIndicator(color: ApdiColors.themeGreen));
    }
    try {
      if (type == 'savedPosts') {
        Map<String, dynamic> data = snap.data!.data()!;
        List savedRefs = data['savedPosts'];
        savedRefs = savedRefs.reversed.toList();

        List? blockedPosts =
            data.containsKey('blockedPosts') ? data['blockedPosts'] : null;

        List filteredSavedRefs = [];
        for (var ref in savedRefs) {
          bool blocked = blockedPosts?.contains(ref) ?? false;
          if (!blocked) {
            filteredSavedRefs.add(ref);
          }
        }

        return FutureBuilder(
            future: filterEmptyRefs(filteredSavedRefs),
            builder: (context, refSnapshot) {
              if (refSnapshot.data == null) {
                return Center(
                    child: CircularProgressIndicator(
                        color: ApdiColors.themeGreen));
              }
              List finalFilteredRefs = refSnapshot.data! as List;
              if (finalFilteredRefs.isEmpty) {
                return Center(child: Text(nullMessage));
              }
              return FutureBuilder<List<dynamic>>(
                future: getFromDocRefs(finalFilteredRefs),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox.shrink();
                  }
                  return ListView.builder(
                    // physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int idx) {
                      if (snapshot.data![idx] is Event) {
                        return savedEventUI(
                            context, EventController(snapshot.data![idx]),
                            first: idx == 0);
                      } else {
                        return PostUI(
                            controller: PostController(snapshot.data![idx]),
                            saved: true,
                            first: idx == 0);
                      }
                    },
                  );
                },
              );
            });
      }
      Map<String, dynamic> data = snap.data!.data()!;
      List postRefs = data[type];
      postRefs = postRefs.reversed.toList();
      List savedPostRefs = [];
      if (data.containsKey('savedPosts')) {
        savedPostRefs = data['savedPosts'];
      }

      List? blockedPosts =
          data.containsKey('blockedPosts') ? data['blockedPosts'] : null;

      List filteredRefs = [];
      for (var ref in postRefs) {
        bool blocked = blockedPosts?.contains(ref) ?? false;
        if (!blocked) {
          filteredRefs.add(ref);
        }
      }

      return FutureBuilder(
          future: filterEmptyRefs(filteredRefs),
          builder: (context, refSnapshot) {
            if (refSnapshot.data == null) {
              return Center(
                  child:
                      CircularProgressIndicator(color: ApdiColors.themeGreen));
            }
            List finalFilteredRefs = refSnapshot.data! as List;
            if (finalFilteredRefs.isEmpty) {
              return Center(child: Text(nullMessage));
            }
            return FutureBuilder<List<dynamic>>(
              future: getFromDocRefs(finalFilteredRefs),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                return ListView.builder(
                  // physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int idx) {
                    bool saved = savedPostRefs.isNotEmpty &&
                        savedPostRefs.contains(finalFilteredRefs[idx]);
                    return PostUI(
                        controller: PostController(snapshot.data![idx]),
                        saved: saved,
                        first: idx == 0);
                  },
                );
              },
            );
          });
    } catch (e) {
      print(e);
      return Center(child: Text(nullMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Consumer<LoginState>(
          builder: (context, state, _) => Column(
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.only(top: 0),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () => Navigator.pushNamed(context, 'more'),
                          icon: SvgPicture.asset(
                              'assets/icons/jum jum jum.svg')))),
              userGreetings(state.currentUser ?? defaultUser),
              const TabBar(
                labelStyle: (TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto')),
                unselectedLabelStyle: (TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xffa3a3a3))),
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Post"),
                  Tab(text: "Comment"),
                  Tab(text: "Save"),
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
                      stream: userInfoStream,
                      builder: (context, AsyncSnapshot<dynamic> snap) {
                        return TabBarView(
                          children: [
                            tabView("myPosts", snap),
                            tabView("myComments", snap),
                            tabView("savedPosts", snap),
                          ],
                        );
                      })),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List> filterEmptyRefs(List refs) async {
  List filtered = [];
  for (DocumentReference ref in refs) {
    DocumentSnapshot ds = await ref.get();
    if (ds.exists && !ds.get('deleted')) {
      filtered.add(ref);
    }
  }
  return filtered;
}
