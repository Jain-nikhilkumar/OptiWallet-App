import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  User? get getUser => _user;

  void setUser(User? user) {
    _user = user!;
    notifyListeners();
  }
}
