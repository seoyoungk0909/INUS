import 'package:flutter/material.dart';
// import views (screens)
import 'views/post_detail_page.dart';
import 'views/post_write_page.dart';
import 'views/login_flow/login_page.dart';
import 'views/login_flow/password_reset_page.dart';
import 'views/login_flow/verify_page.dart';
import 'views/login_flow/welcome_page.dart';
import 'views/home_page.dart';

import 'utils/color_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AUS',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          colorScheme: ColorScheme.fromSwatch(
            primaryColorDark: Colors.black,
            accentColor: hexStringToColor("#4CA98F"),
            cardColor: hexStringToColor("##3E3E3E"),
            backgroundColor: Colors.black,
            errorColor: Colors.red[300],
            brightness: Brightness.dark,
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(color: Colors.white),
          )),
      home: const HomePage(title: 'APDI'),
      routes: {
        'login': (context) => const LoginPageWidget(),
        'password_reset': (context) => const PasswordResetPage(),
        'verify': (context) => const VerifyPage(),
        'welcome': (context) => const WelcomePage(),
        'post_write': (context) => const PostWritePage(title: 'New Post'),
        'post_detail': (context) => const PostDetailPage(title: 'Community'),
      },
    );
  }
}
