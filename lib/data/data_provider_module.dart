import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/arts_repository.dart';
import '../domain/repositories/image_picker_repository.dart';
import '../domain/repositories/store_data_repository.dart';
import '../domain/repositories/transfer_style_repository.dart';
import 'repositories/arts_repository_impl.dart';
import 'repositories/image_picker_repository_impl.dart';
import 'repositories/store_data_repository_impl.dart';
import 'repositories/transfer_style_repository_impl.dart';
import '../router/app_router.dart';

// Special provider with object (SharedPreferences) implemented at Main
final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

// Provider which implements object started at Main
final storeDataRepository = Provider<StoreDataRepository>(
  (ref) {
    var sharedPreferences = ref.watch(sharedPreferencesProvider);
    return StoreDataRepositoryImpl(sharedPreferences);
  },
);

final autoRouterProvider = Provider<AppRouter>((_) => AppRouter());

final artsRepository = Provider<ArtsRepository>(
  (ref) => ArtsRepositoryImpl(
    ref.watch(storeDataRepository),
  ),
);

final imagePickerRepository = Provider<ImagePickerRepository>(
  (ref) => ImagePickerRepositoryImpl(
    ref.watch(artsRepository),
    ref.watch(storeDataRepository),
  ),
);

final transferStyleRepository = Provider<TransferStyleRepository>(
  (_) => TransferStyleRepositoryImpl(),
);
