import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/data_provider_module.dart' as data_provider_module;

import 'use_cases/get_arts_use_case.dart';
import 'use_cases/get_chosen_pic_use_case.dart';
import 'use_cases/get_transformed_images_use_case.dart';
import 'use_cases/impl/get_arts_use_case_impl.dart';
import 'use_cases/impl/get_chosen_pic_use_case_impl.dart';
import 'use_cases/impl/get_transformed_images_use_case_impl.dart';
import 'use_cases/impl/load_initial_data_use_case_impl.dart';
import 'use_cases/impl/pick_image_use_case_impl.dart';
import 'use_cases/impl/pick_new_custom_art_use_case_impl.dart';
import 'use_cases/impl/save_images_gallery_use_case_impl.dart';
import 'use_cases/impl/transfer_style_use_case_impl.dart';
import 'use_cases/load_initial_data_use_case.dart';
import 'use_cases/pick_image_use_case.dart';
import 'use_cases/pick_new_custom_art_use_case.dart';
import 'use_cases/save_images_gallery_use_case.dart';
import 'use_cases/transfer_style_use_case.dart';

final pickImageUseCase = Provider<PickImageUseCase>(
  (ref) => PickImageUseCaseImpl(
    ref.watch(data_provider_module.imagePickerRepository),
  ),
);

final loadInitialDataUseCase = Provider<LoadInitialDataUseCase>(
  (ref) => LoadInitialDataUseCaseImpl(
    ref.watch(data_provider_module.artsRepository),
    ref.watch(data_provider_module.transferStyleRepository),
  ),
);

final transferStyleUseCase = Provider<TransferStyleUseCase>(
  (ref) => TransferStyleUseCaseImpl(
    ref.watch(data_provider_module.transferStyleRepository),
  ),
);

final saveImagesGalleryUseCase = Provider<SaveImagesGalleryUseCase>(
  (ref) => SaveImagesGalleryUseCaseImpl(
    ref.watch(data_provider_module.storeDataRepository),
  ),
);

final getArtsUseCase = Provider<GetArtsUseCase>(
  (ref) => GetArtsUseCaseImpl(
    ref.watch(data_provider_module.artsRepository),
  ),
);

final pickNewCustomArtUseCase = Provider<PickNewCustomArtUseCase>(
  (ref) => PickNewCustomArtUseCaseImpl(
    ref.watch(data_provider_module.imagePickerRepository),
  ),
);

final getChosenPicUseCase = Provider<GetChosenPicUseCase>(
  (ref) => GetChosenPicUseCaseImpl(
    ref.watch(data_provider_module.storeDataRepository),
  ),
);

final getTransformedImagesUseCase = Provider<GetTransformedImagesUseCase>(
  (ref) => GetTransformedImagesUseCaseImpl(
    ref.watch(data_provider_module.transferStyleRepository),
  ),
);
