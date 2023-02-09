import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'components/event_ui.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  Future<void> refreshEvents({bool formal = false}) async {
    // List<Event> events = await Event.getEventsFromFirebase(formal: formal);
    // List<EventController> _controllers = [];
    // for (Event event in events) {
    //   _controllers.add(EventController(event));
    // }
    // if (mounted) {
    //   setState(() {
    //     if (formal) {
    //       formalEventsControllers = _controllers;
    //     } else {
    //       casualEventsControllers = _controllers;
    //     }
    //   });
    // }
  }

  Widget eventsGridView({bool formal = false}) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshEvents(formal: formal);
      },
      color: Theme.of(context).backgroundColor,
      child: StreamBuilder(
        stream: Event.getEventsQuery(formal: formal).snapshots(),
        builder:
            (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
          if (snap.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            itemCount: snap.data!.size,
            itemBuilder: (BuildContext context, int i) {
              return FutureBuilder<Event>(
                future: Event.fromDocRef(firebaseSnap: snap.data!.docs[i]),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox.shrink(); //NOTE: empty widget
                  }
                  return eventUI(context, EventController(snapshot.data!),
                      setState: setState);
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.73,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('user_info')
        .doc(fba.FirebaseAuth.instance.currentUser?.uid);
    Future<DocumentSnapshot> snapshots = userRef.get();
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Formal"),
                  Tab(text: "Casual"),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  FutureBuilder(
                      future: snapshots,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // Map documentdata = snapshot.data!.data() as Map;
                        return eventsGridView(formal: true);
                      }),
                  FutureBuilder(
                      future: snapshots,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        // Map documentdata = snapshot.data!.data() as Map;
                        return eventsGridView(formal: false);
                      }),
                ]),
              ),
            ],
          )),
    );
  }
}
