import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picartsso/exceptions/app_exception.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../domain/services/art_service.dart';
import '../../domain/services/impl/art_service_impl.dart';
import '../../domain/services/impl/picture_image_service_impl.dart';
import '../../domain/services/impl/transfer_style_service_impl.dart';
import '../../domain/services/picture_image_service.dart';
import '../../domain/services/transfer_style_service.dart';
import 'state/pic_arts_state.dart';

final transferStyleControllerProvider = StateNotifierProvider.autoDispose<
    TransferStyleController, AsyncValue<PicArtsState>>(
  (ref) => TransferStyleController(
    // ref.watch(domain_provider_module.getChosenPicUseCase),
    // ref.watch(domain_provider_module.saveImagesGalleryUseCase),
    // ref.watch(domain_provider_module.getTransformedImagesUseCase),
    // ref.watch(domain_provider_module.getArtsUseCase),
    // ref.watch(domain_provider_module.transferStyleUseCase),
    // ref.watch(domain_provider_module.pickNewCustomArtUseCase),
    ref.watch(artService),
    ref.watch(pictureImageService),
    ref.watch(transferStyleService),
  ),
);

class TransferStyleController extends StateNotifier<AsyncValue<PicArtsState>> {
  // final GetChosenPicUseCase _getChosenPicUseCase;
  // final SaveImagesGalleryUseCase _saveImagesGalleryUseCase;
  // final GetTransformedImagesUseCase _getTransformedImagesUseCase;
  // final GetArtsUseCase _getArtsUseCase;
  // final TransferStyleUseCase _transferStyleUseCase;
  // final PickNewCustomArtUseCase _pickNewCustomArtUseCase;

  final ArtService _artService;
  final PictureImageService _pictureImageService;
  final TransferStyleService _transferStyleService;

  // late Uint8List _chosenPic;
  // late Map<String, Uint8List> _transformedPics;
  // late List<StyleImage> _arts;

  TransferStyleController(
    this._artService,
    this._pictureImageService,
    this._transferStyleService,
  ) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    //state = const AsyncValue.loading();
    // _arts = _getArtsUseCase.execute();
    // _chosenPic = _getChosenPicUseCase.execute();

    // state = await AsyncValue.guard<PicArtsState>(() async {
    //   return PicArtsState(
    //     arts: listArts,
    //     displayPicture: chosenPic,
    //     imageDataType: imageDataType,
    //   );
    // });

    _artService.allArtsInOrder.when(
      (successArtsList) {
        state = AsyncValue.data(
          PicArtsState(
            arts: successArtsList,
            lastPicture: kTransparentImage,
            displayPicture: _pictureImageService.chosenPic,
            imageDataType: 'float16',
            isTransferedStyleToImage: false,
            isSaved: false,
          ),
        );
      },
      (error) {
        state = AsyncValue.error(
          error,
          StackTrace.current,
        );
      },
    );
  }

  Future<void> saveImageInGallery() async {
    var oldStateValue = state.value!;
    state = const AsyncValue.loading();

    var transformedImagesMap = _pictureImageService.transformedImages;
    if (transformedImagesMap.containsKey('float16') &&
        transformedImagesMap.containsKey('int8') &&
        transformedImagesMap['float16'] != null &&
        transformedImagesMap['float16']!.isNotEmpty &&
        transformedImagesMap['int8'] != null &&
        transformedImagesMap['int8']!.isNotEmpty) {
      var saveImagesResult = await _pictureImageService
          .saveAllImagesToGallery(transformedImagesMap);
      saveImagesResult.when(
        (success) {
          state = AsyncValue.data(
            PicArtsState(
              arts: oldStateValue.arts,
              lastPicture: oldStateValue.lastPicture,
              displayPicture: oldStateValue.displayPicture,
              imageDataType: oldStateValue.imageDataType,
              isTransferedStyleToImage: oldStateValue.isTransferedStyleToImage,
              isSaved: true,
            ),
          );
        },
        (error) {
          state = AsyncValue.error(
            error,
            StackTrace.current,
          );
        },
      );
    } else {
      state = AsyncError(
        const AppException.general(
            'Não há nenhuma foto / imagem transformada para salvar.'),
        StackTrace.current,
      );
      // state = AsyncValue.data(oldStateValue);
      // return 'Não há nenhuma foto / imagem transformada para salvar.';
    }
  }

  // Map<String, Uint8List>? getTransformedPics() {
  //   try {
  //     var transformedImagesMap = _getTransformedImagesUseCase.execute();
  //     if (transformedImagesMap.containsKey('float16') &&
  //         transformedImagesMap.containsKey('int8') &&
  //         transformedImagesMap['float16'] != null &&
  //         transformedImagesMap['float16']!.isNotEmpty &&
  //         transformedImagesMap['int8'] != null &&
  //         transformedImagesMap['int8']!.isNotEmpty) {
  //       return transformedImagesMap;
  //     }
  //     return null;
  //   } on Exception {
  //     return null;
  //   }
  // }

  // Uint8List getChosenPic() {
  //   return _chosenPic;
  // }

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
          lastPicture: oldState.displayPicture,
          displayPicture: _pictureImageService.transformedImages[type]!,
          imageDataType: type,
          isTransferedStyleToImage: oldState.isTransferedStyleToImage,
          isSaved: oldState.isSaved,
        ),
      );
    }
  }

  // List<StyleImage> getListOfArts() {
  //   var list = _getArtsUseCase.execute();
  //   return list;
  // }

  Future<void> transferStyle(Uint8List styleArt) async {
    var oldStateValue = state.value!;
    state = const AsyncValue.loading();

    // Put here to show Loader Overlay working - Screen freezes when TF is executed
    await Future.delayed(const Duration(milliseconds: 300));

    var transformedPicsResult = await _transferStyleService.transferStyle(
      oldStateValue.lastPicture,
      styleArt,
    );

    transformedPicsResult.when(
      (successTransformedPic) {
        state = AsyncValue.data(
          PicArtsState(
            arts: oldStateValue.arts,
            lastPicture: oldStateValue.displayPicture,
            displayPicture: successTransformedPic[oldStateValue.imageDataType]!,
            imageDataType: oldStateValue.imageDataType,
            isTransferedStyleToImage: true,
            isSaved: false,
          ),
        );
      },
      (error) {
        state = AsyncValue.error(
          error,
          StackTrace.current,
        );
      },
    );
  }

  Future<void> addNewCustomArt() async {
    var oldStateValue = state.value!;
    state = const AsyncValue.loading();

    var pickNewCustomArtResult =
        await _artService.pickNewCustomArt(ImageSource.gallery);

    pickNewCustomArtResult.when(
      (gottenCustomArt) {
        _artService.allArtsInOrder.when(
          (successNewArtsList) {
            state = AsyncValue.data(
              PicArtsState(
                arts: successNewArtsList,
                lastPicture: oldStateValue.lastPicture,
                displayPicture: oldStateValue.displayPicture,
                imageDataType: oldStateValue.imageDataType,
                isTransferedStyleToImage:
                    oldStateValue.isTransferedStyleToImage,
                isSaved: oldStateValue.isSaved,
              ),
            );
          },
          (error) {
            state = AsyncValue.error(
              error,
              StackTrace.current,
            );
          },
        );
      },
      (error) {
        state = AsyncValue.error(
          error,
          StackTrace.current,
        );
      },
    );
  }
}
