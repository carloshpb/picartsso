import '../models/style_image.dart';

abstract class ArtService {
  List<StyleImage> getArts();
  Future<List<StyleImage>> getCustomArts();
  Future<void> saveCustomArt(StyleImage art);
}
