// A widget that displays the picture taken by the user.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:picartsso/services/image_transfer_service.dart';

import 'constants/style_images_constants.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;
  final ValueNotifier<String> transformedImage = ValueNotifier('');

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

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
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
                          valueListenable: transformedImage,
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
                            var result = await _imageTransferService.transfer(
                                pictureData!, chosenStyleData);
                            var file = File.fromRawPath(result);
                            transformedImage.value = file.path;
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
    );
  }
}
