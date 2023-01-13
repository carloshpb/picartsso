import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/view/screens/full_size_pic_screen.dart';
import '../presentation/view/screens/home_screen.dart';
import '../presentation/view/screens/transfer_style_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouterProvider = Provider<GoRouter>((_) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: [
          ShellRoute(
            pageBuilder: (context, state, child) => MaterialPage(
              child: HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: child,
              ),
            ),
            routes: [
              GoRoute(
                path: 'result',
                builder: (BuildContext context, GoRouterState state) {
                  return const FullSizePicScreen();
                },
              ),
              GoRoute(
                path: 'pick',
                builder: (BuildContext context, GoRouterState state) {
                  return const TransferStyleScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
