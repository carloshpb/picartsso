import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/data_provider_module.dart';
import 'data/router/app_router.dart';
import 'presentation/view/widgets/animations/loading_overlay.dart';

class App extends ConsumerWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var router = ref.watch(autoRouterProvider);
    return MaterialApp.router(
      title: 'PicArtsso',
      theme: ThemeData.dark(),
      routerDelegate: router.delegate(initialRoutes: [HomeRoute()]),
      routeInformationParser: router.defaultRouteParser(),
    );
  }
}
