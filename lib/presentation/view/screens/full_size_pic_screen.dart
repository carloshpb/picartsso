import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data_provider_module.dart' as data_provider_module;
import '../../view_model/transfer_style_view_model.dart'
    as transfer_style_view_model;

class FullSizePicScreen extends ConsumerWidget {
  const FullSizePicScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var route = ref.watch(data_provider_module.autoRouterProvider);

    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(),
        body: GestureDetector(
          onTap: () {
            route.pop(context);
          },
          child: Hero(
            tag: 'image',
            child: Center(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Image.memory(
                  ref
                      .watch(transfer_style_view_model.provider)
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
