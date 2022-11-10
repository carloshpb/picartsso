import 'package:multiple_result/multiple_result.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../exceptions/app_exception.dart';

abstract class AiModelsRepository {
  Future<Result<AppException, void>> loadAiModels();
  Result<AppException, Interpreter> get interpreterPredictionFloat16;
  Result<AppException, Interpreter> get interpreterTransformFloat16;
  Result<AppException, Interpreter> get interpreterPredictionInt8;
  Result<AppException, Interpreter> get interpreterTransformInt8;
}
