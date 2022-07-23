import 'dart:typed_data';

import '../../repositories/transfer_style_repository.dart';
import '../transfer_style_use_case.dart';

class TransferStyleUseCaseImpl implements TransferStyleUseCase {
  final TransferStyleRepository _transferStyleRepository;

  TransferStyleUseCaseImpl(this._transferStyleRepository);

  @override
  Future<Map<String, Uint8List>> execute(
      Uint8List originalPicture, Uint8List stylePicture) async {
    return await _transferStyleRepository.transfer(
        originalPicture, stylePicture);
  }
}
