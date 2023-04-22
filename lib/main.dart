import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
// firebase related
import 'firebase_login_state.dart';
import 'firebase_options.dart';
// import views (screens)
import 'views/post_detail_page.dart';
import 'views/post_write_page.dart';
import 'views/login_flow/new_login_page.dart';
import 'views/login_flow/password_reset_page.dart';
import 'views/login_flow/verify_page.dart';
import 'views/login_flow/welcome_page.dart';
import 'views/login_flow/name_form.dart';
import 'views/login_flow/email_form.dart';
import 'views/login_flow/nickname_form.dart';
import 'views/login_flow/password_form.dart';
import 'views/home_page.dart';
import 'views/event_detail_page.dart';
import 'views/event_write_page.dart';
import 'views/report_page.dart';
import 'views/more_page.dart';

import 'utils/color_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  User? user = await FirebaseAuth.instance.userChanges().first;
  bool complete = user != null && await isUserSetupComplete(user, null);
  String initialRoute = (complete) ? "/" : "login";
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
  final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: MaterialApp(
        title: 'AUS',
        theme: ThemeData(
            primaryColorDark: ApdiColors.darkerBackground,
            backgroundColor: ApdiColors.darkBackground,
            colorScheme: ColorScheme(
                brightness: Brightness.dark,
                primary: ApdiColors.themeGreen,
                onPrimary: ApdiColors.lightText,
                secondary: ApdiColors.pointGreen,
                onSecondary: ApdiColors.lightText,
                error: ApdiColors.errorRed,
                onError: ApdiColors.lightText,
                background: ApdiColors.darkerBackground,
                onBackground: ApdiColors.lightText,
                surface: ApdiColors.darkBackground,
                onSurface: ApdiColors.lightText),
            textTheme: TextTheme(
              bodyText2: TextStyle(color: ApdiColors.lightText),
              labelMedium: TextStyle(color: ApdiColors.greyText, fontSize: 14),
            )),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => UpgradeAlert(
              upgrader: Upgrader(minAppVersion: "1.0.2", showIgnore: false),
              child: const HomePage(title: 'APDI')),
          'login': (context) => const LoginPage(),
          'password_reset': (context) => const PasswordResetPage(),
          'name_form': (context) => const NameFormPage(),
          'email_form': (context) => const EmailFormPage(),
          'nickname_form': (context) => const NickNameFormPage(),
          'password_form': (context) => const PasswordFormPage(),
          'verify': (context) => const VerifyPage(),
          'welcome': (context) => const WelcomePage(),
          'post_write': (context) => const PostWritePage(title: 'Create Post'),
          'event_write': (context) =>
              const EventWritePage(title: 'Create Event'),
          'post_detail': (context) => const PostDetailPage(title: 'Community'),
          'event_detail': (context) => const EventDetailPage(title: 'Events'),
          'report': (context) => const ReportPage(title: 'Report'),
          'more': (context) => const MorePage(),
        },
      ),
    );
  }
}
