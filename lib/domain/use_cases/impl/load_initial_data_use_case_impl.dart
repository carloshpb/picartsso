import 'package:picartsso/domain/repositories/arts_repository.dart';

import '../../repositories/transfer_style_repository.dart';
import '../load_initial_data_use_case.dart';

class LoadInitialDataUseCaseImpl implements LoadInitialDataUseCase {
  final ArtsRepository _artsRepository;
  final TransferStyleRepository _transferStyleRepository;

  LoadInitialDataUseCaseImpl(
    this._artsRepository,
    this._transferStyleRepository,
  );

  @override
  Future<void> execute() async {
    await _artsRepository.loadDefaultImages();
    await _artsRepository.loadCustomArts();
    await _transferStyleRepository.loadModel();
  }
}
