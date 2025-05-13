import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/auth_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  HomeViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    print('HomeViewModel!!!');
  }

  void setCurrentIndex(int index) {
    print(index);
    _currentIndex = index;
    notifyListeners();
  }
}
