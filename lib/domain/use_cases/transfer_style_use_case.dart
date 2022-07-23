import 'dart:typed_data';

abstract class TransferStyleUseCase {
  Future<Map<String, Uint8List>> execute(
      Uint8List originalPicture, Uint8List stylePicture);
}
