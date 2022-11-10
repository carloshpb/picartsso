import 'dart:typed_data';

import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';

abstract class TransferStyleService {
  Future<Result<AppException, void>> loadModel();
  Future<Map<String, Uint8List>> transferStyle(
      Uint8List originalPicture, Uint8List stylePicture);
}
