import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeController, AsyncValue<void>>(
  (ref) => HomeController(
    ref.watch(domain_provider_module.pickImageUseCase),
    ref.watch(domain_provider_module.loadInitialDataUseCase),
    ref.watch(domain_provider_module.getChosenPicUseCase),
  ),
);

class HomeController extends StateNotifier<AsyncValue<void>> {
  //final BootstrapAuthenticationUseCase _bootstrapAuthenticationUseCase;
  final PickImageUseCase _pickImageUseCase;
  final LoadInitialDataUseCase _loadInitialDataUseCase;
  final GetChosenPicUseCase _getChosenPicUseCase;

  HomeController(
    this._pickImageUseCase,
    this._loadInitialDataUseCase,
    this._getChosenPicUseCase,
  ) : super(const AsyncValue.loading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    state = await AsyncValue.guard<void>(
      () async {
        return await _loadInitialDataUseCase.execute();
      },
    );
  }

  Future<String?> pickImageFromGallery() async {
    try {
      await _pickImageUseCase.execute(ImageSource.gallery);
      // if (_getChosenPicUseCase.execute() == null) {
      //   return "Não foi selecionado nenhuma imagem";
      // }
      return null;
    } on PlatformException catch (e) {
      return "Erro : $e";
    }
  }

  Future<String?> takePictureWithCamera() async {
    try {
      await _pickImageUseCase.execute(ImageSource.camera);
      // if (image == null) {
      //   return "Não foi tirado nenhuma foto";
      // }
      return null;
    } on PlatformException catch (e) {
      return "Erro : $e";
    }
  }
}
