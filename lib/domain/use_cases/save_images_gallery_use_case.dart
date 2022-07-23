import 'dart:typed_data';

abstract class SaveImagesGalleryUseCase {
  Future<void> execute(Map<String, Uint8List> images);
}
