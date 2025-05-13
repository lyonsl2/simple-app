import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/play/view_models/play_viewmodel.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key, required this.viewModel});

  final PlayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        if (viewModel.gameId == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (viewModel.isGameWon) {
          return const Scaffold(body: Center(child: Text('You won!')));
        }
        if (viewModel.isGameLost) {
          return const Scaffold(body: Center(child: Text('You lost!')));
        }
        if (viewModel.isGameOver) {
          return const Scaffold(body: Center(child: Text('You tied!')));
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Tic Tac Toe')),
          body: Table(
            border: TableBorder.all(),
            children: List.generate(3, (row) {
              return TableRow(
                children: List.generate(3, (col) {
                  int index = row * 3 + col;
                  return GestureDetector(
                    onTap: () => viewModel.handleTap(index),
                    child: Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        viewModel.board![index],
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
