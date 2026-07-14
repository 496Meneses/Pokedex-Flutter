import 'package:go_router/go_router.dart';

import '../models/pokemon.dart';
import '../screens/detail_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/app_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ]),
      ],
    ),
    GoRoute(
      path: '/pokemon/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final pokemon = state.extra as Pokemon?;
        return DetailScreen(id: id, pokemon: pokemon);
      },
    ),
  ],
);
