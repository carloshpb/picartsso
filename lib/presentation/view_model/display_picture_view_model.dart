import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain_provider_module.dart' as domain_provider_module;

final displayPictureViewModelProvider = StateNotifierProvider.autoDispose<
    DisplayPictureViewModel, AsyncValue<void>>(
  (ref) => DisplayPictureViewModel(
      //ref.watch(domain_provider_module.pickImageUseCase),
      ),
);

class DisplayPictureViewModel extends StateNotifier<AsyncValue<void>> {
  DisplayPictureViewModel(
      //this._pickImageUseCase,
      )
      : super(const AsyncValue.loading());
}
