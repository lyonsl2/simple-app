import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/data/auth_repository.dart';
import 'package:tic_tac_toe/ui/home/view_models/home_viewmodel.dart';
import 'package:tic_tac_toe/ui/home/widgets/home_screen.dart';
import 'package:tic_tac_toe/ui/login/widgets/login_page.dart';
import 'package:tic_tac_toe/ui/play/view_models/play_viewmodel.dart';
import 'package:tic_tac_toe/ui/play/widgets/play_screen.dart';

import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(AuthRepository authRepository) => GoRouter(
  initialLocation: Routes.login,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(authRepository: context.read());
        return HomeScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: Routes.play,
      builder: (context, state) {
        final viewModel = PlayViewModel(socketService: context.read());
        return PlayScreen(viewModel: viewModel);
      },
    ),
  ],
);

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final user = context.read<AuthRepository>().user;
  final loggingIn = state.matchedLocation == Routes.login;
  if (user == null) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.home;
  }

  // no need to redirect at all
  return null;
}
