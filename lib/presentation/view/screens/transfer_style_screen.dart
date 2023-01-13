import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../router/app_router.dart';
import '../../controllers/transfer_style_controller.dart';
import '../widgets/animations/hero_picture.dart';
//import 'full_size_pic_screen.dart';

class TransferStyleScreen extends ConsumerStatefulWidget {
  const TransferStyleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransferStyleScreenState();
}

class _TransferStyleScreenState extends ConsumerState<TransferStyleScreen> {
  @override
  Widget build(BuildContext context) {
    var router = ref.watch(goRouterProvider);
    //final navigatorForDialogs = Navigator.of(context);

    final currentState = ref.watch(transferStyleControllerProvider);
    final transferStyleController =
        ref.watch(transferStyleControllerProvider.notifier);

    ref.listen<AsyncValue>(
      transferStyleControllerProvider,
      (_, state) async {
        if (state.isLoading || state.isReloading) {
          //print("MOSTRA LOADER OVERLAY");
          //context.loaderOverlay.show();
          if (!Loader.isShown) {
            Loader.show(
              context,
              progressIndicator: const CircularProgressIndicator.adaptive(),
            );
          }
        } else if (state.hasError) {
          if (Loader.isShown) {
            Loader.hide();
          }
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Erro',
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              content: Text(
                state.error.toString(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // TODO : Tratar erro
                    Loader.hide();
                    router.pop();
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          //print("ESCONDE LOADER OVERLAY");
          //context.loaderOverlay.hide();
          Loader.hide();
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        if (currentState.hasValue && currentState.value!.isSaved) {
          return true;
        }
        bool wantToDiscard = true;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Você tem certeza?',
              style: TextStyle(
                fontFamily: 'Roboto',
              ),
            ),
            content: const Text(
              'Quer descartar a imagem modificada?',
              style: TextStyle(
                fontFamily: 'Roboto',
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  wantToDiscard = false;
                  router.pop();
                }, //<-- SEE HERE
                child: const Text(
                  'Não',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  wantToDiscard = true;
                  router.pop();
                },
                child: const Text(
                  'Sim',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ],
          ),
        );
        return wantToDiscard;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 27, 29, 1),
          elevation: 0.0,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          // title: const FittedBox(
          //   child: Text(
          //     'Transferência de Estilo',
          //     style: TextStyle(
          //       fontFamily: 'Roboto',
          //     ),
          //   ),
          // ),
          actions: [
            TextButton(
              onPressed: (!currentState.hasError &&
                      currentState.hasValue &&
                      currentState.value!.isTransferedStyleToImage &&
                      currentState.value!.imageDataType != 'float16')
                  ? () {
                      transferStyleController
                          .selectSpecificBinaryType('float16');
                    }
                  : null,
              child: const Text(
                "Float16",
                style: TextStyle(
                  fontFamily: 'EBGaramond',
                ),
              ),
            ),
            TextButton(
              onPressed: (currentState.hasValue &&
                      currentState.value!.isTransferedStyleToImage &&
                      currentState.value!.imageDataType != 'int8')
                  ? () {
                      transferStyleController.selectSpecificBinaryType('int8');
                    }
                  : null,
              child: const Text(
                "Int8",
                style: TextStyle(
                  fontFamily: 'EBGaramond',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.save_outlined,
              ),
              tooltip: 'Salvar imagem',
              onPressed: (currentState.hasValue &&
                      currentState.value!.isTransferedStyleToImage &&
                      !currentState.value!.isSaved)
                  ? () async {
                      await transferStyleController.saveImageInGallery();

                      final state = ref.read(transferStyleControllerProvider);

                      if (state.hasValue && state.value!.isSaved) {
                        var snackBar = const SnackBar(
                          content: Text(
                            'Imagens transformadas salvas!',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                            ),
                          ),
                        );
                        //! Special condition to check if widget is mounted to avoid unknown errors
                        //! Should be used before every .of(context) that is used inside an async method in a State
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      // if (result != null) {
                      //   return await showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       title: const Text(
                      //         'Atenção',
                      //         style: TextStyle(
                      //           fontFamily: 'Roboto',
                      //         ),
                      //       ),
                      //       content: Text(
                      //         result,
                      //         style: const TextStyle(
                      //           fontFamily: 'Roboto',
                      //         ),
                      //       ),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () =>
                      //               navigatorForDialogs.pop(), //<-- SEE HERE
                      //           child: const Text(
                      //             'Ok',
                      //             style: TextStyle(
                      //               fontFamily: 'Roboto',
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // } else {
                      //   var snackBar = const SnackBar(
                      //     content: Text(
                      //       'Imagens transformadas salvas!',
                      //       style: TextStyle(
                      //         fontFamily: 'Roboto',
                      //       ),
                      //     ),
                      //   );
                      //   //! Special condition to check if widget is mounted to avoid unknown errors
                      //   //! Should be used before every .of(context) that is used inside an async method in a State
                      //   if (!mounted) return;
                      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      // }
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
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return (currentState.hasValue)
                        ? HeroPicture(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext innerContext) {
                                    return Scaffold(
                                      body: HeroPicture(
                                        onTap: () {
                                          Navigator.of(innerContext).pop();
                                        },
                                        picture:
                                            currentState.value!.displayPicture,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            picture: currentState.value!.displayPicture,
                          )
                        : (!currentState.isReloading && currentState.hasError)
                            ? SizedBox(
                                height: constraints.maxHeight,
                                width: constraints.maxWidth,
                                child: const FittedBox(
                                  child: Text(
                                    "ERROR - NO PREVIOUS IMAGE",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                    //         Stack(
                    //   children: [

                    //     Positioned(
                    //       top: constraints.maxHeight / 2,
                    //       left: constraints.maxWidth / 2,
                    //       child: const Align(
                    //         alignment: Alignment.center,
                    //         child: CircularProgressIndicator(),
                    //       ),
                    //     ),

                    //     if (!currentState.hasValue && !currentState.isLoading)
                    //       const Positioned.fill(
                    //         child: SizedBox(
                    //           child: FittedBox(
                    //             child: Text(
                    //               "ERROR - NO PREVIOUS IMAGE",
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontFamily: 'Poppins',
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),

                    //     if (currentState.hasValue)
                    //       Positioned.fill(
                    //         child: HeroPicture(
                    //           onTap: () {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute<void>(
                    //                 builder: (BuildContext context) {
                    //                   return HeroPicture(
                    //                     onTap: () {
                    //                       Navigator.of(context).pop();
                    //                     },
                    //                     picture:
                    //                         currentState.value!.displayPicture,
                    //                   );
                    //                 },
                    //               ),
                    //             );
                    //           },
                    //           picture: currentState.value!.displayPicture,
                    //         ),
                    //       ),
                    //     // Align(
                    //     //   alignment: Alignment.topCenter,
                    //     //   child: Container(
                    //     //     height: constraints.maxHeight * 0.06,
                    //     //     width: constraints.maxWidth,
                    //     //     decoration: BoxDecoration(
                    //     //       gradient: LinearGradient(
                    //     //         begin: const Alignment(0.0, -1),
                    //     //         end: const Alignment(0.0, 0.2),
                    //     //         colors: <Color>[
                    //     //           const Color.fromRGBO(25, 27, 29, 1),
                    //     //           Colors.black12.withOpacity(0.0)
                    //     //         ],
                    //     //       ),
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     // Align(
                    //     //   alignment: Alignment.bottomCenter,
                    //     //   child: Container(
                    //     //     height: constraints.maxHeight * 0.06,
                    //     //     width: constraints.maxWidth,
                    //     //     decoration: BoxDecoration(
                    //     //       gradient: LinearGradient(
                    //     //         begin: const Alignment(0.0, 0.8),
                    //     //         end: const Alignment(0.0, -1),
                    //     //         colors: <Color>[
                    //     //           const Color.fromRGBO(25, 27, 29, 1),
                    //     //           Colors.black12.withOpacity(0.0)
                    //     //         ],
                    //     //       ),
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: (currentState.hasValue)
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => (index !=
                                currentState.value!.arts.length)
                            ? GestureDetector(
                                onTap: () async {
                                  await transferStyleController.transferStyle(
                                    currentState.value!.arts[index].image,
                                  );

                                  final state =
                                      ref.read(transferStyleControllerProvider);

                                  if (state.hasValue && state.value!.isSaved) {
                                    var snackBar = const SnackBar(
                                      content: Text(
                                        'Imagens transformadas salvas!',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    );
                                    //! Special condition to check if widget is mounted to avoid unknown errors
                                    //! Should be used before every .of(context) that is used inside an async method in a State
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }

                                  // if (result != null) {
                                  //   return await showDialog(
                                  //     context: context,
                                  //     builder: (context) => AlertDialog(
                                  //       title: const Text(
                                  //         'Atenção',
                                  //         style: TextStyle(
                                  //           fontFamily: 'Roboto',
                                  //         ),
                                  //       ),
                                  //       content: Text(
                                  //         result,
                                  //         style: const TextStyle(
                                  //           fontFamily: 'Roboto',
                                  //         ),
                                  //       ),
                                  //       actions: <Widget>[
                                  //         TextButton(
                                  //           onPressed: () =>
                                  //               navigatorForDialogs.pop(),
                                  //           child: const Text(
                                  //             'Ok',
                                  //             style: TextStyle(
                                  //               fontFamily: 'Roboto',
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   );
                                  // }
                                },
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.red.shade400,
                                    // ),
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
                                            child: Image.memory(
                                              currentState
                                                  .value!.arts[index].image,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: transferStyleController.addNewCustomArt,
                                child: Container(
                                  height: 100.0,
                                  width: 100.0,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    // border: Border.all(
                                    //   color: Colors.red.shade800,
                                    // ),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                        separatorBuilder: (ctx, _) => const SizedBox(
                          width: 20.0,
                        ),
                        // itemCount:
                        //     StyleImageConstants.listStyleImages.length,
                        itemCount: currentState.value!.arts.length + 1,
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
