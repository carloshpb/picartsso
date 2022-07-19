import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

abstract class StoreDataRepository {
  Future<void> guardTempData();
  Future<void> saveImageToGallery(Uint8List imageBytes);
  set tempChosenPic(XFile pic);
  XFile get tempChosenPic;
  Future<void> storeLocallyNewArt(XFile art);
}
