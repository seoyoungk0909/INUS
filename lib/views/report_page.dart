import 'package:aus/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controllers/post_controller.dart';
import '../models/event_model.dart';
import '../controllers/event_controller.dart';
import '../models/post_model.dart';
import '../views/components/popup_dialog.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ReportPage> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  Future<void> eventSendReport(EventController controller) async {
    DocumentReference newReport =
        await FirebaseFirestore.instance.collection("report").add({
      'postId': controller.event.firebaseDocRef,
      'time': Timestamp.now(),
      'reason': selectedReportType,
    });
  }

  Future<void> postSendReport(PostController controller) async {
    DocumentReference newReport =
        await FirebaseFirestore.instance.collection("report").add({
      'postId': controller.post.firebaseDocRef,
      'time': Timestamp.now(),
      'reason': selectedReportType,
    });
    setState(() {
      controller.addReport(newReport);
    });
  }

  List REPORT_TYPE = [
    "It's spam",
    "Nudity or sexual activity",
    "Bullying or harassment",
    "False information",
    "Suicide or self-injury",
    "Sale of illegal or regulated goods"
  ];

  List selectedReportType = [];

  List<Widget> get createReportList {
    List<Widget> widgets = [];

    for (String report in REPORT_TYPE) {
      widgets.add(ListTileWidget(
          name: report,
          isSelected: (bool value) {
            setState(() {
              if (value) {
                selectedReportType.add(report);
              } else {
                selectedReportType.remove(report);
              }
            });
          }));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    EventController eventController =
        EventController(arguments['event'] ?? Event());
    PostController postController = PostController(arguments['post'] ?? Post());

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsetsDirectional.fromSTEB(20, 30, 20, 20),
            child: const Text(
              "Please identify reason(s) for the report.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Column(
            children: createReportList,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 40),
            child: Center(
              child: SizedBox(
                  width: 350,
                  height: 48,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      backgroundColor: selectedReportType.isEmpty
                          ? MaterialStateProperty.all(Colors.white60)
                          : MaterialStateProperty.all(ApdiColors.errorRed),
                    ),
                    // onPressed: selectedRadio.trim().isEmpty ? null : () {},
                    onPressed: () {
                      if (arguments.keys.first == 'event') {
                        eventSendReport(eventController);
                      } else if (arguments.keys.first == 'post') {
                        postSendReport(postController);
                        setState(postController.incrementReport);
                      }
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Report Completed",
                                style: TextStyle(fontSize: 16),
                              ),
                              content: const Text(
                                  "This report will be reviewed within 24 hours by the administrator.",
                                  style: TextStyle(fontSize: 12)),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Okay",
                                      style: TextStyle(
                                          color: ApdiColors.themeGreen),
                                    ))
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ),
          ),
        ]));
  }
}

class ListTileWidget extends StatefulWidget {
  const ListTileWidget({
    Key? key,
    required this.name,
    required this.isSelected,
  }) : super(key: key);

  final String name;
  final ValueChanged<bool> isSelected;

  @override
  State<ListTileWidget> createState() => ListTileWidgetState();
}

class ListTileWidgetState extends State<ListTileWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isSelected
          ? Icon(
              Icons.radio_button_checked_outlined,
              color: ApdiColors.errorRed,
            )
          : Icon(
              Icons.radio_button_unchecked_outlined,
              color: ApdiColors.greyText,
            ),
      title: Text(
        widget.name,
        style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300),
      ),
      onTap: (() {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      }),
    );
  }
}
