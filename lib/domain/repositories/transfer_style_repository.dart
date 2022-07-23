import 'dart:typed_data';

abstract class TransferStyleRepository {
  Future<void> loadModel();
  Future<Map<String, Uint8List>> transfer(
      Uint8List originalPicture, Uint8List stylePicture);
  Map<String, Uint8List> get transformedImages;
}
