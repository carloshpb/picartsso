import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/services/impl/art_service_impl.dart';
import 'domain/services/impl/transfer_style_service_impl.dart';
import 'router/app_router.dart';

class App extends ConsumerWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _artService = ref.watch(artService);
    final _transferStyleService = ref.watch(transferStyleService);

    // TODO : Create chain of Futures to load every module and images, then at final of the chain to hide splash screen. If any errors was returned, show a dialog with its text and quit the app

    _artService.loadCustomArts().then((value) => null)

    var router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'PicArtsso',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.dark(),
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF636363),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      routerConfig: router,
    );
  }
}
