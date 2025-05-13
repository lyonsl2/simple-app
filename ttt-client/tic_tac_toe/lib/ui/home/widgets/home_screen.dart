import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/home/view_models/home_viewmodel.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:tic_tac_toe/ui/home/widgets/game_page.dart';
import 'package:tic_tac_toe/ui/home/widgets/leaderboard_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.viewModel})
    : _pages = [
        GamePage(viewModel: viewModel),
        LeaderboardPage(),
        ProfileScreen(),
      ];

  final HomeViewModel viewModel;

  final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        print(viewModel.currentIndex);
        return Scaffold(
          body: _pages[viewModel.currentIndex],
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            selectedIndex: viewModel.currentIndex,
            onDestinationSelected: viewModel.setCurrentIndex,
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
      },
    );
  }
}
