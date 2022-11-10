import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/style_image.dart';
import '../../exceptions/app_exception.dart';

abstract class ArtsDataSource {
  Result<AppException, List<StyleImage>> get defaultArts;
  Result<AppException, StyleImage> findArtByName(String artName);
  List<StyleImage> get customArts;
  Future<Result<AppException, void>> loadDefaultImages();
  Future<Result<AppException, void>> loadCustomArts();
  Future<Result<AppException, void>> addCustomArt(StyleImage newCustomArt);
}
