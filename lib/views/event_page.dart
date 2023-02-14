import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'components/event_ui.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;

import 'components/keep_alive_builder.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EventPage> createState() => EventPageState();
}

class EventPageState extends State<EventPage> {
  List<EventController> formalEventsControllers = [];
  List<EventController> casualEventsControllers = [];
  bool refreshing = false;

  Future<void> refreshEvents({bool formal = false}) async {
    setState(() {
      refreshing = true;
    });
    List<Event> events = await Event.getEventsFromFirebase(formal: formal);
    List<EventController> _controllers = [];
    for (Event event in events) {
      _controllers.add(EventController(event));
    }
    if (mounted) {
      setState(() {
        if (formal) {
          formalEventsControllers = _controllers;
        } else {
          casualEventsControllers = _controllers;
        }
        refreshing = false;
      });
    }
  }

  Widget eventsGridView({bool formal = false}) {
    return RefreshIndicator(
      onRefresh: () async {
        refreshEvents(formal: formal);
      },
      color: ApdiColors.themeGreen,
      child: FutureBuilder<List<Event>>(
        future: Event.getEventsFromFirebase(formal: formal),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
                child: CircularProgressIndicator(color: ApdiColors.themeGreen));
          }
          return GridView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int i) {
              return eventUI(context, EventController(snapshot.data![i]),
                  setState: setState);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshEvents(formal: true);
    refreshEvents(formal: false);
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference userRef = FirebaseFirestore.instance
        .collection('user_info')
        .doc(fba.FirebaseAuth.instance.currentUser?.uid);
    Future<DocumentSnapshot> snapshots = userRef.get();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                  KeepAliveFutureBuilder(
                      future: snapshots,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (formalEventsControllers.isEmpty ||
                            snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ApdiColors.themeGreen));
                        }
                        // Map documentdata = snapshot.data!.data() as Map;
                        return eventsGridView(formal: true);
                      }),
                  KeepAliveFutureBuilder(
                      future: snapshots,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (casualEventsControllers.isEmpty ||
                            snapshot.data == null) {
                          return Center(
                              child: CircularProgressIndicator(
                                  color: ApdiColors.themeGreen));
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
