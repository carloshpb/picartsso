import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picartsso/exceptions/app_exception.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../models/style_image.dart';
import '../../repositories/picture_image_repository.dart';
import '../picture_image_service.dart';
import '../../../data/repositories/picture_image_repository_impl.dart';

final pictureImageService = Provider<PictureImageService>(
  (ref) => PictureImageServiceImpl(
    ref.watch(pictureImageRepository),
  ),
);

class PictureImageServiceImpl implements PictureImageService {
  final PictureImageRepository _pictureImageRepository;

  PictureImageServiceImpl(this._pictureImageRepository);

  @override
  set chosenPic(Uint8List image) {
    _pictureImageRepository.chosenPic = image;
  }

  @override
  Uint8List get chosenPic => _pictureImageRepository.chosenPic;

  @override
  Future<Result<AppException, Uint8List>> pickImageFromSource(
          ImageSource imageSource) =>
      _pictureImageRepository.pickImageFromSource(imageSource);

  @override
  Future<Result<AppException, void>> saveAllImagesToGallery(
          Map<String, StyleImage> images) =>
      _pictureImageRepository.saveAllImagesToGallery(images);

  @override
  Future<Result<AppException, void>> saveImageToGallery(StyleImage image) =>
      _pictureImageRepository.saveImageToGallery(image);
}
