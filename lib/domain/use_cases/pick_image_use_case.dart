import 'package:image_picker/image_picker.dart';

abstract class PickImageUseCase {
  Future<void> execute(ImageSource imageSource);
}
