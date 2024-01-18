import 'package:OptiWallet/firebasehandles/auth_provider.dart';
import 'package:OptiWallet/firebasehandles/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  // final List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());


  late FirebaseAuthOperations _authHandler;
  late String _verificationId;

  @override
  void initState() {
    super.initState();
    _authHandler = FirebaseAuthOperations(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/img.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( // Wrap the first container with Expanded
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.1),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.20,
                      height: screenWidth * 0.20,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Lottie.asset(
                        'assets/top_animation.json',
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded( // Wrap the second container with Expanded
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.05),
                padding: EdgeInsets.all(screenWidth * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.09,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          labelText: 'Enter Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.email_rounded, color: Colors.white,),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.09,
                      child: TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _passwordVisible ? false : true, // Set this to true to hide the entered text
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          counter: const Offstage(),
                          labelText: 'Enter Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.password_rounded, color: Colors.white,),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02), // Adjusted the top padding
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: screenHeight * 0.1, // Adjusted the width
                          height: screenHeight * 0.1, // Adjusted the height
                          child: FloatingActionButton(
                            backgroundColor: Colors.green,
                            onPressed: _login,
                            // onPressed: () {
                              // Implement your logic here
                              // String otpCode = controllers.map((controller) => controller.text).join();
                              // _verifyOTP(otpCode, context);
                            // },
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 32.0, // Adjusted the size
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    String email = _emailController.value.text.toString();
    String password = _passwordController.value.text.toString();
    try {
      debugPrint('Email: $email, Password: $password');
      User? userCredential = await _authHandler.signInWithEmailAndPassword(email, password);
      if (userCredential != null) {
        // Successfully signed in
        debugPrint('User signed in: ${userCredential.displayName}');
        // Set the authentication status to true
        Provider.of<MyAuthProvider>(context, listen: false).setUser(userCredential!);
        // Navigate to the home screen
        navigateTo('/home');
      } else {
        showDialogBox('dialogTitle', 'dialogContent');
      }
    } catch (e) {
      debugPrint('Error in Login $e');
    }
  }

  Future<void> _signInWithPhone(String phoneNumber) async {
    try {
      _authHandler.signInWithPhoneNumber('+918600679220', (verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      });
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  void _verifyOTP(String otp, BuildContext context) async {
    UserCredential? userCredential = await _authHandler.signInWithVerificationCode(_verificationId, otp);
    try {
      if (userCredential != null) {
        // Successfully signed in
        debugPrint('User signed in: ${userCredential.user?.phoneNumber}');
        // Set the authentication status to true
        Provider.of<MyAuthProvider>(context, listen: false).setLoggedIn(true);

        // Navigate to the home screen
        navigateTo('/home');
      } else {
        // OTP verification failed
        showDialogBox('Authentication', 'Failed to verify OTP');
        // Handle accordingly, e.g., show an error message
      }
    } catch (e) {
      debugPrint('Error Verifying OTP: $e');
    }
  }

  Future showDialogBox(String dialogTitle, String dialogContent){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

}
