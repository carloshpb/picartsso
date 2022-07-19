import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/arts_repository.dart';
import '../domain/repositories/image_picker_repository.dart';
import '../domain/repositories/store_data_repository.dart';
import 'repositories/arts_repository_impl.dart';
import 'repositories/image_picker_repository_impl.dart';
import 'repositories/store_data_repository_impl.dart';

final storeDataRepository = Provider<StoreDataRepository>(
  (_) => StoreDataRepositoryImpl(),
);

final artsRepository = Provider<ArtsRepository>(
  (_) => ArtsRepositoryImpl(),
);

final imagePickerRepository = Provider<ImagePickerRepository>(
  (ref) => ImagePickerRepositoryImpl(
    ref.watch(artsRepository),
    ref.watch(storeDataRepository),
  ),
);
