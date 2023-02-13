import 'package:aus/controllers/event_controller.dart';
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
      'tag': tags.text.split(' '),
      'time': Timestamp.fromDate(
        DateTime(date.year, date.month, date.day, time.hour, time.minute),
      ),
      'language': trueLanguages,
      'category': trueCategories,
      'location': eventLocation.text.trim(),
      'registrationLink': eventRegistrationLink.text.trim(),
      'eventDetail': eventDetail.text.trim(),
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
    'Mandarin': false,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Discard Writings',
                      style: TextStyle(fontSize: 16),
                    ),
                    content: const Text(
                        "Are you sure you want to go back to the main page? (All you have written will be lost!) ",
                        style: TextStyle(fontSize: 12)),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "No",
                          style: TextStyle(color: ApdiColors.themeGreen),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: ApdiColors.themeGreen),
                          ))
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
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ]),
                ),
              ),
              SizedBox(
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
                            width: 95,
                            height: 35,
                            decoration: BoxDecoration(
                                color: categories[category]!
                                    ? Colors.white12
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 0.5,
                                    color: categories[category]!
                                        ? Colors.white12
                                        : Colors.white24),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
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
                                    fontSize: 14,
                                    fontWeight: categories[category]!
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: categories[category]!
                                        ? Color(0xff57AD9E)
                                        : Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: RichText(
                  text: const TextSpan(
                      text: "Title",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
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
                          borderSide: const BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event name",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white24,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: RichText(
                  text: const TextSpan(
                      text: "Tags",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: ' (max. 1-2, separated by space)',
                            style: TextStyle(
                                color: Colors.white24,
                                fontWeight: FontWeight.normal,
                                fontSize: 14)),
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
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
                          borderSide: const BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input tag",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white24,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: RichText(
                  text: const TextSpan(
                      text: "Date and Time",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ]),
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(25, 20, 0, 0),
                  child: Row(children: <Widget>[
                    SizedBox(
                        width: 130,
                        height: 50,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          onPressed: () {
                            _pickDateDialog(context);
                            textChecker['Date'] = true;
                            textChecking();
                          },
                          child: Text(
                            getDate(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white24,
                            ),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 100,
                        height: 50,
                        child: OutlinedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          onPressed: () {
                            _pickTimeDialog(context);
                            textChecker['Time'] = true;
                            textChecking();
                          },
                          child: Text(getTime(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white24,
                              )),
                        ))
                  ])),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: RichText(
                  text: const TextSpan(
                      text: "Language(s)",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            text: ' *',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 16))
                      ]),
                ),
              ),
              SizedBox(
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
                            width: 95,
                            height: 35,
                            decoration: BoxDecoration(
                                color: languages[language]!
                                    ? Colors.white12
                                    : Colors.transparent,
                                border: Border.all(
                                    width: 0.5,
                                    color: languages[language]!
                                        ? Colors.white12
                                        : Colors.white24),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
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
                                    fontSize: 14,
                                    fontWeight: languages[language]!
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    color: languages[language]!
                                        ? ApdiColors.themeGreen
                                        : Colors.white70),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 20),
                child: Text(
                  " Location",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600),
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
                          borderSide: const BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event's location here.",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white24,
                        ),
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
                      fontWeight: FontWeight.w600),
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
                          borderSide: const BorderSide(
                              width: 1, color: Colors.white24), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        hintText: "Input event's registration URL here.",
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white24,
                        ),
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
                      fontWeight: FontWeight.w600),
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
                        borderSide: const BorderSide(
                            width: 1, color: Colors.white24), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Input event's detail or description",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.white24,
                      ),
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
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    ApdiColors.themeGreen),
                              ),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Create Event',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to create this event?",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: ApdiColors.themeGreen),
                                            ),
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
                                              child: Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color:
                                                        ApdiColors.themeGreen),
                                              ))
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Request to Post',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white60),
                              ),
                              onPressed: () {
                                showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Warning',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        content: const Text(
                                          "You have not filled certain parts. Please check again.",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: ApdiColors.themeGreen),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: const Text(
                                'Request to Post',
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
            ],
          ),
        ),
      ),
    );
  }
}
