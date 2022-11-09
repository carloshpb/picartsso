import 'dart:typed_data';

abstract class PictureImageService {
  Future<void> saveImageInGallery(Map<String, Uint8List> images);
  Uint8List getChosenImage();
  Future<void> setTempChosenPic(Uint8List pic);
  Map<String, Uint8List> getTransformedImages();
}
