import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'package:aus/utils/color_utils.dart';
import '../views/event_ui.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventDetailPage> createState() => EventDetailPageState();
}

class EventDetailPageState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    EventController controller = EventController(arguments['event'] ?? Event());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: eventDetailUI(context, controller),
    );
  }
}

//function that returns text
Widget text(BuildContext context, EventController controller, String content,
    double size,
    {bool bold = false, String textColor = '#FFFFFF'}) {
  if (bold == true) {
    return Text(content,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: 'Outfit',
            color: hexStringToColor(textColor),
            fontSize: size,
            fontWeight: FontWeight.w600));
  }
  return Text(content,
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: 'Outfit',
            color: hexStringToColor(textColor),
            fontSize: size,
          ));
}

//event photo
Widget eventDetailPhoto(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Expanded(
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(eventImage(controller.event.category)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

//category hashtag
Widget categoryHashtag(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 14),
    child: Expanded(
      child: Container(
        height: 22,
        decoration: BoxDecoration(
          color: hexStringToColor("#3E3E3E"),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Flexible(
            child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(9, 5, 9, 0),
                child: text(context, controller, controller.event.tag, 12))),
      ),
    ),
  );
}

//Quick view
Widget quickView(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: hexStringToColor("#3E3E3E"),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Expanded(
        child: Flexible(
            child: Container(
                padding: const EdgeInsetsDirectional.fromSTEB(17, 22, 17, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(context, controller, 'Quick View', 15, bold: true),
                    Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: text(context, controller, 'Date', 14,
                                      textColor: '#AAAAAA'),
                                ),
                                text(context, controller, controller.event.date,
                                    15,
                                    bold: true),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: text(context, controller, 'Time', 14,
                                        textColor: '#AAAAAA'),
                                  ),
                                  text(context, controller,
                                      controller.event.time, 15,
                                      bold: true),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ))),
      ),
    ),
  );
}

//event description
Widget eventDescription(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child:
                  text(context, controller, controller.event.description, 14)),
        ],
      ),
    ),
  );
}

//detailed view
Widget detailedView(BuildContext context, EventController controller) {
  return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Expanded(
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: hexStringToColor("#3E3E3E"),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Flexible(
                child: Container(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(17, 22, 17, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(context, controller, 'Detailed View', 15,
                            bold: true),
                        //date
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 53),
                                child: text(context, controller, 'Date', 14,
                                    textColor: '#AAAAAA'),
                              ),
                              text(context, controller, controller.event.date,
                                  15,
                                  bold: true),
                            ],
                          ),
                        ),
                        //time
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 52),
                                child: text(context, controller, 'Time', 14,
                                    textColor: '#AAAAAA'),
                              ),
                              text(context, controller, controller.event.time,
                                  15,
                                  bold: true),
                            ],
                          ),
                        ),
                        //language
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: text(context, controller, 'Language', 14,
                                    textColor: '#AAAAAA'),
                              ),
                              text(context, controller,
                                  controller.event.language, 15,
                                  bold: true),
                            ],
                          ),
                        ),
                        //location
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 28),
                                child: text(context, controller, 'Location', 14,
                                    textColor: '#AAAAAA'),
                              ),
                              Expanded(
                                child: text(context, controller,
                                    controller.event.location, 15,
                                    bold: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )))),
      ));
}

Widget eventDetailUI(BuildContext context, EventController controller,
    {Function? setState}) {
  return ListView(
    children: [
      eventDetailPhoto(context, controller),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            categoryButton(context, controller),
            eventTitle(context, controller),
            categoryHashtag(context, controller),
            quickView(context, controller),
            eventDescription(context, controller),
            detailedView(context, controller),
          ],
        ),
      ),
    ],
  );
}
