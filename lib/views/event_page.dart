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
  EventController controller2 = EventController(Event(eventCategory: "Party"));
  EventController controller3 =
      EventController(Event(eventCategory: "Webinar"));
  EventController controller4 =
      EventController(Event(eventCategory: "Workshop"));

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
                  eventListView([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            eventUI(context, controller1, setState: setState),
                            eventUI(context, controller2, setState: setState),
                            eventUI(context, controller3, setState: setState)
                          ],
                        ),
                        Column(
                          children: [
                            eventUI(context, controller3, setState: setState),
                            eventUI(context, controller4, setState: setState),
                            eventUI(context, controller1, setState: setState)
                          ],
                        ),
                      ],
                    )
                  ]),
                  eventListView([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            eventUI(context, controller1, setState: setState),
                            eventUI(context, controller2, setState: setState),
                            eventUI(context, controller3, setState: setState)
                          ],
                        ),
                        Column(
                          children: [
                            eventUI(context, controller3, setState: setState),
                            eventUI(context, controller4, setState: setState),
                            eventUI(context, controller1, setState: setState)
                          ],
                        ),
                      ],
                    )
                  ]),
                ],
              )),
            ]))));
  }
}
