import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'data/data_provider_module.dart';
import 'data/router/app_router.dart';

class App extends ConsumerWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var router = ref.watch(autoRouterProvider);
    return GlobalLoaderOverlay(
      child: MaterialApp.router(
        title: 'PicArtsso',
        theme: ThemeData.dark(),
        routerDelegate: router.delegate(initialRoutes: [HomeRoute()]),
        routeInformationParser: router.defaultRouteParser(),
      ),
    );
  }
}
