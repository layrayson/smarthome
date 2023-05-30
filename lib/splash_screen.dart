import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smarthome/home.dart';
import 'package:smarthome/icons/smart_home_icon.dart';
import 'package:smarthome/login.dart';
import 'package:smarthome/main_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainApp()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          height: 64,
          width: 64,
          child: SmartHomeIcon(),
        ),
      ),
    );
  }
}
