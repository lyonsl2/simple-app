import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/ui/home/view_models/home_viewmodel.dart';
import 'package:tic_tac_toe/ui/home/widgets/home_screen.dart';

import 'routes.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        final viewModel = HomeViewModel(socketService: context.read());
        return HomeScreen(viewModel: viewModel);
      },
    ),
  ],
);
