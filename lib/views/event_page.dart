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
  bool confirmedFormalEmpty = false;
  bool confirmedCasualEmpty = false;

  Stream<DocumentSnapshot> userSnapshots = FirebaseFirestore.instance
      .collection('user_info')
      .doc(fba.FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

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
          confirmedFormalEmpty = _controllers.isEmpty;
          formalEventsControllers = _controllers;
        } else {
          confirmedCasualEmpty = _controllers.isEmpty;
          casualEventsControllers = _controllers;
        }
        refreshing = false;
      });
    }
  }

  Widget eventsGridView(List filteredEventsControllers, {bool formal = false}) {
    Widget child;

    if ((confirmedCasualEmpty && !formal) || (confirmedFormalEmpty && formal)) {
      child = Center(
        child: Text("no events"),
      );
    } else {
      child = GridView.builder(
        itemCount: filteredEventsControllers.length,
        itemBuilder: (BuildContext context, int i) {
          return eventUI(context, filteredEventsControllers[i]);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.57,
          crossAxisSpacing: 14,
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        refreshEvents(formal: formal);
      },
      color: ApdiColors.themeGreen,
      child: child,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshEvents(formal: true);
    refreshEvents(formal: false);
  }

  Widget eventView(snapshot, {bool formal = false}) {
    List<EventController> _controllers =
        formal ? formalEventsControllers : casualEventsControllers;
    bool emptyConfirmed = formal ? confirmedFormalEmpty : confirmedCasualEmpty;
    if ((_controllers.isEmpty && !emptyConfirmed) || snapshot.data == null) {
      return Center(
          child: CircularProgressIndicator(color: ApdiColors.themeGreen));
    }
    Map documentdata = snapshot.data!.data() as Map;
    List? blockedEvents = documentdata.containsKey('blockedEvents')
        ? documentdata['blockedEvents']
        : null;

    List filteredEventsControllers = [];
    for (EventController ctrl in _controllers) {
      bool blocked =
          blockedEvents?.contains(ctrl.event.firebaseDocRef) ?? false;
      if (!blocked) {
        filteredEventsControllers.add(ctrl);
      }
    }
    if (filteredEventsControllers.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          refreshEvents(formal: formal);
        },
        color: ApdiColors.themeGreen,
        child: Center(child: Text("No events")),
      );
    }
    return eventsGridView(filteredEventsControllers, formal: formal);
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
                  Tab(text: "Formal"),
                  Tab(text: "Casual"),
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
                    stream: userSnapshots,
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      return TabBarView(children: [
                        eventView(snapshot, formal: true),
                        eventView(snapshot, formal: false),
                      ]);
                    }),
              ),
            ],
          )),
    );
  }
}
