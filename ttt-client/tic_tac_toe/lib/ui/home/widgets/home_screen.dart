import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/home/view_models/home_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: viewModel.messages.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(viewModel.messages[index]));
        },
      ),
    );
  }
}
