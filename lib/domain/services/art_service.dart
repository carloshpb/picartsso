import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';
import '../models/style_image.dart';

abstract class ArtService {
  Result<AppException, List<StyleImage>> get defaultArts;
  List<StyleImage> get customArts;

  Result<AppException, List<StyleImage>> get allArtsInOrder;

  Result<AppException, StyleImage> findArtByName(String artName);

  Future<Result<AppException, void>> loadDefaultImages();
  Future<Result<AppException, void>> loadCustomArts();

  Future<Result<AppException, StyleImage>> pickNewCustomArt(
      ImageSource imageSource);
}
