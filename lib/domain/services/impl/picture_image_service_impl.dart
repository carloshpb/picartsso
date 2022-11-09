import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../picture_image_service.dart';

final pictureImageService = Provider<PictureImageService>(
  (ref) => PictureImageServiceImpl(),
);

class PictureImageServiceImpl implements PictureImageService {
  @override
  Uint8List getChosenImage() {
    // TODO: implement getChosenImage
    throw UnimplementedError();
  }

  @override
  Map<String, Uint8List> getTransformedImages() {
    // TODO: implement getTransformedImages
    throw UnimplementedError();
  }

  @override
  Future<void> saveImageInGallery(Map<String, Uint8List> images) {
    // TODO: implement saveImageInGallery
    throw UnimplementedError();
  }

  @override
  Future<void> setTempChosenPic(Uint8List pic) {
    // TODO: implement setTempChosenPic
    throw UnimplementedError();
  }
}
