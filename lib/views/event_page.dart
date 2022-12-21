import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'event_ui.dart';

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
  EventController controller1 = EventController(Event());
  EventController controller2 = EventController(Event(
      eventTitle: "LinkedIn Learning at HKUST",
      eventCategory: "Workshop",
      eventTag: "#career #intern"));
  EventController controller3 = EventController(Event(
      eventTitle:
          "Chun Wo Innovation Student Awards Engineers for a Sustainable Tomorrow",
      eventCategory: "Competition",
      eventTag: "#engineering #sustainable"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
                body: Column(children: [
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
                  child: TabBarView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          eventListView([
                            eventUI(context, controller1, setState: setState)
                          ]),
                          eventListView([
                            eventUI(context, controller2, setState: setState)
                          ])
                        ],
                      ),
                      Column(
                        children: [
                          eventListView([
                            eventUI(context, controller1, setState: setState)
                          ]),
                          eventListView([
                            eventUI(context, controller3, setState: setState)
                          ]),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          eventListView([
                            eventUI(context, controller1, setState: setState)
                          ]),
                          eventListView([
                            eventUI(context, controller2, setState: setState)
                          ]),
                        ],
                      ),
                      Column(
                        children: [
                          eventListView([
                            eventUI(context, controller1, setState: setState)
                          ]),
                          eventListView([
                            eventUI(context, controller3, setState: setState)
                          ]),
                        ],
                      ),
                    ],
                  )
                ],
              )),
            ]))));
  }
}
