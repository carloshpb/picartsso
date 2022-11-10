import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';
import '../models/style_image.dart';

abstract class ArtsRepository {
  Result<AppException, List<StyleImage>> get defaultArts;
  Result<AppException, StyleImage> findArtByName(String artName);
  List<StyleImage> get customArts;
  Future<Result<AppException, void>> loadDefaultImages();
  Future<Result<AppException, void>> loadCustomArts();
  Future<Result<AppException, void>> addCustomArt(StyleImage newCustomArt);
}
