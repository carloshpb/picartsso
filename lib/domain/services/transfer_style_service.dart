import 'dart:typed_data';

abstract class TransferStyleService {
  Future<void> loadModel();
  Future<Map<String, Uint8List>> transferStyle(
      Uint8List originalPicture, Uint8List stylePicture);
}
