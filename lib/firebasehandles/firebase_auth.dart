import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthOperations {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late BuildContext context;

  FirebaseAuthOperations({required this.context});

  void showToast(String message, {Color backgroundColor = Colors.white, Color textColor = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      showToast('Error signing in: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      showToast('Error signing up: $e');
      return null;
    }
  }

  Future<User?> signInWithPhoneNumber(String phoneNumber) async {
    Completer<User?> completer = Completer<User?>();

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential = await _auth.signInWithCredential(credential);
          completer.complete(userCredential.user);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Error verifying phone number: $e');
          showToast('Error verifying phone number: $e');
          completer.complete(null);
        },
        codeSent: (String verificationId, int? resendToken) {
          // Handle code sent (e.g., show UI to enter verification code)
          // You can store the verificationId and resendToken for later use
          print('Code sent to $phoneNumber');
          showToast('Code sent to $phoneNumber');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout, handle the situation here
          print('Auto-retrieval timeout for $verificationId');
          showToast('Auto-retrieval timeout for $verificationId');
          completer.complete(null);
        },
        timeout: const Duration(seconds: 60), // Timeout for code auto-retrieval
      );
    } catch (e) {
      print('Error signing in with phone number: $e');
      showToast('Error signing in with phone number: $e');
      completer.complete(null);
    }

    return completer.future;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out');
      showToast('User signed out');
    } catch (e) {
      print('Error signing out: $e');
      showToast('Error signing out: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent');
      showToast('Password reset email sent');
    } catch (e) {
      print('Error sending password reset email: $e');
      showToast('Error sending password reset email: $e');
    }
  }

  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  String? getUserEmail() {
    return _auth.currentUser?.email;
  }
}
