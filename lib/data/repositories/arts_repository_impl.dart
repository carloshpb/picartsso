import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picartsso/exceptions/app_exception.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/arts_repository.dart';
import '../datasources/arts_datasource.dart';
import '../datasources/impl/arts_datasource_impl.dart';

final artsRepository = Provider<ArtsRepository>(
  (ref) => ArtsRepositoryImpl(
    ref.watch(artsDataSource),
  ),
);

class ArtsRepositoryImpl implements ArtsRepository {
  final ArtsDataSource _artsDataSource;

  ArtsRepositoryImpl(this._artsDataSource);

  @override
  Future<Result<AppException, void>> addCustomArt(StyleImage newCustomArt) =>
      _artsDataSource.addCustomArt(newCustomArt);

  @override
  List<StyleImage> get customArts => _artsDataSource.customArts;

  @override
  Result<AppException, List<StyleImage>> get defaultArts =>
      _artsDataSource.defaultArts;

  @override
  Result<AppException, StyleImage> findArtByName(String artName) =>
      _artsDataSource.findArtByName(artName);

  @override
  Future<Result<AppException, void>> loadCustomArts() =>
      _artsDataSource.loadCustomArts();

  @override
  Future<Result<AppException, void>> loadDefaultImages() =>
      _artsDataSource.loadDefaultImages();
}
