import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data_provider_module.dart' as data_provider_module;
import '../../../data/router/app_router.dart';
import '../../view_model/transfer_style_view_model.dart'
    as transfer_style_view_model;

class TransferStyleScreen extends ConsumerStatefulWidget {
  const TransferStyleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferStyleScreenState();
}

class _TransferStyleScreenState extends ConsumerState<TransferStyleScreen> {
  @override
  Widget build(BuildContext context) {
    var route = ref.watch(data_provider_module.autoRouterProvider);

    ref.listen<AsyncValue>(
      transfer_style_view_model.provider,
      (_, state) {
        if (state.isLoading) {
          print("MOSTRA LOADER OVERLAY");
          //context.loaderOverlay.show();
          Loader.show(context,
              progressIndicator: const CircularProgressIndicator());
        } else {
          print("ESCONDE LOADER OVERLAY");
          //context.loaderOverlay.hide();
          Loader.hide();
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        if (ref.watch(transfer_style_view_model.provider).hasValue &&
            ref.watch(transfer_style_view_model.provider).value!.isSaved) {
          return true;
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
              onPressed: (ref
                          .watch(transfer_style_view_model.provider)
                          .hasValue &&
                      ref
                          .watch(transfer_style_view_model.provider)
                          .value!
                          .isTransferedStyleToImage &&
                      ref
                              .watch(transfer_style_view_model.provider)
                              .value!
                              .imageDataType !=
                          'float16')
                  ? () {
                      ref
                          .watch(transfer_style_view_model.provider.notifier)
                          .selectSpecificBinaryType('float16');
                    }
                  : null,
              child: const Text("Float16"),
            ),
            TextButton(
              onPressed: (ref
                          .watch(transfer_style_view_model.provider)
                          .hasValue &&
                      ref
                          .watch(transfer_style_view_model.provider)
                          .value!
                          .isTransferedStyleToImage &&
                      ref
                              .watch(transfer_style_view_model.provider)
                              .value!
                              .imageDataType !=
                          'int8')
                  ? () {
                      ref
                          .watch(transfer_style_view_model.provider.notifier)
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
              onPressed: (ref
                          .watch(transfer_style_view_model.provider)
                          .hasValue &&
                      ref
                          .watch(transfer_style_view_model.provider)
                          .value!
                          .isTransferedStyleToImage &&
                      !ref
                          .watch(transfer_style_view_model.provider)
                          .value!
                          .isSaved)
                  ? () async {
                      var result = await ref
                          .watch(transfer_style_view_model.provider.notifier)
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
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    route.push(const FullSizePicRoute());
                  },
                  child: Hero(
                    tag: 'image',
                    // child: FadeInImage(
                    //   placeholder: MemoryImage(
                    //     ref
                    //         .watch(display_picture_view_model
                    //             .displayPictureViewModelProvider)
                    //         .value!
                    //         .lastPicture,
                    //   ),
                    //   image: MemoryImage(
                    //     ref
                    //         .watch(display_picture_view_model
                    //             .displayPictureViewModelProvider)
                    //         .value!
                    //         .displayPicture,
                    //   ),
                    // ),
                    // child: Image.memory(
                    //   ref
                    //       .watch(transfer_style_view_model.provider)
                    //       .value!
                    //       .displayPicture,
                    //   gaplessPlayback: false,
                    // ),
                    child: Stack(
                      children: [
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Positioned.fill(
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
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: (ref.watch(transfer_style_view_model.provider).hasValue)
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => (index !=
                                ref
                                    .watch(transfer_style_view_model.provider)
                                    .value!
                                    .arts
                                    .length)
                            ? GestureDetector(
                                onTap: () async {
                                  var result = await ref
                                      .watch(transfer_style_view_model
                                          .provider.notifier)
                                      .transferStyle(
                                        ref
                                            .watch(transfer_style_view_model
                                                .provider)
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
                                    borderRadius: BorderRadius.circular(8.0),
                                    // image: DecorationImage(
                                    //   fit: BoxFit.fill,
                                    //   image: MemoryImage(
                                    //     ref
                                    //         .watch(transfer_style_view_model
                                    //             .provider)
                                    //         .value!
                                    //         .arts[index]
                                    //         .image,
                                    //   ),
                                    // ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Stack(
                                      children: [
                                        const Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.memory(ref
                                                .watch(transfer_style_view_model
                                                    .provider)
                                                .value!
                                                .arts[index]
                                                .image),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: ref
                                    .watch(transfer_style_view_model
                                        .provider.notifier)
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
                                .watch(transfer_style_view_model.provider)
                                .value!
                                .arts
                                .length +
                            1,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
