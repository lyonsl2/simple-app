import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/router.dart';
import 'config/dependencies.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router());
  }
}
