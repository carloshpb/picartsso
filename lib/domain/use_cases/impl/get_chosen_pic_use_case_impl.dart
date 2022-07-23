import 'dart:typed_data';

import '../../repositories/store_data_repository.dart';
import '../get_chosen_pic_use_case.dart';

class GetChosenPicUseCaseImpl implements GetChosenPicUseCase {
  final StoreDataRepository _storeDataRepository;

  GetChosenPicUseCaseImpl(this._storeDataRepository);

  @override
  Uint8List execute() {
    return _storeDataRepository.tempChosenPic;
  }
}
