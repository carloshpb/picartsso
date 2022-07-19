import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/store_data_repository.dart';

class StoreDataRepositoryImpl implements StoreDataRepository {
  late XFile chosenPic;

  @override
  Future<void> guardTempData() async {
    final prefs = await SharedPreferences.getInstance();

    //await prefs
  }

  @override
  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    await ImageGallerySaver.saveImage(
      imageBytes,
      name: "transformedImage${DateTime.now().toIso8601String()}",
    );
  }

  set tempChosenPic(XFile pic) {
    chosenPic = pic;
  }

  XFile get tempChosenPic => chosenPic;

  @override
  Future<void> storeLocallyNewArt(XFile art) async {
    final prefs = await SharedPreferences.getInstance();
  }
}
