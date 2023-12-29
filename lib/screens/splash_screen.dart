import 'dart:async';

import 'package:aai_chennai/screens/dashboard_screen.dart';
import 'package:aai_chennai/screens/login_screen.dart';
import 'package:aai_chennai/utils/global_storage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Global.storage.load().whenComplete(() => navigateScreen());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(body : Container());
  }

  void navigateScreen() {
    if (Global.storage.hasUserLogined) {
      navigateToHomeScreen();
    } else {
      navigateToLoginScreen();
    }
  }

  void navigateToLoginScreen() {
    Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen())));
  }

  void navigateToHomeScreen() {
    Timer(
        const Duration(seconds: 1),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const DashboardScreen())));
  }
}