import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  MyAuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;

  // This now streams new ID tokens when they refresh
  Stream<String?> get idTokenStream {
    return _auth.idTokenChanges().asyncMap((user) => user?.getIdToken());
  }
}
