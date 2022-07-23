import 'dart:typed_data';

import '../../repositories/store_data_repository.dart';
import '../save_images_gallery_use_case.dart';

class SaveImagesGalleryUseCaseImpl implements SaveImagesGalleryUseCase {
  final StoreDataRepository _storeDataRepository;

  SaveImagesGalleryUseCaseImpl(this._storeDataRepository);

  @override
  Future<void> execute(Map<String, Uint8List> images) async {
    await _storeDataRepository.saveImagesToGallery(images);
  }
}
