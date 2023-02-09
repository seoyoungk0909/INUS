import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
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
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(20),
            child: const Text(
              "Please identify a reason for the report",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
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
                  height: 46,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: selectedReportType.isEmpty
                          ? MaterialStateProperty.all(Colors.white60)
                          : MaterialStateProperty.all(Colors.red),
                    ),
                    // onPressed: selectedRadio.trim().isEmpty ? null : () {},
                    onPressed: () {
                      if (arguments.keys.first == 'event') {
                        eventSendReport(eventController);
                      } else if (arguments.keys.first == 'post') {
                        postSendReport(postController);
                      }
                      popUpDialog(context, "Report Completed",
                          "This report will be reviewed promptly by the administrator.");
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
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
              color: Colors.red,
            )
          : Icon(
              Icons.radio_button_unchecked_outlined,
              color: Colors.grey,
            ),
      title: Text(
        widget.name,
        style: TextStyle(fontSize: 15),
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
