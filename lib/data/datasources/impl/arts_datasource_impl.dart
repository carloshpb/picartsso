import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:picartsso/domain/models/style_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../exceptions/app_exception.dart';
import '../arts_datasource.dart';

final _defaultArts = StateProvider<List<StyleImage>>(
  (_) => <StyleImage>[],
);

final _customArts = StateProvider<List<StyleImage>>(
  (_) => <StyleImage>[],
);

final _sharedPreferences = FutureProvider<SharedPreferences>(
  (_) async => await SharedPreferences.getInstance(),
);

final artsDataSource = Provider<ArtsDataSource>(
  (ref) => ArtsDataSourceImpl(ref),
);

class ArtsDataSourceImpl implements ArtsDataSource {
  final Ref _ref;

  ArtsDataSourceImpl(
    this._ref,
  );

  @override
  Future<Result<AppException, void>> addCustomArt(
      StyleImage newCustomArt) async {
    final oldCustomArtsList = _ref.read(_customArts);
    final newCustomArtsList = [...oldCustomArtsList, newCustomArt];
    _ref.read(_customArts.notifier).state = newCustomArtsList;

    final sharedPref = _ref.read(_sharedPreferences);
    try {
      await sharedPref.value!.setStringList(
          'customArts',
          newCustomArtsList
              .map((customArt) => json.encode(customArt.toJson()))
              .toList());
      return const Success(null);
    } on Exception catch (e) {
      return Error(
        AppException.general(
          "SharedPreferences not loaded: ${e.toString()}",
        ),
      );
    }
  }

  @override
  List<StyleImage> get customArts => [..._ref.read(_customArts)];

  @override
  Result<AppException, List<StyleImage>> get defaultArts {
    final listDefaultArts = _ref.read(_defaultArts);
    return (listDefaultArts.isEmpty)
        ? const Error(AppException.general("Default Arts list wasn't loaded."))
        : Success([...listDefaultArts]);
  }

  @override
  Result<AppException, StyleImage> findArtByName(String artName) {
    return defaultArts.when(
      (error) => Error(error),
      (arts) {
        try {
          var result = arts.firstWhere(
            (art) => art.artName.contains(artName),
            orElse: () => customArts.firstWhere(
              (customArt) => customArt.artName.contains(artName),
            ),
          );
          return Success(result);
        } on StateError {
          return const Error(AppException.general("Art not found."));
        }
      },
    );
  }

  @override
  Future<Result<AppException, void>> loadCustomArts() async {
    final sharedPref = _ref.read(_sharedPreferences);
    try {
      var customArtsJson = sharedPref.value!.getStringList('customArts');
      if (customArtsJson == null || customArtsJson.isEmpty) {
        return const Error(AppException.general(
            "Não há artes customizadas guardadas localmente."));
      }
      var customArtsStyleImages = customArtsJson
          .map((customArtJson) =>
              StyleImage.fromJson(json.decode(customArtJson)))
          .toList();

      _ref.read(_customArts.notifier).state = customArtsStyleImages;
      return const Success(null);
    } on Exception catch (e) {
      return Error(
        AppException.general(
          "SharedPreferences not loaded: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Result<AppException, void>> loadDefaultImages() async {
    late String manifestContent;
    try {
      manifestContent = await rootBundle.loadString("AssetManifest.json");
    } on Exception {
      return const Error(
          AppException.general("File AssetManifest.json not found."));
    }

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/style_imgs/')) // 0 - 17
        .where((String key) => key.contains('.jpg')) // 0 - 3
        .toList();

    imagePaths.sort();

    final defaultArts = <StyleImage>[];

    for (var artPath in imagePaths) {
      var pathDecoded = Uri.decodeComponent(artPath);
      var cleanedPath = pathDecoded.replaceAll('assets/style_imgs/', '');
      cleanedPath = cleanedPath.replaceAll('.jpg', '');
      cleanedPath = cleanedPath.replaceAll('_', ' ');
      var separatedNames = cleanedPath.split('--');
      var styleImageByteData = await rootBundle.load(pathDecoded);
      var image = styleImageByteData.buffer.asUint8List();
      var newStyleImage = StyleImage(
        artName: separatedNames[0],
        authorName: separatedNames[1],
        image: image,
      );
      defaultArts.add(newStyleImage);
    }

    _ref.read(_defaultArts.notifier).state = defaultArts;

    return const Success(null);
  }
}
