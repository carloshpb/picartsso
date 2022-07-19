import 'package:image_picker/image_picker.dart';

abstract class ImagePickerRepository {
  Future<void> pickImage(ImageSource imageSource);
}
