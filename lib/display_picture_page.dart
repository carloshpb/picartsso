// A widget that displays the picture taken by the user.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:picartsso/services/image_transfer_service.dart';

import 'constants/style_images_constants.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;
  final ValueNotifier<String> transformedImagePath = ValueNotifier('');
  final ValueNotifier<Uint8List?> transformedImage = ValueNotifier(null);

  DisplayPicturePage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    // Preparing Servide
    var _imageTransferService = ImageTransferService();
    _imageTransferService.loadModel();

    Uint8List? pictureData;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Quer descartar a imagem modificada?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), //<-- SEE HERE
                    child: const Text('Não'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(true), // <-- SEE HERE
                    child: const Text('Sim'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Display the Picture'),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.save_outlined,
              ),
              tooltip: 'Salvar imagem',
              onPressed: () async {
                //SAVE IMAGE IN GALLERY
                if (transformedImage.value != null) {
                  await ImageGallerySaver.saveImage(
                    transformedImage.value!,
                    quality: 60,
                    name: "transformedImage${DateTime.now().toIso8601String()}",
                  );
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SafeArea(
          child: FutureBuilder(
              future: Future.wait<void>([
                _imageTransferService.loadModel(),
                _imageTransferService
                    .loadImagePath(imagePath)
                    .then((result) => pictureData = result),
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ValueListenableBuilder<String>(
                            valueListenable: transformedImagePath,
                            builder: (context, transformedImagePath, _) {
                              return (transformedImagePath.isEmpty)
                                  ? Image.file(
                                      File(imagePath),
                                    )
                                  : Image.file(
                                      File(transformedImagePath),
                                    );
                            }),
                      ),
                      Positioned(
                        bottom: 10.0,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) => GestureDetector(
                            onTap: () async {
                              var chosenStyleData = await _imageTransferService
                                  .loadImagePath(StyleImageConstants
                                      .listStyleImages[index].path);
                              transformedImage.value =
                                  await _imageTransferService.transfer(
                                      pictureData!, chosenStyleData);
                              if (transformedImage.value != null) {
                                var file =
                                    File.fromRawPath(transformedImage.value!);
                                transformedImagePath.value = file.path;
                              } else {
                                //TODO : Tratar erro caso transferencia não tenha funcionado
                              }
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    StyleImageConstants
                                        .listStyleImages[index].path,
                                  ),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  StyleImageConstants
                                      .listStyleImages[index].artName,
                                  style: TextStyle(
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (ctx, _) => const SizedBox(
                            width: 20.0,
                          ),
                          itemCount: StyleImageConstants.listStyleImages.length,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
