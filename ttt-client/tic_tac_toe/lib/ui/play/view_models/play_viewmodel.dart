import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/data/socket_service.dart';

class PlayViewModel extends ChangeNotifier {
  final SocketService _socketService;
  late final StreamSubscription _subscription;
  String? _gameId;
  List<String>? _board;
  String? _symbol;
  String? _turn;
  bool _isGameWon = false;
  bool _isGameLost = false;
  bool _isGameOver = false;

  List<String>? get board => _board == null ? null : List.unmodifiable(_board!);
  String? get gameId => _gameId;
  bool get isGameWon => _isGameWon;
  bool get isGameLost => _isGameLost;
  bool get isGameOver => _isGameOver;

  PlayViewModel({required SocketService socketService})
    : _socketService = socketService {
    print('PlayViewModel!!!');
    _socketService.connect();
    _subscription = _socketService.stream.listen(handleStreamEvent);
    final message = {"action": "sendmessage", "subaction": "joinGame"};
    _socketService.sendMessage(jsonEncode(message));
  }

  void handleStreamEvent(dynamic data) {
    final parsedData = jsonDecode(data);
    print(data);
    print(parsedData['event']);
    print(parsedData['data']);
    switch (parsedData['event']) {
      case 'joinedGame':
        _symbol = parsedData['data']['symbol'];
        _turn = parsedData['data']['turn'];
        _gameId = parsedData['data']['gameId'];
        print(_gameId);
        _board = List.filled(9, '');
        break;
      case 'moveMade':
        _board = parsedData['data']['board'].cast<String>();
        _turn = parsedData['data']['turn'];
        break;
      case 'gameWon':
        _board = parsedData['data']['board'].cast<String>();
        _isGameWon = true;
        _isGameOver = true;
        break;
      case 'gameLost':
        _board = parsedData['data']['board'].cast<String>();
        _isGameLost = true;
        _isGameOver = true;
        break;
      case 'gameOver':
        _board = parsedData['data']['board'].cast<String>();
        _isGameOver = true;
        break;
      case 'placedInQueue':
        return;
      case 'error':
        break;
      default:
        print('Unknown event: ${parsedData['event']}');
        return;
    }
    notifyListeners();
  }

  void handleTap(int index) {
    print('handlTap');
    if (_turn != _symbol) {
      return;
    }
    final move = {
      "action": "sendmessage",
      "subaction": "makeMove",
      "data": {"gameId": _gameId, "move": index},
    };

    _board![index] = _symbol!;

    _socketService.sendMessage(jsonEncode(move));
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _socketService.dispose();
    super.dispose();
  }
}
