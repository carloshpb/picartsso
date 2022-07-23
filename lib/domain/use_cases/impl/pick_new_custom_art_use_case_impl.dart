import '../../models/style_image.dart';
import '../../repositories/image_picker_repository.dart';
import '../pick_new_custom_art_use_case.dart';

class PickNewCustomArtUseCaseImpl implements PickNewCustomArtUseCase {
  final ImagePickerRepository _imagePickerRepository;

  PickNewCustomArtUseCaseImpl(this._imagePickerRepository);

  @override
  Future<List<StyleImage>> execute() async {
    return await _imagePickerRepository.pickAndAddNewArt();
  }
}
