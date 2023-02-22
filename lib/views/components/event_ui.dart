import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../../controllers/event_controller.dart';
import 'package:intl/intl.dart';

//determine color of category button, default color is blue
String buttonColor(String eventCategory) {
  if (eventCategory == "Seminar" || eventCategory == "Webinar") {
    return "#56bed2"; //mint
  } else if (eventCategory == "Competition") {
    return "#4ba7f8"; //orange
  } else if (eventCategory == "Workshop") {
    return "#4ca98f"; //green
  } else if (eventCategory == "Party") {
    return "#ef8632"; //purple
  }
  return "#4ba7f8"; //blue
}

//determine thumbnail image of events, default image is seminar
String eventImage(String eventCategory) {
  if (eventCategory == "Webinar") {
    return 'assets/imgs/event_webinar.png';
  } else if (eventCategory == "Workshop") {
    return 'assets/imgs/event_workshop.png';
  } else if (eventCategory == "Party") {
    return 'assets/imgs/event_party.png';
  }
  return 'assets/imgs/event_seminar.png';
}

//event photo
Widget eventPhoto(BuildContext context, EventController controller) {
  return Container(
    width: 180,
    height: 110,
    decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(eventImage(controller.event.category)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5)),
  );
}

//category button
Widget categoryButton(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
    child: Container(
      decoration: BoxDecoration(
        color: hexStringToColor("#3E3E3E"),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: hexStringToColor(buttonColor(controller.event.category))),
      ),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 2, 8, 2),
        child: Text(
          controller.event.category,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontFamily: 'Outfit',
                color: hexStringToColor(buttonColor(controller.event.category)),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    ),
  );
}

//event title
Widget eventTitle(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
    child: Text(
      controller.event.title,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFamily: 'Outfit',
            color: Colors.white,
            fontSize: 16,
          ),
    ),
  );
}

//event date
Widget eventDate(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
    child: Text(
      DateFormat('dd.MM.yyyy').format(controller.event.eventTime),
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: 'Outfit',
            color: hexStringToColor("#AAAAAA"),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

//event hashtag
Widget eventHashTag(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 6),
    child: Text(
      "#${controller.event.tag.join(' #')}",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontFamily: 'Outfit',
            color: hexStringToColor("#AAAAAA"),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

Widget contentUI(BuildContext context, EventController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      categoryButton(context, controller),
      eventTitle(context, controller),
      eventDate(context, controller),
      eventHashTag(context, controller),
    ],
  );
}

Widget eventUI(BuildContext context, EventController controller,
    {Function? setState}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
    child: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, 'event_detail',
            arguments: {'event': controller.event});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          eventPhoto(context, controller),
          contentUI(context, controller),
        ],
      ),
    ),
  );
}

Widget savedEventUI(BuildContext context, EventController controller,
    {Function? setState, bool first = false}) {
  double topPad = first ? 16 : 0;
  return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, topPad, 16, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, 'event_detail',
              arguments: {'event': controller.event});
        },
        child: Column(
          children: [
            Row(
              children: [
                eventPhoto(context, controller),
                const SizedBox(width: 12),
                Expanded(child: contentUI(context, controller)),
              ],
            ),
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Divider()),
          ],
        ),
      ));
}
