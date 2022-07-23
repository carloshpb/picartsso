import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain_provider_module.dart' as domain_provider_module;
import '../../domain/models/style_image.dart';
import '../../domain/use_cases/get_arts_use_case.dart';
import '../../domain/use_cases/get_chosen_pic_use_case.dart';
import '../../domain/use_cases/get_transformed_images_use_case.dart';
import '../../domain/use_cases/pick_new_custom_art_use_case.dart';
import '../../domain/use_cases/save_images_gallery_use_case.dart';
import '../../domain/use_cases/transfer_style_use_case.dart';
import 'state/pic_arts_state.dart';

final displayPictureViewModelProvider = StateNotifierProvider.autoDispose<
    DisplayPictureViewModel, AsyncValue<void>>(
  (ref) => DisplayPictureViewModel(
    ref.watch(domain_provider_module.getChosenPicUseCase),
    ref.watch(domain_provider_module.saveImagesGalleryUseCase),
    ref.watch(domain_provider_module.getTransformedImagesUseCase),
    ref.watch(domain_provider_module.getArtsUseCase),
    ref.watch(domain_provider_module.transferStyleUseCase),
    ref.watch(domain_provider_module.pickNewCustomArtUseCase),
  ),
);

class DisplayPictureViewModel extends StateNotifier<AsyncValue<PicArtsState>> {
  final GetChosenPicUseCase _getChosenPicUseCase;
  final SaveImagesGalleryUseCase _saveImagesGalleryUseCase;
  final GetTransformedImagesUseCase _getTransformedImagesUseCase;
  final GetArtsUseCase _getArtsUseCase;
  final TransferStyleUseCase _transferStyleUseCase;
  final PickNewCustomArtUseCase _pickNewCustomArtUseCase;

  late Uint8List _chosenPic;
  late Map<String, Uint8List> _transformedPics;
  late List<StyleImage> _arts;

  DisplayPictureViewModel(
    this._getChosenPicUseCase,
    this._saveImagesGalleryUseCase,
    this._getTransformedImagesUseCase,
    this._getArtsUseCase,
    this._transferStyleUseCase,
    this._pickNewCustomArtUseCase,
  ) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    //state = const AsyncValue.loading();
    _arts = _getArtsUseCase.execute();
    _chosenPic = _getChosenPicUseCase.execute();

    // state = await AsyncValue.guard<PicArtsState>(() async {
    //   return PicArtsState(
    //     arts: listArts,
    //     displayPicture: chosenPic,
    //     imageDataType: imageDataType,
    //   );
    // });

    state = AsyncValue.data(
      PicArtsState(
        arts: _arts,
        displayPicture: _chosenPic,
        imageDataType: 'float16',
        isTransferedStyleToImage: false,
      ),
    );
  }

  Future<String?> saveImageInGallery() async {
    var oldStateValue = state.value!;
    state = const AsyncValue.loading();
    try {
      var transformedImagesMap = _getTransformedImagesUseCase.execute();
      if (transformedImagesMap.containsKey('float16') &&
          transformedImagesMap.containsKey('int8') &&
          transformedImagesMap['float16'] != null &&
          transformedImagesMap['float16']!.isNotEmpty &&
          transformedImagesMap['int8'] != null &&
          transformedImagesMap['int8']!.isNotEmpty) {
        _saveImagesGalleryUseCase.execute(transformedImagesMap);
        state = AsyncValue.data(oldStateValue);
      } else {
        state = AsyncValue.data(oldStateValue);
        return 'Não há nenhuma foto / imagem transformada para salvar.';
      }
    } on Exception catch (e) {
      state = AsyncValue.data(oldStateValue);
      return e.toString();
    }
    state = AsyncValue.data(oldStateValue);
  }

  Map<String, Uint8List>? getTransformedPics() {
    try {
      var transformedImagesMap = _getTransformedImagesUseCase.execute();
      if (transformedImagesMap.containsKey('float16') &&
          transformedImagesMap.containsKey('int8') &&
          transformedImagesMap['float16'] != null &&
          transformedImagesMap['float16']!.isNotEmpty &&
          transformedImagesMap['int8'] != null &&
          transformedImagesMap['int8']!.isNotEmpty) {
        return transformedImagesMap;
      }
      return null;
    } on Exception {
      return null;
    }
  }

  Uint8List getChosenPic() {
    return _chosenPic;
  }

  // Uint8List? getSelectedTransformedPic() {
  //   var transf = getTransformedPics();
  //   if (transf != null && state.value != null) {
  //     return transf[state.value];
  //   }
  //   return null;
  // }

  void selectSpecificBinaryType(String type) {
    var oldState = state.value!;
    if (oldState.isTransferedStyleToImage) {
      state = AsyncValue.data(
        PicArtsState(
          arts: oldState.arts,
          displayPicture: _transformedPics[type]!,
          imageDataType: type,
          isTransferedStyleToImage: oldState.isTransferedStyleToImage,
        ),
      );
    }
  }

  List<StyleImage> getListOfArts() {
    var list = _getArtsUseCase.execute();
    return list;
  }

  Future<String?> transferStyle(Uint8List styleArt) async {
    var oldState = state.value!;
    state = const AsyncValue.loading();

    try {
      _transformedPics =
          await _transferStyleUseCase.execute(getChosenPic(), styleArt);

      if (_transformedPics.containsKey('float16') &&
          _transformedPics.containsKey('int8') &&
          _transformedPics['float16'] != null &&
          _transformedPics['float16']!.isNotEmpty &&
          _transformedPics['int8'] != null &&
          _transformedPics['int8']!.isNotEmpty) {
        state = AsyncValue.data(
          PicArtsState(
            arts: oldState.arts,
            displayPicture: _transformedPics[oldState.imageDataType]!,
            imageDataType: oldState.imageDataType,
          ),
        );
        return null;
      } else {
        state = AsyncValue.data(oldState);
        return "Não ocorreu a transferência de estilo da imagem. Tente novamente.";
      }
    } on Exception catch (e) {
      state = AsyncValue.data(oldState);
      return e.toString();
    }
  }

  Future<void> pickNewCustomArt() async {
    var oldStateValue = state.value!;
    state = const AsyncValue.loading();
    try {
      var newArtsList = await _pickNewCustomArtUseCase.execute();
      state = AsyncValue.data(
        PicArtsState(
          arts: newArtsList,
          displayPicture: oldStateValue.displayPicture,
          imageDataType: oldStateValue.imageDataType,
        ),
      );
    } on Exception {
      state = AsyncValue.data(oldStateValue);
    }

    //selectSpecificBinaryType(oldStateValue!);
  }
}
