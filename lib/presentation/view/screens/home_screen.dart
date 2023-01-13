import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:picartsso/exceptions/app_exception.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/home_controller.dart';

class HomeScreen extends ConsumerWidget {
  //final ImagePicker _picker = ImagePicker();
  //final CameraDescription camera;

  final String _tensorFlowLiteUri =
      'https://www.tensorflow.org/lite/examples/style_transfer/overview';

  const HomeScreen({
    Key? key,
    //required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = Uri.parse(_tensorFlowLiteUri);
    final mediaQuery = MediaQuery.of(context);
    final router = GoRouter.of(context);
    // final navigatorForDialogs = Navigator.of(context);

    // final homeState = ref.watch(homeControllerProvider);
    final homeController = ref.watch(homeControllerProvider.notifier);

    // Listener do deal with Error and Loading
    ref.listen<AsyncValue>(
      homeControllerProvider,
      (_, state) async {
        if (state.hasError) {
          if (Loader.isShown) {
            Loader.hide();
          }

          var isAppException = state.error is AppException;
          String title = (isAppException)
              ? (state.error as AppException).maybeWhen(
                  general: (message) => "Erro!",
                  orElse: () => "Atenção!",
                )
              : "Erro!";

          String body = (isAppException)
              ? (state.error as AppException).message()
              : "${state.error.toString()} -- ${state.asError!.stackTrace}";

          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              content: Text(
                body,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              actions: <Widget>[
                if (state.error is PermissionFailure)
                  TextButton(
                    onPressed: () async {
                      await openAppSettings();
                      router.pop();
                    },
                    child: const Text(
                      'Mudar permissão',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: (isAppException)
                      ? (state.error as AppException).maybeWhen(
                          general: (message) {
                            return () {
                              // TODO : Tratar erro
                              // temporary splash remove
                              FlutterNativeSplash.remove();
                              //navigatorForDialogs.pop();
                              router.pop();
                            };
                          },
                          orElse: () {
                            return () => router.pop();
                          },
                        )
                      : () {
                          // TODO : Tratar erro
                          // temporary splash remove
                          FlutterNativeSplash.remove();
                          //navigatorForDialogs.pop();
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
        } else if (state.isLoading) {
          Loader.show(
            context,
            progressIndicator: const CircularProgressIndicator.adaptive(),
          );
        } else {
          Loader.hide();
          FlutterNativeSplash.remove();
        }
      },
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        actions: [
          TextButton(
            onPressed: () async => await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: SizedBox(
                  height: mediaQuery.size.height * 0.1,
                  width: mediaQuery.size.width * 0.9,
                  child: const FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "PicArtsso",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Jonathan",
                        fontSize: 100.0,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                content: SizedBox(
                  width: mediaQuery.size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AutoSizeText(
                        "Aplicativo criado para fazer Transferência de Estilo utilizando o TensorFlow Lite e seus modelos prontos de predição e transferência",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'EBGaramond',
                          fontSize: 40.0,
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () async {
                          if (!await launchUrl(url)) {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Atenção',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                content: Text(
                                  'Não foi possível abrir o endereço $_tensorFlowLiteUri',
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => context.pop(),
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
                          }
                        },
                        child: const AutoSizeText(
                          "Website do TensorFlow Lite",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 30.0,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Ok',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: const Text(
              "Sobre o App",
              style: TextStyle(
                fontFamily: "Oswald",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background/background2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: mediaQuery.size.height,
                width: mediaQuery.size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: const Alignment(0.0, -1),
                    begin: const Alignment(0.0, 0.4),
                    colors: <Color>[
                      const Color.fromRGBO(25, 27, 29, 1),
                      Colors.black12.withOpacity(0.0)
                    ],
                  ),
                ),
              ),
            ),
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AutoSizeText(
                      "PicArtsso",
                      style: TextStyle(
                        fontFamily: "Jonathan",
                        fontSize: 100.0,
                      ),
                    ),
                    const Spacer(),
                    const Flexible(
                      child: AutoSizeText(
                        "Aplique efeitos de artes ou de qualquer imagem de sua escolha nas fotos desejadas por você!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 30.0,
                        ),
                        maxLines: 3,
                      ),
                      // child: Stack(
                      //   children: [
                      //     AutoSizeText(
                      //       "Aplique efeitos de artes ou de qualquer imagem de sua escolha nas fotos desejadas por você!",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         fontFamily: 'Poppins',
                      //         fontSize: 30.0,
                      //         foreground: Paint()
                      //           ..style = PaintingStyle.stroke
                      //           ..strokeWidth = 4
                      //           ..color = Colors.black87,
                      //       ),
                      //       maxLines: 3,
                      //     ),
                      //     const AutoSizeText(
                      //       "Aplique efeitos de artes ou de qualquer imagem de sua escolha nas fotos desejadas por você!",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontFamily: 'Poppins',
                      //         fontSize: 30.0,
                      //       ),
                      //       maxLines: 3,
                      //     ),
                      //   ],
                      // ),
                    ),
                    // Pick with Camera
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-1.0, 1.0),
                          end: Alignment(1.0, -1.0),
                          colors: <Color>[
                            Color.fromRGBO(1, 173, 237, 1),
                            Color.fromRGBO(254, 65, 34, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          // Loader.show(
                          //   context,
                          //   progressIndicator:
                          //       const CircularProgressIndicator.adaptive(),
                          // );
                          await homeController
                              .pickImageFromSource(ImageSource.camera);

                          if (Loader.isShown) {
                            Loader.hide();
                          }

                          ref.read(homeControllerProvider).maybeWhen(
                                error: (error, stackTrace) => null,
                                orElse: () => router.push('/pick'),
                              );

                          // if (!homeState.hasError && homeState.) {
                          //   router.push('/pick');
                          // }
                          // Loader.hide();
                          // if (result == null) {
                          //   router.push('/pick');
                          // } else {
                          //   late final void Function() alertButtonFunction;
                          //   late final String alertMessage;
                          //   result.maybeWhen(
                          //     noPic: () {
                          //       return;
                          //     },
                          //     orElse: () async {
                          //       alertMessage = result.message();
                          //       alertButtonFunction = () => router.pop();
                          //     },
                          //   );
                          //   await showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: const Text(
                          //         'Atenção',
                          //         style: TextStyle(
                          //           fontFamily: 'Roboto',
                          //         ),
                          //       ),
                          //       content: Text(
                          //         alertMessage,
                          //         style: const TextStyle(
                          //           fontFamily: 'Roboto',
                          //         ),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: alertButtonFunction,
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
                        // style: ElevatedButton.styleFrom(
                        //   backgroundColor: const Color.fromARGB(255, 228, 66, 17),
                        // ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Tirar Foto",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontFamily: 'Oswald',
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                    const AutoSizeText(
                      "OU",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(-1.0, 1.0),
                          end: Alignment(1.0, -1.0),
                          colors: <Color>[
                            Color.fromRGBO(1, 173, 237, 1),
                            Color.fromRGBO(254, 65, 34, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          // Loader.show(
                          //   context,
                          //   progressIndicator:
                          //       const CircularProgressIndicator.adaptive(),
                          // );
                          await homeController
                              .pickImageFromSource(ImageSource.gallery);
                          // Loader.hide();

                          if (Loader.isShown) {
                            Loader.hide();
                          }

                          ref.read(homeControllerProvider).maybeWhen(
                                error: (error, stackTrace) => null,
                                orElse: () => router.push('/pick'),
                              );

                          // if (result == null) {
                          //   router.push('/pick');
                          // } else {
                          //   late final void Function() alertButtonFunction;
                          //   late final String alertMessage;
                          //   result.when(
                          //     general: (String message) async {
                          //       alertButtonFunction = () {
                          //         return;
                          //       };
                          //       alertMessage = message;
                          //     },
                          //     noPic: () {
                          //       return;
                          //     },
                          //     permission: (_) async {
                          //       alertMessage =
                          //           "O aplicativo não tem permissão para acessar a galeria. Tente novamente e conceda permissão para acessar, caso queira.";
                          //       alertButtonFunction = () => router.pop();
                          //     },
                          //   );
                          //   await showDialog(
                          //     context: context,
                          //     builder: (context) => AlertDialog(
                          //       title: const Text(
                          //         'Atenção',
                          //         style: TextStyle(
                          //           fontFamily: 'Roboto',
                          //         ),
                          //       ),
                          //       content: Text(
                          //         alertMessage,
                          //         style: const TextStyle(
                          //           fontFamily: 'Roboto',
                          //         ),
                          //       ),
                          //       actions: <Widget>[
                          //         TextButton(
                          //           onPressed: alertButtonFunction,
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
                        // style: ElevatedButton.styleFrom(
                        //   primary: const Color.fromARGB(255, 228, 66, 17),
                        // ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Escolher Foto da Galeria",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Oswald',
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
