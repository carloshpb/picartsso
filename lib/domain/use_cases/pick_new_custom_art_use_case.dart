import '../models/style_image.dart';

abstract class PickNewCustomArtUseCase {
  Future<List<StyleImage>> execute();
}
