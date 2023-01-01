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

      // body: Center(child: eventDetailUI(context, controller)),
    );
  }
}

//event photo
Widget eventDetailPhoto(BuildContext context, EventController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
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

//event category hashtag
Widget eventDetailCategory(
    BuildContext context, String hexButtonColor, EventController controller) {
  return Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
            child: Text(
              'View',
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontFamily: 'Outfit',
                    color: hexStringToColor(hexButtonColor),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4, 0, 8, 0),
                child: Text(
                  'Comment',
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        fontFamily: 'Outfit',
                        color: hexStringToColor(hexButtonColor),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget eventDetailUI(BuildContext context, EventController controller,
    {Function? setState}) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        eventDetailPhoto(context, controller),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 4),
          child: Column(
            children: [
              eventDetailCategory(context, "#AAAAAA", controller),
            ],
          ),
        ),
      ],
    ),
  );
}
