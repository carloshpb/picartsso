import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../repositories/image_picker_repository.dart';
import '../pick_image_use_case.dart';

class PickImageUseCaseImpl implements PickImageUseCase {
  final ImagePickerRepository _imagePickerRepository;

  PickImageUseCaseImpl(this._imagePickerRepository);

  @override
  Future<Uint8List> execute(ImageSource imageSource) async {
    return await _imagePickerRepository.pickImage(imageSource);
  }
}
