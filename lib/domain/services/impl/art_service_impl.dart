import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:picartsso/domain/models/style_image.dart';
import 'package:picartsso/exceptions/app_exception.dart';

import '../../../data/repositories/arts_repository_impl.dart';
import '../../../data/repositories/picture_image_repository_impl.dart';
import '../../repositories/arts_repository.dart';
import '../../repositories/picture_image_repository.dart';
import '../art_service.dart';

final artService = Provider<ArtService>(
  (ref) => ArtServiceImpl(
    ref.watch(artsRepository),
    ref.watch(pictureImageRepository),
  ),
);

class ArtServiceImpl implements ArtService {
  final ArtsRepository _artsRepository;
  final PictureImageRepository _pictureImageRepository;

  ArtServiceImpl(
    this._artsRepository,
    this._pictureImageRepository,
  );

  @override
  List<StyleImage> get customArts => _artsRepository.customArts;

  @override
  Result<AppException, List<StyleImage>> get defaultArts =>
      _artsRepository.defaultArts;

  @override
  Result<AppException, StyleImage> findArtByName(String artName) =>
      _artsRepository.findArtByName(artName);

  @override
  Future<Result<AppException, void>> loadCustomArts() =>
      _artsRepository.loadCustomArts();
  @override
  Future<Result<AppException, void>> loadDefaultImages() =>
      _artsRepository.loadDefaultImages();

  @override
  Future<Result<AppException, StyleImage>> pickNewCustomArt(
      ImageSource imageSource) async {
    var newCustomArt =
        await _pictureImageRepository.pickImageFromSource(imageSource);
    return newCustomArt.when(
      (error) => Error(error),
      (success) async {
        var styleImage = StyleImage(
          artName: 'CustomArt${_artsRepository.customArts.length}',
          authorName: 'Me',
          image: success,
        );
        var resultSaveCustomArt =
            await _artsRepository.addCustomArt(styleImage);
        return resultSaveCustomArt.when(
          (error) => Error(error),
          (success) => Success(styleImage),
        );
      },
    );
  }
}
