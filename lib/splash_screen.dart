// splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Import the dart:async library

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to navigate to the login page after a specified duration
    Future.delayed(const Duration(seconds: 4), () {
      // Replace '/login' with the actual route for your login page
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash_screen.jpg'),
      ),
    );
  }
}
