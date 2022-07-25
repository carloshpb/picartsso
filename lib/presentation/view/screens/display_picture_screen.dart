// A widget that displays the picture taken by the user.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../data/data_provider_module.dart';
import '../../view_model/display_picture_view_model.dart';

class DisplayPictureScreen extends ConsumerStatefulWidget {
  // late final XFile image;
  // final ValueNotifier<String> transformedImagePath = ValueNotifier('');
  // final ValueNotifier<Uint8List?> transformedImage = ValueNotifier(null);
  // final List<String> imageStylesPaths = <String>[];

  const DisplayPictureScreen({
    Key? key,
    //required this.image,
  }) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends ConsumerState<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    var route = ref.watch(autoRouterProvider);

    // Preparing Servide
    // var _imageTransferService = ImageTransferService();
    // _imageTransferService.loadModel();

    // for (var i = 0; i <= 25; i++) {
    //   imageStylesPaths.add("assets/style_imgs/style$i.jpg");
    // }

    //Uint8List? pictureData;

    ref.listen<AsyncValue>(
      displayPictureViewModelProvider,
      (_, state) {
        if (state.isLoading) {
          print("MOSTRA LOADER OVERLAY");
          context.loaderOverlay.show();
        } else {
          print("ESCONDE LOADER OVERLAY");
          context.loaderOverlay.hide();
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        if (ref.watch(displayPictureViewModelProvider).hasValue &&
            ref.watch(displayPictureViewModelProvider).value!.isSaved) {
          return route.pop(true);
        }
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Você tem certeza?'),
                content: const Text('Quer descartar a imagem modificada?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => route.pop(false), //<-- SEE HERE
                    child: const Text('Não'),
                  ),
                  TextButton(
                    onPressed: () => route.pop(true), // <-- SEE HERE
                    child: const Text('Sim'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mostrar a foto'),
          actions: [
            TextButton(
              onPressed: (ref.watch(displayPictureViewModelProvider).hasValue &&
                      ref
                          .watch(displayPictureViewModelProvider)
                          .value!
                          .isTransferedStyleToImage &&
                      ref
                              .watch(displayPictureViewModelProvider)
                              .value!
                              .imageDataType !=
                          'float16')
                  ? () {
                      ref
                          .watch(displayPictureViewModelProvider.notifier)
                          .selectSpecificBinaryType('float16');
                    }
                  : null,
              child: const Text("Float16"),
            ),
            TextButton(
              onPressed: (ref.watch(displayPictureViewModelProvider).hasValue &&
                      ref
                          .watch(displayPictureViewModelProvider)
                          .value!
                          .isTransferedStyleToImage &&
                      ref
                              .watch(displayPictureViewModelProvider)
                              .value!
                              .imageDataType !=
                          'int8')
                  ? () {
                      ref
                          .watch(displayPictureViewModelProvider.notifier)
                          .selectSpecificBinaryType('int8');
                    }
                  : null,
              child: const Text("Int8"),
            ),
            IconButton(
              icon: const Icon(
                Icons.save_outlined,
              ),
              tooltip: 'Salvar imagem',
              onPressed: (ref.watch(displayPictureViewModelProvider).hasValue &&
                      ref
                          .watch(displayPictureViewModelProvider)
                          .value!
                          .isTransferedStyleToImage &&
                      !ref
                          .watch(displayPictureViewModelProvider)
                          .value!
                          .isSaved)
                  ? () async {
                      var result = await ref
                          .watch(displayPictureViewModelProvider.notifier)
                          .saveImageInGallery();
                      if (result != null) {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Atenção!'),
                            content: Text(result),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => route.pop(), //<-- SEE HERE
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Imagens transformadas salvas!'),
                        );
                        //! Special condition to check if widget is mounted to avoid unknown errors
                        //! Should be used before every .of(context) that is used inside an async method
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  : null,
            ),
          ],
        ),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: SafeArea(
          child: Stack(
            children: [
              // Positioned.fill(
              //   child: (ref
              //         .watch(displayPictureViewModelProvider).hasError) ? Image.memory(
              //     ref
              //         .watch(displayPictureViewModelProvider)
              //         .value!
              //         .displayPicture,
              //   ) : Image.memory(kTransparentImage),
              // ),
              Positioned.fill(
                child: FadeInImage(
                  placeholder: MemoryImage(ref
                      .watch(displayPictureViewModelProvider)
                      .value!
                      .lastPicture),
                  image: MemoryImage(ref
                      .watch(displayPictureViewModelProvider)
                      .value!
                      .displayPicture),
                ),
              ),
              Positioned(
                bottom: 10.0,
                left: 10.0,
                right: 10.0,
                child: Container(
                  color: Colors.black,
                  height: 100.0,
                  child: (ref.watch(displayPictureViewModelProvider).hasValue)
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) => (index !=
                                  ref
                                      .watch(displayPictureViewModelProvider)
                                      .value!
                                      .arts
                                      .length)
                              ? GestureDetector(
                                  onTap: () async {
                                    var result = await ref
                                        .watch(displayPictureViewModelProvider
                                            .notifier)
                                        .transferStyle(
                                          ref
                                              .watch(
                                                  displayPictureViewModelProvider)
                                              .value!
                                              .arts[index]
                                              .image,
                                        );
                                    if (result != null) {
                                      return await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Atenção!'),
                                          content: Text(result),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => route.pop(),
                                              child: const Text('Ok'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
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
                                        image: MemoryImage(
                                          ref
                                              .watch(
                                                  displayPictureViewModelProvider)
                                              .value!
                                              .arts[index]
                                              .image,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: ref
                                      .watch(displayPictureViewModelProvider
                                          .notifier)
                                      .pickNewCustomArt,
                                  child: Container(
                                    height: 100.0,
                                    width: 100.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red.shade800,
                                      ),
                                      shape: BoxShape.rectangle,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.red.shade800,
                                    ),
                                  ),
                                ),

                          separatorBuilder: (ctx, _) => const SizedBox(
                            width: 20.0,
                          ),
                          // itemCount:
                          //     StyleImageConstants.listStyleImages.length,
                          itemCount: ref
                                  .watch(displayPictureViewModelProvider)
                                  .value!
                                  .arts
                                  .length +
                              1,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
