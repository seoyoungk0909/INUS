import 'dart:math';
import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'components/event_ui.dart';

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
  List<EventController> formalEventsControllers = [
    EventController(Event(eventCategory: "Webinar")),
    EventController(Event(eventCategory: "Workshop")),
    EventController(Event(eventCategory: "Seminar")),
  ];

  List<EventController> casualEventsControllers = [
    EventController(Event(eventCategory: "Party")),
    EventController(Event(eventCategory: "Seminar")),
  ];

  Future<void> refreshEvents({bool formal = false}) async {
    int randInt = Random().nextInt(20);
    List<Event> events = List.generate(randInt, (i) => Event());
    List<EventController> _controllers = [];
    for (Event event in events) {
      _controllers.add(EventController(event));
    }
    setState(() {
      if (formal) {
        formalEventsControllers = _controllers;
      } else {
        casualEventsControllers = _controllers;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: Scaffold(
          body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Formal"),
                Tab(text: "Casual"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(children: [
              RefreshIndicator(
                onRefresh: () async {
                  refreshEvents(formal: true);
                },
                color: Theme.of(context).colorScheme.secondary,
                child: GridView.builder(
                  itemCount: formalEventsControllers.length,
                  itemBuilder: (context, index) => eventUI(
                      context, formalEventsControllers[index],
                      setState: setState),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.73,
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  refreshEvents(formal: false);
                },
                color: Theme.of(context).colorScheme.secondary,
                child: GridView.builder(
                  itemCount: casualEventsControllers.length,
                  itemBuilder: (context, index) => eventUI(
                      context, casualEventsControllers[index],
                      setState: setState),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.73,
                  ),
                ),
              )
            ]),
          ),
        ],
      )),
    ));
  }
}
