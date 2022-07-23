import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/view/screens/display_picture_screen.dart';
import '../../presentation/view/screens/home_screen.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: HomeScreen,
      initial: true,
    ),
    AutoRoute(
      page: DisplayPictureScreen,
    ),
  ],
)
// extend the generated private router
// class AppRouter extends _$AppRouter {}
class AppRouter extends _$AppRouter {}
