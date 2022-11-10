import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/src/interpreter.dart';

import 'package:picartsso/exceptions/app_exception.dart';

import 'package:multiple_result/multiple_result.dart';

import '../../domain/repositories/ai_models_repository.dart';
import '../datasources/ai_models_datasource.dart';
import '../datasources/impl/ai_models_datasource_impl.dart';

final aiModelsRepository = Provider<AiModelsRepository>(
  (ref) => AiModelsRepositoryImpl(ref.watch(aiModelsDataSource)),
);

class AiModelsRepositoryImpl implements AiModelsRepository {
  final AiModelsDataSource _aiModelsDataSource;

  AiModelsRepositoryImpl(this._aiModelsDataSource);

  @override
  Result<AppException, Interpreter> get interpreterPredictionFloat16 =>
      _aiModelsDataSource.interpreterPredictionFloat16;

  @override
  Result<AppException, Interpreter> get interpreterPredictionInt8 =>
      _aiModelsDataSource.interpreterPredictionInt8;

  @override
  Result<AppException, Interpreter> get interpreterTransformFloat16 =>
      _aiModelsDataSource.interpreterTransformFloat16;

  @override
  Result<AppException, Interpreter> get interpreterTransformInt8 =>
      _aiModelsDataSource.interpreterTransformInt8;

  @override
  Future<Result<AppException, void>> loadAiModels() =>
      _aiModelsDataSource.loadAiModels();
}
