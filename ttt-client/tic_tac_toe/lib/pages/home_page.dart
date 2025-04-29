import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/pages/leaderboard_page.dart';
import 'package:tic_tac_toe/pages/game_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:tic_tac_toe/providers/auth_provider.dart';
import 'package:tic_tac_toe/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final SocketService _socketService = SocketService();
  Stream<String?>? _tokenStream;
  late final Stream<String?> _idTokenStreamSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);

    // Subscribe only once
    if (_tokenStream == null) {
      _tokenStream = authProvider.idTokenStream;

      _idTokenStreamSub = _tokenStream!;
      _idTokenStreamSub.listen((token) {
        if (token != null) {
          _socketService.connect(authToken: token);
        } else {
          _socketService.disconnect();
        }
      });
    }
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  final List<Widget> _pages = [
    GamePage(),
    LeaderboardPage(),
    ProfileScreen(
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacementNamed(context, '/sign-in');
        }),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.videogame_asset_outlined),
            selectedIcon: Icon(Icons.videogame_asset),
            label: 'Game',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
