import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import views
import 'components/terms_condition_popup.dart';
import 'posting_page.dart';
import 'event_page.dart';
import 'profile_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSpeedDialOpen = false;
  Widget _speedDialIcon = SizedBox(
    width: 32, // set the width to the desired size
    height: 32, // set the height to the desired size
    child: SvgPicture.asset("assets/icons/add-square-02.svg"),
  );

  Widget pageBuilder(int index) {
    switch (index) {
      case 0:
        return const EventPage(title: "events");
      case 1:
        return const PostListPage(title: 'Posts');
      case 2:
        return const ProfilePage(title: "Profile");
      default:
        throw Exception("Index Error");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore.instance
        .collection('user_info')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    userRef.get().then((DocumentSnapshot<Map<String, dynamic>> dataMap) {
      bool confirmed = dataMap.data()!.containsKey('tc_confirmed') &&
          dataMap['tc_confirmed'];
      if (!confirmed) {
        Future.delayed(Duration(seconds: 2), () {
          showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return const TCPopup();
              });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        (ModalRoute.of(context)?.settings.arguments ?? <String, bool>{}) as Map;
    if (arguments['postpage'] == true) {
      _selectedIndex = 1;
      arguments['postpage'] = false;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: pageBuilder(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        selectedFontSize: 12.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/calendar-01.svg',
              color: Colors.white,
            ),
            icon: SvgPicture.asset(
              'assets/icons/calendar-01.svg',
              color: Colors.grey,
            ),
            // icon: Icon(Icons.group),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/users-profiles-02.svg',
              color: Colors.white,
            ),
            icon: SvgPicture.asset(
              'assets/icons/users-profiles-02.svg',
              color: Colors.grey,
            ),
            // icon: Icon(Icons.calendar_today),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              'assets/icons/user-profile-circle.svg',
              color: Colors.white,
            ),
            icon: SvgPicture.asset(
              'assets/icons/user-profile-circle.svg',
              color: Colors.grey,
            ),
            // icon: Icon(Icons.stars_sharp),
            label: 'My',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            List pageName = ['posts', 'events', 'profile'];
            FirebaseAnalytics.instance.logEvent(
              name: 'pages',
              parameters: {'page': pageName[_selectedIndex]},
            );
          });
        },
      ),
      floatingActionButton: SpeedDial(
        // childMargin: const EdgeInsets.symmetric(horizontal: 150, vertical: 50),
        // childPadding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        // icon: Icons.add,
        spacing: 4,
        spaceBetweenChildren: 4,
        //activeIcon: Icons.close,
        buttonSize: Size(50, 50),
        overlayOpacity: 0.3,
        // spacing: 8,
        children: [
          SpeedDialChild(
              // shape: RoundedRectangleBorder(),
              // child: Container(
              //     child: Row(
              //   children: [Icon(Icons.save), Text("Create Post")],
              // )),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  "assets/icons/create-post.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              label: "Create Post",
              onTap: () => Navigator.pushNamed(context, 'post_write')),
          SpeedDialChild(
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  "assets/icons/create-event.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              label: "Create Event",
              onTap: () => Navigator.pushNamed(context, 'event_write')),
        ],
        onOpen: () {
          setState(() {
            _isSpeedDialOpen = true;
            _speedDialIcon = SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset("assets/icons/x-01.svg"),
            );
          });
        },
        onClose: () {
          setState(() {
            _isSpeedDialOpen = false;
            _speedDialIcon = SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset("assets/icons/add-square-02.svg"),
            );
          });
        },
        child: _speedDialIcon,
      ),
    );
  }
}
