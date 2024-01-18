// main.dart
import 'package:OptiWallet/firebasehandles/auth_provider.dart';
import 'package:OptiWallet/pages/login.dart';
// import 'package:OptiWallet/pages/login_page.dart';
import 'package:OptiWallet/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:OptiWallet/firebase_options.dart';
import 'package:OptiWallet/pages/home_page.dart';
import 'package:provider/provider.dart';
// Import the SplashScreen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAuthProvider(),
      child: const MainApp(),
    ),
  );
  // runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiWallet App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Use SplashScreen as the initial screen
      home: const SplashScreen(),
      // home: const HomePage(),
      // initialRoute: '/login',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        // Handle onGenerateRoute for other routes if needed
        // For example, redirect to login if not authenticated
        final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

        if (!authProvider.isLoggedIn) {
          return MaterialPageRoute(builder: (context) => const LoginPage());
        }

        return MaterialPageRoute(builder: (context) => const HomePage());
      },
    );
  }
}

