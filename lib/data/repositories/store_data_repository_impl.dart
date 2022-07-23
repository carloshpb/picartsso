import 'dart:convert';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/store_data_repository.dart';

class StoreDataRepositoryImpl implements StoreDataRepository {
  final SharedPreferences _sharedPreferences;
  late Uint8List _chosenPic;

  StoreDataRepositoryImpl(this._sharedPreferences);

  @override
  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    await ImageGallerySaver.saveImage(
      imageBytes,
      name: "transformedImage${DateTime.now().toIso8601String()}",
    );
  }

  @override
  Future<void> saveImagesToGallery(Map<String, Uint8List> images) async {
    if (images.containsKey('float16') && images['float16'] != null) {
      await ImageGallerySaver.saveImage(
        images['float16']!,
        name: "transformedImageFloat16--${DateTime.now().toIso8601String()}",
      );
    } else {
      throw Exception('Não há imagem transformada do tipo Float16.');
    }
    if (images.containsKey('int8') && images['int8'] != null) {
      await ImageGallerySaver.saveImage(
        images['int8']!,
        name: "transformedImageInt8--${DateTime.now().toIso8601String()}",
      );
    } else {
      throw Exception('Não há imagem transformada do tipo Int8.');
    }
  }

  @override
  Future<Uint8List> setTempChosenPic(XFile pic) async {
    _chosenPic = await pic.readAsBytes();
    return _chosenPic;
  }

  @override
  Uint8List get tempChosenPic => _chosenPic;

  @override
  Future<void> storeLocallyNewArt(List<StyleImage> customArts) async {
    await _sharedPreferences.setStringList(
        'customArts',
        customArts
            .map((customArt) => json.encode(customArt.toJson()))
            .toList());
  }

  @override
  Future<List<StyleImage>> readLocalCustomArts() async {
    var result = _sharedPreferences.getStringList('customArts');
    if (result == null) {
      throw Exception("Não há artes customizadas guardadas localmente.");
    }
    return result
        .map((customArtJson) => StyleImage.fromJson(json.decode(customArtJson)))
        .toList();
  }
}
