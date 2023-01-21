import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import views
import 'posting_page.dart';
import 'event_page.dart';
import 'profile_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget pageBuilder(int index) {
    switch (index) {
      case 0:
        return const PostListPage(title: 'Posts');
      case 1:
        return const EventPage(title: "events");
      case 2:
        return const ProfilePage(title: "Profile");
      default:
        throw Exception("Index Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
        centerTitle: false,
      ),
      body: Center(
        child: pageBuilder(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 12.0,
        items: <BottomNavigationBarItem>[
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
            label: 'Posting',
          ),
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
            label: 'Events',
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
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
              child: Icon(Icons.save),
              label: "Create Post",
              onTap: () => Navigator.pushNamed(context, 'post_write')),
          SpeedDialChild(
              child: Icon(Icons.event),
              label: "Create Event",
              onTap: () => Navigator.pushNamed(context, 'event_write')),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.pushNamed(context, 'post_write'),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
