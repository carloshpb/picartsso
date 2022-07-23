import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/arts_repository.dart';
import '../../domain/repositories/image_picker_repository.dart';
import '../../domain/repositories/store_data_repository.dart';

class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ArtsRepository _artsRepository;
  final StoreDataRepository _storeDataRepository;

  final ImagePicker _picker = ImagePicker();

  ImagePickerRepositoryImpl(
    this._artsRepository,
    this._storeDataRepository,
  );

  // can throw PlatformException
  @override
  Future<Uint8List> pickImage(ImageSource imageSource) async {
    var image = await _picker.pickImage(source: imageSource);
    if (image != null) {
      return await _storeDataRepository.setTempChosenPic(image);
    } else {
      throw Exception("Não foi escolhido nenhuma imagem.");
    }
  }

  // can throw PlatformException
  @override
  Future<List<StyleImage>> pickAndAddNewArt() async {
    var art = await _picker.pickImage(source: ImageSource.gallery);
    if (art != null) {
      var artByte = await art.readAsBytes();
      var styleImage = StyleImage(
        artName: 'CustomArt${_artsRepository.customArts.length}',
        authorName: 'Me',
        image: artByte,
      );
      _artsRepository.addCustomArt(styleImage);
      //_storeDataRepository.tempChosenPic = image;
      await _storeDataRepository.storeLocallyNewArt(_artsRepository.customArts);
      return _artsRepository.defaultArts + _artsRepository.customArts;
    } else {
      throw Exception("Não foi escolhido nenhuma arte nova.");
    }
  }
}
