import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_provider_module.dart' as data_provider_module;

import 'use_cases/impl/pick_image_use_case_impl.dart';
import 'use_cases/pick_image_use_case.dart';

final pickImageUseCase = Provider<PickImageUseCase>(
  (ref) => PickImageUseCaseImpl(
    ref.watch(data_provider_module.imagePickerRepository),
  ),
);
