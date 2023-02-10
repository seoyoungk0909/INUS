import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/color_utils.dart';

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
      'time': Timestamp.fromDate(
        DateTime(date.year, date.month, date.day, time.hour, time.minute),
      ),
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

  late TimeOfDay time;
  late DateTime date;

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
      initialEntryMode: DatePickerEntryMode.calendar,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );
    if (pickedDate == null) return;
    date = pickedDate;
    setState(() => _selectedDate = pickedDate);
  }

  Future _pickTimeDialog(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (pickedTime == null) return;
    time = pickedTime;
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
  Map<String, bool> textChecker = {
    'Title': false,
    'Tags': false,
    'Date': false,
    'Time': false,
  };
  bool isButtonEnabled = false;

  Future textChecking() async {
    if (textChecker['Title']! &&
        textChecker['Tags']! &&
        textChecker['Date']! &&
        textChecker['Time']!) {
      setState(() {
        isButtonEnabled = true;
      });
    } else {
      setState(() {
        isButtonEnabled = false;
      });
    }
  }

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
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Discard Writings'),
                    content: Text(
                        "Are you sure you want to go back to the main page? (All you have written will be lost!) "),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No"),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("yes"))
                    ],
                  );
                });
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: RichText(
                  text: const TextSpan(
                      text: "Category",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
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
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: RichText(
                  text: TextSpan(
                      text: "Title",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: eventTitle,
                      onChanged: (content) {
                        if (content != "") {
                          textChecker['Title'] = true;
                          textChecking();
                        } else {
                          textChecker['Title'] = false;
                          textChecking();
                        }
                      },
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
                child: RichText(
                  text: TextSpan(
                      text: "Tags",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' (max. 1-2)',
                            style: TextStyle(
                                color: Colors.white10,
                                fontWeight: FontWeight.normal,
                                fontSize: 16)),
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 340,
                  height: 50,
                  child: TextField(
                      controller: tags,
                      onChanged: (content) {
                        if (content != "") {
                          textChecker['Tags'] = true;
                          textChecking();
                        } else {
                          textChecker['Tags'] = false;
                          textChecking();
                        }
                      },
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
                child: RichText(
                  text: TextSpan(
                      text: "Date and Time",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
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
                                    fontSize: 15.0, color: Colors.white54)),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                            onPressed: () {
                              _pickDateDialog(context);
                              textChecker['Date'] = true;
                              textChecking();
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
                                    fontSize: 15.0, color: Colors.white54)),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                            ),
                            onPressed: () {
                              _pickTimeDialog(context);
                              textChecker['Time'] = true;
                              textChecking();
                            }))
                  ])),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: RichText(
                  text: TextSpan(
                      text: "Language(s)",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
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
                                setState(() {
                                  languages[language] == true
                                      ? languages[language] = false
                                      : languages[language] = true;
                                  if (languages.values
                                          .toList()
                                          .where((item) => item == false)
                                          .length ==
                                      3) {
                                    languages[language] = true;
                                  }
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
                  height: 250,
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
                    ),
                    maxLines: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                child: Center(
                  child: SizedBox(
                      width: 350,
                      height: 46,
                      child: isButtonEnabled
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ApdiColors.themeGreen),
                              ),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Create Post'),
                                        content: Text(
                                            "Are you sure you want to create this event?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("No"),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                for (var language
                                                    in languages.keys) {
                                                  languages[language] == true
                                                      ? trueLanguages
                                                          .add(language)
                                                      : {};
                                                }
                                                for (var category
                                                    in categories.keys) {
                                                  categories[category] == true
                                                      ? trueCategories =
                                                          category
                                                      : {};
                                                }
                                                uploadEvent(currentUser.uid);
                                                setState(() {});
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                        context,
                                                        '/',
                                                        (route) => false);
                                              },
                                              child: Text("yes"))
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Request Event',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white60),
                              ),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Warning'),
                                        content: Text(
                                            "You have not filled certain parts. Please check again"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("OK"),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Request Event',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
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
