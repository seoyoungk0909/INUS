import 'package:flutter/material.dart';
// import views
import 'posting_page.dart';
import 'event_page.dart';
import 'profile_page.dart';

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              icon: const Icon(Icons.person))
        ],
      ),
      body: Center(
        child: pageBuilder(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Posting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars_sharp),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'post_write'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
