import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/app_router.dart';
import '../../controllers/transfer_style_controller.dart';

class FullSizePicScreen extends ConsumerWidget {
  const FullSizePicScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var route = ref.watch(goRouterProvider);

    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            route.pop();
          },
          child: Hero(
            tag: 'image',
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.memory(
                  ref
                      .watch(transferStyleControllerProvider)
                      .value!
                      .displayPicture,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
