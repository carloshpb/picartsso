import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../view_model/home_view_model.dart';
import 'display_picture_screen.dart';

class HomeScreen extends ConsumerWidget {
  //final ImagePicker _picker = ImagePicker();
  //final CameraDescription camera;

  HomeScreen({
    Key? key,
    //required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PicArtsso"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                var result = await ref
                    .watch(homeViewModelProvider.notifier)
                    .takePictureWithCamera();
                if (result == null) {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(),
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Aviso !'),
                      content: Text(result),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                "Tirar Foto",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              "OU",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await ref
                    .watch(homeViewModelProvider.notifier)
                    .pickImageFromGallery();
                if (result == null) {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(),
                    ),
                  );
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Aviso !'),
                      content: Text(result),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Ok'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                "Escolher Foto da Galeria",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
