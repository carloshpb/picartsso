import 'dart:typed_data';

import '../../repositories/transfer_style_repository.dart';
import '../get_transformed_images_use_case.dart';

class GetTransformedImagesUseCaseImpl implements GetTransformedImagesUseCase {
  final TransferStyleRepository _transferStyleRepository;

  GetTransformedImagesUseCaseImpl(this._transferStyleRepository);

  @override
  Map<String, Uint8List> execute() {
    return _transferStyleRepository.transformedImages;
  }
}
