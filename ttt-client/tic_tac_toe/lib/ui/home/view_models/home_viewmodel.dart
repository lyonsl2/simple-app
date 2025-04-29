import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/socket_service.dart';

class HomeViewModel extends ChangeNotifier {
  late final SocketService _socketService;
  HomeViewModel({required SocketService socketService}) {
    print('HomeViewModel!!!');
    _socketService = socketService;

    _socketService.connect(authToken: '');

    _subscription = _socketService.messages.listen((data) {
      _messages.add(data);
      notifyListeners();
    });
  }

  late final StreamSubscription _subscription;
  final List<String> _messages = ['Message 1'];

  List<String> get messages => List.unmodifiable(_messages);

  @override
  void dispose() {
    _subscription.cancel();
    _socketService.disconnect();
    super.dispose();
  }
}
