// A widget that displays the picture taken by the user.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:picartsso/services/image_transfer_service.dart';

class DisplayPictureScreen extends ConsumerWidget {
  final XFile image;
  final ValueNotifier<String> transformedImagePath = ValueNotifier('');
  final ValueNotifier<Uint8List?> transformedImage = ValueNotifier(null);
  final List<String> imageStylesPaths = <String>[];

  DisplayPictureScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _mediaQuery = MediaQuery.of(context);
    // Preparing Servide
    var _imageTransferService = ImageTransferService();
    _imageTransferService.loadModel();

    for (var i = 0; i <= 25; i++) {
      imageStylesPaths.add("assets/style_imgs/style$i.jpg");
    }

    //Uint8List? pictureData;

    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Você tem certeza?'),
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
                  //Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SafeArea(
          child: FutureBuilder<void>(
              future: _imageTransferService.loadModel(),
              // future: Future.wait<void>([
              //   _imageTransferService.loadModel(),
              //   _imageTransferService
              //       .loadImagePath(imagePath)
              //       .then((result) => pictureData = result),
              // ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: ValueListenableBuilder<Uint8List?>(
                            valueListenable: transformedImage,
                            builder: (context, transformedImage, _) {
                              return (transformedImage == null)
                                  ? Image.file(
                                      File(image.path),
                                    )
                                  : Image.memory(transformedImage);
                            }),
                      ),
                      Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        right: 10.0,
                        child: Container(
                          color: Colors.black,
                          height: 100.0,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            // physics: const ClampingScrollPhysics(
                            //   parent: AlwaysScrollableScrollPhysics(),
                            // ),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) => GestureDetector(
                              onTap: () async {
                                context.loaderOverlay.show();
                                // var chosenStyleData =
                                //     await _imageTransferService.loadImagePath(
                                //         StyleImageConstants
                                //             .listStyleImages[index].path);
                                var chosenStyleData =
                                    await _imageTransferService.loadImagePath(
                                  imageStylesPaths[index],
                                );
                                var uint8image = await image.readAsBytes();
                                transformedImage.value =
                                    await _imageTransferService.transfer(
                                        uint8image, chosenStyleData);
                                print("TRANSFER COMPLETED");
                                if (transformedImage.value != null) {
                                  //var file = File.fromRawPath(transformedImage.value!);
                                  //transformedImagePath.value = file.path;
                                } else {
                                  //TODO : Tratar erro caso transferencia não tenha funcionado
                                }
                                context.loaderOverlay.hide();
                              },
                              child: Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red.shade400,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0)),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    // image: AssetImage(
                                    //   StyleImageConstants
                                    //       .listStyleImages[index].path,
                                    image: AssetImage(imageStylesPaths[index]),
                                  ),
                                ),
                              ),
                              // child: Align(
                              //   alignment: Alignment.bottomCenter,
                              //   child: Text(
                              //     StyleImageConstants
                              //         .listStyleImages[index].artName,
                              //     style: TextStyle(
                              //       color: Colors.amber.shade800,
                              //     ),
                              //   ),
                              // ),
                            ),

                            separatorBuilder: (ctx, _) => const SizedBox(
                              width: 20.0,
                            ),
                            // itemCount:
                            //     StyleImageConstants.listStyleImages.length,
                            itemCount: imageStylesPaths.length,
                          ),
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
