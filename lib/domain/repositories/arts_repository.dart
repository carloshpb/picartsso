import '../models/style_image.dart';

abstract class ArtsRepository {
  Future<List<StyleImage>> getArts();
  StyleImage findArtByName(String artName);
  List<StyleImage> get customArts;
}
