import 'dart:async';

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

  Map<String, dynamic> createMap() {
    // Assuming your JSON file is named 'your_file.json'
    // Specify the file path
    // String filePath = 'create.json';
    //
    // // Load the JSON file
    // String jsonString = File(filePath as List<Object>).readAsStringSync();
    //
    // // Parse the JSON string into a Map
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    // // Convert the JSON string to a Dart Map
    // Map<String, dynamic> jsonData = convert.jsonDecode(jsonString);

    Map<String,dynamic> map = {
      "context": [
        "https://www.w3.org/ns/did/v1",
        "https://w3id.org/security/suites/ed25519-2020/v1"
      ],
      "id": "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H",
      "controller": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H"
      ],
      "alsoKnownAs": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H"
      ],
      "verificationMethod": [
        {
          "id": "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H#key-1",
          "type": "Ed25519VerificationKey2020",
          "controller": "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H",
          "publicKeyMultibase": "z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H",
          "blockchainAccountId": ""
        }
      ],
      "authentication": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H#key-1"
      ],
      "assertionMethod": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H#key-1"
      ],
      "keyAgreement": [],
      "capabilityInvocation": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H#key-1"
      ],
      "capabilityDelegation": [
        "did:hid:testnet:z6MkfExumxD1j2nnt4oxoyjAgmJ7SPxjroTkSLnZiziZxt7H#key-1"
      ],
      "service": []
    };
    return map;
  }

  Future<User?> createDidUser(UserCredential userCredential) async {
    // try {
    //   ApiService apiService = ApiService();
    //   Map<String,dynamic> credatedDid= await apiService.postCreateDid(namespace: "testnet");
    //   if(credatedDid.containsKey('metaData')) {
    //     Map<String,dynamic> metaData = credatedDid['metaData'];
    //     if(metaData.containsKey('didDocument')){
    //       Map<String,dynamic> didDocument = {
    //         "didDocument": metaData['didDocument'],
    //         "verificationMethodId": "${metaData['didDocument']['verificationMethod'][0]['id'] as String}#key-1"
    //       };
    //       Map<String,dynamic> responseDocument = await apiService.postRegisterDid(didDocument);
    //       Map<String,dynamic> userData = {
    //         "did": responseDocument['did'] as String,
    //         "email": userCredential.user?.email,
    //         "photo": userCredential.user?.photoURL
    //       };
    //
    //       // Inserting did to Firestore
    //       FirestoreHandler firestoreHandler = FirestoreHandler();
    //       if(await firestoreHandler.setDocument('DID', responseDocument['did'] as String, responseDocument) &&
    //           await firestoreHandler.setDocument('USER', userCredential.user?.email as String, userData)){
    //         firestoreHandler.closeFirestore();
    //         return userCredential.user;
    //       } else {
    //         debugPrint('ERROR : Failed to store in Firestore');
    //       }
    //       firestoreHandler.closeFirestore();
    //     } else {
    //       debugPrint("ERROR : metaData doesn't contains didDocument");
    //     }
    //   } else {
    //     debugPrint("ERROR : DID doesn't contains metaData");
    //   }
    //
    //   return null;
    // } catch (e) {
    //   debugPrint('Error in Creating Did createDidUser() : $e');
    //   return null;
    // }


    // Map<String,dynamic> didDocument = {
    //   "didDocument": dicDocs,
    //   "verificationMethodId": "${dicDocs['verificationMethod'][0]['id'] as String}#key-1"
    // };
    // Map<String,dynamic> responseDocument = await apiService.postRegisterDid(didDocument);
    // Map<String,dynamic> userData = {
    //   "did": responseDocument['did'] as String,
    //   "email": userCredential.user?.email,
    //   "photo": userCredential.user?.photoURL
    // };

    // // Inserting did to Firestore
    // FirestoreHandler firestoreHandler = FirestoreHandler();
    // if(await firestoreHandler.setDocument('DID', responseDocument['did'] as String, responseDocument) &&
    //     await firestoreHandler.setDocument('USER', userCredential.user?.email as String, userData)){
    //   firestoreHandler.closeFirestore();
    //   return userCredential.user;
    // } else {
    //   debugPrint('ERROR : Failed to store in Firestore');
    // }


    Map<String,dynamic> dicDocs = createMap();
    Map<String,dynamic> userData = {
      "did": dicDocs['id'] as String,
      "email": userCredential.user?.email,
      "photo": userCredential.user?.photoURL
    };
    FirestoreHandler firestoreHandler = FirestoreHandler();
    if(await firestoreHandler.setDocument('DID', dicDocs['id'] as String, dicDocs) &&
        await firestoreHandler.setDocument('USER', userCredential.user?.email as String, userData)){
      firestoreHandler.closeFirestore();
      return userCredential.user;
    } else {
      debugPrint('ERROR : Failed to store in Firestore');
    }
    return null;
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      debugPrint('list: $signInMethods');

      // If signInMethods is not empty, the email is already registered
      return signInMethods.isNotEmpty;
    } catch (e) {
      // Handle errors, such as invalid email or network issues
      print('Error checking email registration: $e');
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      // If sign-in fails, check the error code to determine the reason
      // if (e is FirebaseAuthException) {
      //   if (e.code == 'user-not-found') {
      //     // The email is not registered
      //     debugPrint('In user-not-found');
      //     return await signUpWithEmailAndPassword(email, password);
      //   } else {
      //     debugPrint('Error signing in: $e');
      //   }
      // } else {
      //   showToast('Error signing in: $e');
      // }
      showToast('Error in signInWithEmailAndPassword in: $e');
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = await createDidUser(userCredential);
      if (user == null){
        await signOut();
      }
      return user;
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
