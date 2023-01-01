import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';
import 'package:intl/intl.dart';

//determine color of category button, default color is blue
String buttonColor(String eventCategory) {
  if (eventCategory == "Seminar" || eventCategory == "Webinar") {
    return "#56bed2"; //mint
  } else if (eventCategory == "Competition") {
    return "#ef8632"; //orange
  } else if (eventCategory == "Workshop") {
    return "#4ca98f"; //green
  } else if (eventCategory == "Party") {
    return "8d65f2"; //purple
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

//determine width of category button, default as Event
double buttonWidth(String eventCategory) {
  if (eventCategory == "Seminar") {
    return 56;
  } else if (eventCategory == "Webinar") {
    return 57;
  } else if (eventCategory == "Workshop") {
    return 67;
  } else if (eventCategory == "Competition") {
    return 79;
  } else if (eventCategory == "Party") {
    return 43;
  }
  return 42;
}

Widget eventListView(List<Widget> children) {
  return SingleChildScrollView(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    ),
  );
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

Widget contentUI(BuildContext context, EventController controller) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          //category button
          children: [
            Container(
              width: buttonWidth(controller.event.category),
              height: 20,
              decoration: BoxDecoration(
                color: hexStringToColor("#3E3E3E"),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: hexStringToColor(
                        buttonColor(controller.event.category))),
              ),
              child: Center(
                child: Text(
                  controller.event.category,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(
                            buttonColor(controller.event.category)),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),

      //event title
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                controller.event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 16,
                    ),
              ),
            ),
          ],
        ),
      ),

      //event date
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              DateFormat('dd.MM.yyyy').format(controller.event.timestamp),
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontFamily: 'Outfit',
                    color: hexStringToColor("#AAAAAA"),
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),

      //event tag
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 6),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                controller.event.tag,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontFamily: 'Outfit',
                      color: hexStringToColor("#AAAAAA"),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget eventUI(BuildContext context, EventController controller,
    {Function? setState}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(8, 12, 6, 0),
    child: SizedBox(
      width: 176,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 8, 6, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            eventPhoto(context, controller),
            contentUI(context, controller),
          ],
        ),
      ),
    ),
  );
}
