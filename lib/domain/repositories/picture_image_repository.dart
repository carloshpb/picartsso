import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';
import '../models/style_image.dart';

abstract class PictureImageRepository {
  Future<Result<AppException, void>> saveImageToGallery(StyleImage image);
  Future<Result<AppException, void>> saveAllImagesToGallery(
      Map<String, StyleImage> images);
  set chosenPic(Uint8List image);
  Uint8List get chosenPic;
  Future<Result<AppException, Uint8List>> pickImageFromSource(
      ImageSource imageSource);
  Map<String, Uint8List> get transformedImages;
  set transformedImages(Map<String, Uint8List> transformedImages);
}
