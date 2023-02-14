// import 'dart:html';

import 'package:aus/views/components/event_save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'package:aus/utils/color_utils.dart';
import 'components/event_ui.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<DocumentSnapshot> userInfoSnap = FirebaseFirestore.instance
      .collection('user_info')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    EventController controller = EventController(arguments['event'] ?? Event());
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'report',
                    arguments: {'event': controller.event});
              },
              icon: SvgPicture.asset('assets/icons/Report.svg'))
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: userInfoSnap,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(
                  child:
                      CircularProgressIndicator(color: ApdiColors.themeGreen));
            }
            Map documentdata = snapshot.data!.data() as Map;
            List? savedPosts = documentdata.containsKey('savedPosts')
                ? documentdata['savedPosts']
                : null;
            bool isEventSaved =
                savedPosts?.contains(controller.event.firebaseDocRef) ?? false;
            return ListView(
              children: [
                eventDetailPhoto(context, controller),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryButton(context, controller),
                      eventTitle(context, controller),
                      categoryHashtag(context, controller),
                      quickView(context, controller),
                      eventDescription(context, controller),
                      detailedView(context, controller),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.76,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  _launchURL(controller.event.registerLink);
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.w600,
                                    ))),
                                child: const Text('Register'),
                              ),
                            ),
                            Spacer(),
                            EventSaveButton(
                                controller: controller,
                                currentUser: FirebaseAuth.instance.currentUser!,
                                saved: isEventSaved),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
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
            fontWeight: FontWeight.w500));
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

Widget singleHashtag(
    BuildContext context, EventController controller, int index) {
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
        child: text(context, controller, "#${controller.event.tag[index]}", 12),
      ),
    ),
  );
}

//category hashtag each element
Widget categoryHashtag(BuildContext context, EventController controller) {
  List<Widget> hashtags = [];

  for (int i = 0; i < controller.event.tag.length; i++) {
    hashtags.add(singleHashtag(context, controller, i));
  }

  return Row(children: hashtags);
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
                                .format(controller.event.eventTime),
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
                                  .format(controller.event.eventTime),
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
                      DateFormat('dd MMM y').format(controller.event.eventTime),
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
                      DateFormat('Hm').format(controller.event.eventTime), 15,
                      bold: true),
                ],
              ),
            ),
            //language
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: text(context, controller, 'Language', 14,
                        textColor: '#AAAAAA'),
                  ),
                  text(context, controller,
                      controller.event.language.join(', '), 15,
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
