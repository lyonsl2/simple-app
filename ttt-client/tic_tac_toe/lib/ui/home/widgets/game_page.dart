import 'package:flutter/material.dart';
import 'package:tic_tac_toe/routing/routes.dart';
import 'package:tic_tac_toe/ui/home/view_models/home_viewmodel.dart';
import 'package:go_router/go_router.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Game', style: TextStyle(fontSize: 24)),
          ElevatedButton(
            onPressed: () => context.go(Routes.play),
            child: const Text('Join game'),
          ),
        ],
      ),
    );
  }
}
