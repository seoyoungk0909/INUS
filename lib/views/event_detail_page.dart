// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'package:aus/utils/color_utils.dart';
import 'components/event_ui.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        // title: Text(widget.title),
        // centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/Report.svg'))
        ],
      ),
      body: ListView(
        children: [
          eventDetailPhoto(context, controller),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                categoryButton(context, controller),
                eventTitle(context, controller),
                categoryHashtagRow(context, controller),
                quickView(context, controller),
                eventDescription(context, controller),
                detailedView(context, controller),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                hexStringToColor("#8d65f2")),
                            padding: MaterialStateProperty.all(
                                const EdgeInsetsDirectional.fromSTEB(
                                    120, 13, 120, 13)),
                            textStyle:
                                MaterialStateProperty.all(const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                            ))),
                        child: const Text('Register'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: IconButton(
                          onPressed: () => {
                            setState(() {
                              controller.changeSave();
                            })
                          },
                          icon: (controller.event.save == false)
                              ? const Icon(Icons.bookmark_border)
                              : const Icon(Icons.bookmark),
                          color: hexStringToColor("#AAAAAA"),
                          iconSize: 37.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
  );
}

//category hashtag each element
Widget categoryHashtag(
    BuildContext context, EventController controller, hashtag) {
  return Padding(
    padding: const EdgeInsets.only(top: 14, right: 10),
    child: Container(
      height: 22,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(9, 5, 9, 0),
        child: text(context, controller, hashtag, 12),
      ),
    ),
  );
}

//all of category hashtags in a row
Widget categoryHashtagRow(BuildContext context, EventController controller) {
  final hashtagArr = (controller.event.tag).split(' ');
  return Row(
    children: [
      categoryHashtag(context, controller, hashtagArr[0]),
      categoryHashtag(context, controller, hashtagArr[1]),
    ],
  );
}

//Quick view
Widget quickView(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
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
                        text(
                            context,
                            controller,
                            DateFormat('dd MMM y')
                                .format(controller.event.uploadTime),
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
                          text(
                              context,
                              controller,
                              DateFormat('Hm')
                                  .format(controller.event.uploadTime),
                              15,
                              bold: true),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

//event description
Widget eventDescription(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: text(context, controller, controller.event.description, 14)),
      ],
    ),
  );
}

//detailed view
Widget detailedView(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 18),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(17, 22, 17, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text(context, controller, 'Detailed View', 15, bold: true),
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
                  text(
                      context,
                      controller,
                      DateFormat('dd MMM y')
                          .format(controller.event.uploadTime),
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
                  text(context, controller,
                      DateFormat('Hm').format(controller.event.uploadTime), 15,
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
                  text(context, controller, controller.event.language, 15,
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
                    child: text(
                        context, controller, controller.event.location, 15,
                        bold: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
