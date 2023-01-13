import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/transfer_style_controller.dart';

class FullSizePicScreen extends ConsumerWidget {
  const FullSizePicScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        //appBar: AppBar(),
        body: Hero(
          tag: 'image',
          child: Material(
            color: Colors.transparent,
            child: InteractiveViewer(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      height: mediaQuery.size.height,
                      width: mediaQuery.size.width,
                      child: FittedBox(
                        fit: BoxFit.contain,
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
            ),
          ),
        ),
      ),
    );
  }
}
