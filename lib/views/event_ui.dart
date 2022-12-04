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

Widget eventPhoto(BuildContext context, EventController controller) {
  return Container(
    width: 200,
    height: 130,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(8)),
  );
}

// Widget eventCategoryUI(
//     BuildContext context, String hexButtonColor, EventController controller) {
//   return;
// } maybe use to change color of category widget?

Widget contentUI(BuildContext context, EventController controller) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 52,
              height: 20,
              decoration: BoxDecoration(
                color: hexStringToColor("#3E3E3E"),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color.fromARGB(255, 0, 221, 255)),
              ),
              child: Center(
                child: Text(
                  controller.event.category,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: Color.fromARGB(255, 0, 221, 255),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              controller.event.date,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontFamily: 'Outfit',
                    color: hexStringToColor("#AAAAAA"),
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              controller.event.tag,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontFamily: 'Outfit',
                    color: hexStringToColor("#AAAAAA"),
                    fontSize: 11,
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
        padding: const EdgeInsets.all(4),
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
