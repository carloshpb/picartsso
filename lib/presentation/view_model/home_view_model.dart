import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/domain_provider_module.dart' as domain_provider_module;

import '../../domain/use_cases/get_chosen_pic_use_case.dart';
import '../../domain/use_cases/load_initial_data_use_case.dart';
import '../../domain/use_cases/pick_image_use_case.dart';

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, AsyncValue<void>>(
  (ref) => HomeViewModel(
    ref.watch(domain_provider_module.pickImageUseCase),
    ref.watch(domain_provider_module.loadInitialDataUseCase),
    ref.watch(domain_provider_module.getChosenPicUseCase),
  ),
);

class HomeViewModel extends StateNotifier<AsyncValue<void>> {
  //final BootstrapAuthenticationUseCase _bootstrapAuthenticationUseCase;
  final PickImageUseCase _pickImageUseCase;
  final LoadInitialDataUseCase _loadInitialDataUseCase;
  final GetChosenPicUseCase _getChosenPicUseCase;

  HomeViewModel(
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
