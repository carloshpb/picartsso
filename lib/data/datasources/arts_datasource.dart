import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/style_image.dart';
import '../../exceptions/api_exception.dart';

abstract class ArtsDataSource {
  Result<ApiException, List<StyleImage>> get defaultArts;
  Result<ApiException, StyleImage> findArtByName(String artName);
  List<StyleImage> get customArts;
  Future<Result<ApiException, void>> loadDefaultImages();
  Future<Result<ApiException, void>> loadCustomArts();
  Future<Result<ApiException, void>> addCustomArt(StyleImage newCustomArt);
}
