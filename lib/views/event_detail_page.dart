// import 'dart:html';

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
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Can not launch $url";
    }
  }

  Future<void> saveEvent(
      String currentUserId, EventController controller) async {
    FirebaseFirestore.instance
        .collection('user_info')
        .doc(currentUserId)
        .update({
      'savedPosts': FieldValue.arrayUnion([controller.event.firebaseDocRef])
    });
  }

  Future<void> deleteEvent(
      String currentUserId, EventController controller) async {
    FirebaseFirestore.instance
        .collection('user_info')
        .doc(currentUserId)
        .update({
      'savedPosts': FieldValue.arrayRemove([controller.event.firebaseDocRef])
    });
  }

  final User currentUser = FirebaseAuth.instance.currentUser!;

  bool saved = false;

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
              onPressed: () {
                Navigator.pushNamed(context, 'report',
                    arguments: {'event': controller.event});
              },
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
                categoryHashtag(context, controller),
                quickView(context, controller),
                eventDescription(context, controller),
                detailedView(context, controller),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.76,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () async {
                            _launchURL(controller.event.registerLink);
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.secondary),
                              textStyle:
                                  MaterialStateProperty.all(const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.w600,
                              ))),
                          child: const Text('Register'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user_info')
                                .doc(currentUser.uid)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: ApdiColors.themeGreen));
                              }
                              // To show saved UI
                              // Map documentdata = snapshot.data!.data() as Map;
                              // List? savedEvents =
                              //     documentdata.containsKey('savedPosts')
                              //         ? snapshot.data!['savedPosts']
                              //         : null;
                              // }
                              // if (savedEvents.contains(controller.event.firebaseDocRef!.values)) {
                              //   saved = false;
                              // }
                              if (saved) {
                                return IconButton(
                                    onPressed: () => {
                                          setState(() {
                                            deleteEvent(
                                                currentUser.uid, controller);
                                            controller.event.firebaseDocRef
                                                ?.update({
                                              "saveCount":
                                                  FieldValue.increment(-1)
                                            });
                                            saved = false;
                                          })
                                        },
                                    icon: const Icon(
                                      Icons.bookmark,
                                      size: 35,
                                    ));
                              } else {
                                return IconButton(
                                    onPressed: () => {
                                          setState(() {
                                            saveEvent(
                                                currentUser.uid, controller);
                                            controller.event.firebaseDocRef
                                                ?.update({
                                              "saveCount":
                                                  FieldValue.increment(1)
                                            });
                                            saved = true;
                                          })
                                        },
                                    icon: const Icon(
                                      Icons.bookmark_border,
                                      size: 35,
                                    ));
                              }
                            }),
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
Widget categoryHashtag(BuildContext context, EventController controller) {
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
        child: text(context, controller, "#${controller.event.tag}", 12),
      ),
    ),
  );
}

//all of category hashtags in a row
// Widget categoryHashtagRow(BuildContext context, EventController controller) {
//   final hashtagArr = (controller.event.tag).split(' ');
//   // const hashtagArr = "#Environment, #Education";
//   return Row(
//     children: [
//       categoryHashtag(context, controller, hashtagArr[0]),
//       categoryHashtag(context, controller, hashtagArr[1]),
//     ],
//   );
// }

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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: text(context, controller, 'Language', 14,
                        textColor: '#AAAAAA'),
                  ),
                  text(context, controller, controller.event.language.join(','),
                      15,
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
