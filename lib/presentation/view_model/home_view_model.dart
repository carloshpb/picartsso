import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/domain_provider_module.dart' as domain_provider_module;

import '../../domain/use_cases/pick_image_use_case.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, AsyncValue<void>>(
  (ref) => HomeViewModel(
    ref.watch(domain_provider_module.pickImageUseCase),
  ),
);

class HomeViewModel extends StateNotifier<AsyncValue<void>> {
  //final BootstrapAuthenticationUseCase _bootstrapAuthenticationUseCase;
  final PickImageUseCase _pickImageUseCase;

  final ImagePicker _picker = ImagePicker();

  HomeViewModel(
    this._pickImageUseCase,
  ) : super(const AsyncValue.loading());

  Future<String?> pickImageFromGallery() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return "Não foi selecionado nenhuma imagem";
      }
      return null;
    } on PlatformException catch (e) {
      return "Erro : $e";
    }
  }

  Future<String?> takePictureWithCamera() async {
    try {
      var image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        return "Não foi tirado nenhuma foto";
      }
      return null;
    } on PlatformException catch (e) {
      return "Erro : $e";
    }
  }
}
