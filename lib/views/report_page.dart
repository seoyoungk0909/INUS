import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ReportPage> createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {
  var selectedRadio = '';
  List REPORT_TYPE = [
    "It's spam",
    "Nudity or sexual activity",
    "Bullying or harassment",
    "False information",
    "Suicide or self-injury",
    "Sale of illegal or regulated goods"
  ];

  setSelectedRadio(var val) {
    setState(() {
      selectedRadio = val;
    });
  }

  List<Widget> createRadioList() {
    List<Widget> widgets = [];

    for (String report in REPORT_TYPE) {
      widgets.add(
        RadioListTile(
          title: Text(
            report,
            style: TextStyle(fontSize: 15),
          ),
          value: report,
          groupValue: selectedRadio,
          onChanged: (val) {
            setSelectedRadio(val);
          },
          activeColor: Colors.red,
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: Text(
                "Please identify a reason for the report",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: createRadioList(),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Center(
                child: SizedBox(
                    width: 350,
                    height: 46,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: selectedRadio.trim().isEmpty
                            ? MaterialStateProperty.all(Colors.white60)
                            : MaterialStateProperty.all(Colors.red),
                      ),
                      // onPressed: selectedRadio.trim().isEmpty ? null : () {},
                      onPressed: () {},
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    )),
              ),
            ),
          ],
        ));
  }
}
