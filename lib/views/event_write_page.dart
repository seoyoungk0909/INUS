import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventWritePage extends StatefulWidget {
  const EventWritePage({Key? key, required this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventWritePage> createState() => EventWritePageState();
}

class EventWritePageState extends State<EventWritePage> {
  Future<void> uploadEvent(String currentUserId) async {
    DocumentReference newEvent =
        await FirebaseFirestore.instance.collection("event").add({
      'title': eventTitle.text.trim(),
      'tag': tags.text.trim(),
      'time': [getDate(), getTime()],
      'language': trueLanguages,
      'category': trueCategories,
      'location': eventLocation.text.trim(),
      'registration link': eventRegistrationLink.text.trim(),
      'event detail': eventDetail.text.trim(),
      'viewCount': 0,
      'saveCount': 0,
      'comments': [],
      'user': FirebaseFirestore.instance.doc('user_info/$currentUserId'),
    });
  }

  DateTime? _selectedDate;
  String? _selectedTime;

  String getDate() {
    if (_selectedDate == null) {
      return 'DD/MM/YYYY';
    } else {
      return DateFormat('dd-MM-yyyy').format(_selectedDate!);
    }
  }

  String getTime() {
    if (_selectedTime == null) {
      return '--:--AM';
    } else {
      return '$_selectedTime';
    }
  }

  Future _pickDateDialog(BuildContext context) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (pickedDate == null) return;
    setState(() => _selectedDate = pickedDate);
  }

  Future _pickTimeDialog(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;
    setState(() => _selectedTime = pickedTime.format(context));
  }

  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController postContent = TextEditingController();
  final TextEditingController tags = TextEditingController();
  final TextEditingController eventRegistrationLink = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDetail = TextEditingController();

  final User currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, bool> categories = {
    'Party': true,
    'Workshop': false,
    'Seminar': false,
    'Webinar': false,
  };
  Map<String, bool> languages = {
    'English': true,
    'Cantonese': false,
    'Mandarine': false,
  };

  String trueCategories = "";
  var trueLanguages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: Text(
                  " Category",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 55,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: ListView(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var category in categories.keys)
                        Row(children: <Widget>[
                          Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                                color: categories[category]!
                                    ? Colors.white24
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 0.5,
                                    color: categories[category]!
                                        ? Colors.white24
                                        : Colors.white70),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              onPressed: () {
                                for (var reset in categories.keys) {
                                  categories[reset] = false;
                                }
                                setState(() {
                                  categories[category] == true
                                      ? categories[category] = false
                                      : categories[category] = true;
                                });
                              },
                              child: Text(
                                category,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: categories[category]!
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: categories[category]!
                                        ? Color(0xff57AD9E)
                                        : Colors.white70),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  " Title",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: eventTitle,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event name",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Row(children: [
                  Text(
                    " Tags",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (max. 1-2)",
                    style: TextStyle(fontSize: 16, color: Colors.white10),
                  ),
                ]),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: tags,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input tag",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: Text(
                  " Date and Time",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 20, 0, 0),
                  child: Row(children: <Widget>[
                    SizedBox(
                        width: 140,
                        height: 50,
                        child: OutlinedButton(
                            child: Text(getDate(),
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white10)),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                            onPressed: () {
                              _pickDateDialog(context);
                            })),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 140,
                        height: 50,
                        child: OutlinedButton(
                            child: Text(getTime(),
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white10)),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                            onPressed: () {
                              _pickTimeDialog(context);
                            }))
                  ])),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  "Language(s)",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 55,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                  child: ListView(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (var language in languages.keys)
                        Row(children: <Widget>[
                          Container(
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                                color: languages[language]!
                                    ? Colors.white24
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 0.5,
                                    color: languages[language]!
                                        ? Colors.white24
                                        : Colors.white70),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              onPressed: () {
                                for (var reset in categories.keys) {
                                  categories[reset] = false;
                                }
                                setState(() {
                                  languages[language] == true
                                      ? languages[language] = false
                                      : languages[language] = true;
                                });
                              },
                              child: Text(
                                language,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: languages[language]!
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: languages[language]!
                                        ? Color(0xff57AD9E)
                                        : Colors.white70),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  " Location",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: eventLocation,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event's location here.",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  " Registration Link",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: eventRegistrationLink,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event name",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  " Event Details",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: eventDetail,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event's detail or description",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white10),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Center(
                  child: SizedBox(
                      width: 350,
                      height: 46,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white60),
                        ),
                        onPressed: () {
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Create Post'),
                                  content: Text(
                                      "Are you sure you want to create this post?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("No"),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          for (var language in languages.keys) {
                                            languages[language] == true
                                                ? trueLanguages.add(language)
                                                : {};
                                          }
                                          for (var category
                                              in categories.keys) {
                                            categories[category] == true
                                                ? trueCategories = category
                                                : {};
                                          }
                                          uploadEvent(currentUser.uid);
                                          setState(() {});
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, '/', (route) => false);
                                        },
                                        child: Text("yes"))
                                  ],
                                );
                              });
                        },
                        child: const Text(
                          'Request to Post',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
