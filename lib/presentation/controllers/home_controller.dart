import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/services/art_service.dart';
import '../../domain/services/impl/art_service_impl.dart';
import '../../domain/services/impl/picture_image_service_impl.dart';
import '../../domain/services/impl/transfer_style_service_impl.dart';
import '../../domain/services/picture_image_service.dart';
import '../../domain/services/transfer_style_service.dart';

final isInitialDataLoaded = StateProvider<bool>(
  (_) => false,
);

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeController, AsyncValue<void>>(
  (ref) => HomeController(
    // ref.watch(domain_provider_module.pickImageUseCase),
    // ref.watch(domain_provider_module.loadInitialDataUseCase),
    // ref.watch(domain_provider_module.getChosenPicUseCase),
    ref.watch(artService),
    ref.watch(transferStyleService),
    ref.watch(pictureImageService),
    ref,
  ),
);

class HomeController extends StateNotifier<AsyncValue<void>> {
  //final BootstrapAuthenticationUseCase _bootstrapAuthenticationUseCase;

  // final PickImageUseCase _pickImageUseCase;
  // final LoadInitialDataUseCase _loadInitialDataUseCase;
  // final GetChosenPicUseCase _getChosenPicUseCase;

  final ArtService _artService;
  final TransferStyleService _transferStyleService;
  final PictureImageService _pictureImageService;
  final Ref _ref;

  HomeController(
    // this._pickImageUseCase,
    // this._loadInitialDataUseCase,
    // this._getChosenPicUseCase,
    this._artService,
    this._transferStyleService,
    this._pictureImageService,
    this._ref,
  ) : super(const AsyncValue.loading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final isLoaded = _ref.read(isInitialDataLoaded);
    if (!isLoaded) {
      state = await AsyncValue.guard<void>(
        () async {
          final loadDefaultImages = await _artService.loadDefaultImages();
          if (loadDefaultImages.isError()) {
            state = AsyncValue.error(
              loadDefaultImages.getError()!,
              StackTrace.current,
            );
            return;
          }
          final loadCustomArts = await _artService.loadCustomArts();
          if (loadCustomArts.isError()) {
            state = AsyncValue.error(
              loadCustomArts.getError()!,
              StackTrace.current,
            );
            return;
          }

          final loadAIModels = await _transferStyleService.loadModel();
          if (loadAIModels.isError()) {
            state = AsyncValue.error(
              loadAIModels.getError()!,
              StackTrace.current,
            );
            return;
          }

          _ref.read(isInitialDataLoaded.notifier).state = true;
        },
      );
    }
  }

  Future<String?> pickImageFromGallery() async {
    final pickedImage =
        await _pictureImageService.pickImageFromSource(ImageSource.gallery);
    return pickedImage.when(
      (error) => error.when(
        general: (message) => message,
        // TODO : Treat denied permission situation
        permission: (message) => message,
      ),
      (success) {
        _pictureImageService.chosenPic = success;
        return null;
      },
    );
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
