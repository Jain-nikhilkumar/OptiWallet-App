// main.dart
import 'package:OptiWallet/pages/card.dart';
import 'package:OptiWallet/pages/login.dart';
import 'package:OptiWallet/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:OptiWallet/firebase_options.dart';
// import 'package:OptiWallet/pages/login_page.dart';
import 'package:OptiWallet/pages/home_page.dart';
// Import the SplashScreen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiWallet App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use SplashScreen as the initial screen
      // home: const SplashScreen(),
      // home: const HomePage(),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(), // Add route for LoginPage
        '/home': (context) => const HomePage(),
      },
    );
  }
}
