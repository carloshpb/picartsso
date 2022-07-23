import '../models/style_image.dart';

abstract class ArtsRepository {
  List<StyleImage> get defaultArts;
  StyleImage findArtByName(String artName);
  List<StyleImage> get customArts;
  Future<void> loadDefaultImages();
  Future<void> loadCustomArts();
  void addCustomArt(StyleImage art);
}
