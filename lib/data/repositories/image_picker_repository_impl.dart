import 'package:image_picker/image_picker.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/arts_repository.dart';
import '../../domain/repositories/image_picker_repository.dart';
import '../../domain/repositories/store_data_repository.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ArtsRepository _artsRepository;
  final StoreDataRepository _storeDataRepository;

  final ImagePicker _picker = ImagePicker();

  ImagePickerRepositoryImpl(
    this._artsRepository,
    this._storeDataRepository,
  );

  // can throw PlatformException
  @override
  Future<void> pickImage(ImageSource imageSource) async {
    var image = await _picker.pickImage(source: imageSource);
    if (image != null) {
      _storeDataRepository.tempChosenPic = image;
    }
  }

  @override
  Future<void> pickNewArt() async {
    var art = await _picker.pickImage(source: ImageSource.gallery);
    if (art != null) {
      var styleImage = StyleImage(
        'CustomArt${_artsRepository.customArts.length}',
        'Me',
        '',
      );
      _artsRepository.customArts.add(styleImage);
      _storeDataRepository.tempChosenPic = image;
    }
  }
}
