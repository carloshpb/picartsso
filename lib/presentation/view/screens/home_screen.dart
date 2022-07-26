import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/data_provider_module.dart';
import '../../../data/router/app_router.dart';
import '../../view_model/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  //final ImagePicker _picker = ImagePicker();
  //final CameraDescription camera;

  final String _tensorFlowLiteUri =
      'https://www.tensorflow.org/lite/examples/style_transfer/overview';

  HomeScreen({
    Key? key,
    //required this.camera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = Uri.parse(_tensorFlowLiteUri);
    ref.listen<AsyncValue>(
      homeViewModelProvider,
      (_, state) {
        if (state.isLoading) {
          // DO NOTHING
        } else {
          FlutterNativeSplash.remove();
        }
      },
    );

    var router = ref.watch(autoRouterProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("PicArtsso"),
      // ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  child: AutoSizeText(
                    "Bem Vindo ao PicArtsso!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
                const Flexible(
                  child: AutoSizeText(
                    "Aplicativo criado para fazer Transferência de Estilo utilizando o TensorFlow Lite e seus modelos prontos de predição e transferência",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                    maxLines: 3,
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () async {
                      if (!await launchUrl(url)) {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Atenção!'),
                            content: Text(
                                'Não foi possível abrir o endereço $_tensorFlowLiteUri'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => router.pop(),
                                child: const Text('Ok'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: AutoSizeText(
                      _tensorFlowLiteUri,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var result = await ref
                        .watch(homeViewModelProvider.notifier)
                        .takePictureWithCamera();
                    if (result == null) {
                      await router.push(const TransferStyleRoute());
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Aviso !'),
                          content: Text(result),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => router.pop(),
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Tirar Foto",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                      maxLines: 1,
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
                      await router.push(const TransferStyleRoute());
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Aviso !'),
                          content: Text(result),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => router.pop(),
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Escolher Foto da Galeria",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
