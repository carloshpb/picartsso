import '../../models/style_image.dart';
import '../../repositories/arts_repository.dart';
import '../get_arts_use_case.dart';

class GetArtsUseCaseImpl implements GetArtsUseCase {
  final ArtsRepository _artsRepository;

  GetArtsUseCaseImpl(this._artsRepository);

  @override
  List<StyleImage> execute() {
    var defaultArts = _artsRepository.defaultArts;
    var customArts = _artsRepository.customArts;
    //print("Default Arts : $defaultArts");
    //print("Custom Arts : $customArts");
    return defaultArts + customArts;
  }
}
