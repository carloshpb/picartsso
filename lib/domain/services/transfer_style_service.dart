import 'dart:typed_data';

import 'package:multiple_result/multiple_result.dart';

import '../../exceptions/app_exception.dart';

abstract class TransferStyleService {
  Future<Result<void, AppException>> loadModel();
  Result<Uint8List, AppException> transferStyle(
      Uint8List originalPicture, Uint8List stylePicture);
}
