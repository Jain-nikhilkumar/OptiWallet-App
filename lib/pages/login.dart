import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            Container(
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
            Container(
              padding: EdgeInsets.all(screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.07,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.purpleAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement your login functionality here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Generate OTP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.00),
                    child: Column(
                      children: [
                        const Text(
                          'Enter OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // Adjusted the spacing between OTP input boxes
                            children: List.generate(
                              6,
                                  (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0), // Add margin
                                child: Container(
                                  width: screenHeight * 0.06,
                                  height: screenHeight * 0.07,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: InputDecoration(
                                      counter: Offstage(),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.04),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: screenHeight * 0.14,
                        height: screenHeight * 0.14,
                        child: FloatingActionButton(
                          backgroundColor: Colors.green,
                          onPressed: () {
                            // Implement your logic here
                          },
                          child: const Icon(
                            Icons.arrow_forward,
                            size: 40.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
