import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';

abstract class PictureDataSource {
  Future<Result<AppException, void>> saveImageToGallery(Uint8List imageBytes);
  Future<Result<AppException, void>> saveAllImagesToGallery(
      Map<String, Uint8List> images);
  set chosenPic(Uint8List image);
  Uint8List get chosenPic;
  Future<Result<AppException, Uint8List>> pickImageFromSource(
      ImageSource imageSource);
}
