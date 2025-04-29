import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/pages/home_page.dart';
import 'package:tic_tac_toe/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MyAuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
            ],
          );
        },
        '/home': (context) => const HomePage(),
      },

      // title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      // home: user == null ? LoginScreen() : const SocketPage(),
    );
  }
}
