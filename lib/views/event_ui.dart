import 'dart:js';

import 'package:aus/utils/color_utils.dart';
import 'package:flutter/material.dart';
import '../controllers/event_controller.dart';

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
    width: 197,
    height: 130,
    decoration: BoxDecoration(
        color: hexStringToColor("#737373"),
        borderRadius: BorderRadius.circular(8)),
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
              width: controller.event.buttonWidth,
              height: 20,
              decoration: BoxDecoration(
                color: hexStringToColor("#3E3E3E"),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: hexStringToColor(controller.event.categoryColor)),
              ),
              child: Center(
                child: Text(
                  controller.event.category,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(controller.event.categoryColor),
                        fontSize: 9,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
              controller.event.date,
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
            Text(
              controller.event.tag,
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
    ],
  );
}

Widget eventUI(BuildContext context, EventController controller,
    {Function? setState}) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 0),
    child: Container(
      width: 210,
      decoration: BoxDecoration(
        color: hexStringToColor("#3E3E3E"),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0x3416202A),
            offset: Offset(0, 3),
          )
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(6, 8, 6, 4),
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
