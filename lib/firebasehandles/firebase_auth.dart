import 'dart:async';

import 'package:OptiWallet/apihandler/api_handler.dart';
import 'package:OptiWallet/firebasehandles/auth_provider.dart';
import 'package:OptiWallet/firebasehandles/firestore_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FirebaseAuthOperations {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
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
      ApiService apiService = ApiService();
      Map<String,dynamic> credatedDid= await apiService.postCreateDid("testnet");
      if(credatedDid.containsKey('metaData')) {
        Map<String,dynamic> metaData = credatedDid['metaData'];
        if(metaData.containsKey('didDocument') && metaData.containsKey('verificationMethod')){
          Map<String,dynamic> didDocument = {
            "didDocument": metaData['didDocument'],
            "verificationMethodId": metaData['verificationMethod']['id'] as String
          };
          Map<String,dynamic> responseDocument = await apiService.postRegisterDid(didDocument);
          Map<String,dynamic> userData = {
            "did": responseDocument['did'] as String,
            "name": userCredential.user?.email,
            "photo": userCredential.user?.providerData
          };

          // Inserting did to Firestore
          FirestoreHandler firestoreHandler = FirestoreHandler();
          if(await firestoreHandler.setDocument('DID', responseDocument['did'] as String, responseDocument)
          &&
          await firestoreHandler.setDocument('USER', userCredential.user?.email as String, userData)){
            return userCredential.user;
          }
        }
      }
      await signOut();
      return null;
    } catch (e) {
      // If sign-in fails, check the error code to determine the reason
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          // The email is not registered
          return await signUpWithEmailAndPassword(email, password);
        }
      }
      debugPrint('Error signing in: $e');
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
      debugPrint('Error signing up: $e');
      showToast('Error signing up: $e');
      return null;
    }
  }

  // Sign in with phone number
  Future<void> signInWithPhoneNumber(String phoneNumber, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('Verification Failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Code Auto Retrieval Timeout');
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // Sign in with verification code
  Future<UserCredential?> signInWithVerificationCode(String verificationId, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Error signing in with verification code: $e');
      return null;
    }
  }

  // Get the current signed-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user details
  Future<User?> getUserDetails() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return _auth.currentUser;
    }
    return null;
  }


  // Sign out
  void signOutProvider() {
    Provider.of<MyAuthProvider>(context).setLoggedIn(false);
    Provider.of<MyAuthProvider>(context).setUser(null);
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('User signed out');
      showToast('User signed out');
      signOutProvider();
    } catch (e) {
      print('Error signing out: $e');
      showToast('Error signing out: $e');
    }
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
