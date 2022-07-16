import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qemma_mobile/firebase_options.dart';
import 'package:qemma_mobile/helpers/app_locales.dart';
import 'package:qemma_mobile/pages/blocked.dart';
import 'package:qemma_mobile/pages/no_network.dart';
import 'package:qemma_mobile/pages/student.dart';
import 'package:qemma_mobile/pages/landing.dart';
import 'package:qemma_mobile/pages/pending.dart';
import 'package:qemma_mobile/pages/signin.dart';
import 'package:qemma_mobile/pages/signup.dart';
import 'package:qemma_mobile/helpers/app_theme.dart';
import 'package:qemma_mobile/presenters/student_presenter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await StudentPresenter.initStudent();
  var locale = await Locales.init(Platform.localeName.split('_')[0]);
  await Jiffy.locale(locale?.code ?? 'ar');
  runApp(Application(
      networkStatus: locale != null, isLogged: StudentPresenter.isLogged()));
}

class Application extends StatelessWidget {
  const Application(
      {Key? key, required this.networkStatus, required this.isLogged})
      : super(key: key);
  final bool isLogged;
  final bool networkStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Al-Qemma',
      initialRoute: !networkStatus
          ? "/no-network"
          : isLogged
              ? "/home"
              : "/landing",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      routes: {
        "/landing": (BuildContext context) => const LandingPage(),
        "/home": (BuildContext context) => const StudentPage(),
        "/sign-up": (BuildContext context) => SignupPage(),
        "/sign-in": (BuildContext context) => SigninPage(),
        "/pending": (BuildContext context) => const PendingPage(),
        "/blocked": (BuildContext context) => const BlockedPage(),
        "/no-network": (BuildContext context) => const NoNetworkPage()
      },
    );
  }
}
