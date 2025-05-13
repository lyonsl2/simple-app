import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  User? get user => _user;

  AuthRepository() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }
}
