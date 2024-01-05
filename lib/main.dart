// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:OptiWallet/firebase_options.dart';
import 'package:OptiWallet/login_page.dart';
import 'package:OptiWallet/demo_home_page.dart';
import 'package:OptiWallet/splash_screen.dart'; // Import the SplashScreen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiWallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use SplashScreen as the initial screen
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(), // Add route for LoginPage
        '/home': (context) => const DemoHomePage(),
      },
    );
  }
}
