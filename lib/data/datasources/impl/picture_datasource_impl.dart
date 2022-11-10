import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../exceptions/app_exception.dart';
import '../picture_datasource.dart';

final _chosenPic = StateProvider<Uint8List>(
  (_) => Uint8List(0),
);

final _transformedPic = StateProvider<Map<String, Uint8List>>(
  (_) => <String, Uint8List>{},
);

final pictureDataSource = Provider<PictureDataSource>(
  (ref) => PictureDataSourceImpl(
    ref,
    ImagePicker(),
  ),
);

class PictureDataSourceImpl implements PictureDataSource {
  final Ref _ref;
  final ImagePicker _imagePicker;

  PictureDataSourceImpl(
    this._ref,
    this._imagePicker,
  );

  /// If it exists a chosen picture, it'll return a valid Uint8List. Otherwise, it'll return Uint8List(0)
  @override
  Uint8List get chosenPic => _ref.read(_chosenPic);

  @override
  set chosenPic(Uint8List image) {
    _ref.read(_chosenPic.notifier).state = image;
  }

  @override
  Future<Result<AppException, void>> saveAllImagesToGallery(
      Map<String, Uint8List> images) async {
    if (await Permission.photos.request().isGranted) {
      if (images.containsKey('float16') && images['float16'] != null) {
        await ImageGallerySaver.saveImage(
          images['float16']!,
          name: "transformedImageFloat16--${DateTime.now().toIso8601String()}",
        );
      } else {
        return const Error(AppException.general(
            "There isn't a transformed image of type Float16"));
      }
      if (images.containsKey('int8') && images['int8'] != null) {
        await ImageGallerySaver.saveImage(
          images['int8']!,
          name: "transformedImageInt8--${DateTime.now().toIso8601String()}",
        );
      } else {
        return const Error(AppException.general(
            "There isn't a transformed image of type Int8"));
      }
      return const Success(null);
    }
    return const Error(AppException.permission(Permission.photos));
  }

  @override
  Future<Result<AppException, void>> saveImageToGallery(
      Uint8List imageBytes) async {
    if (await Permission.photos.request().isGranted) {
      await ImageGallerySaver.saveImage(
        imageBytes,
        name: "transformedImage${DateTime.now().toIso8601String()}",
      );
      return const Success(null);
    }
    return const Error(AppException.permission(Permission.photos));
  }

  @override
  Future<Result<AppException, Uint8List>> pickImageFromSource(
      ImageSource imageSource) async {
    final Permission permissionSource;
    switch (imageSource) {
      case ImageSource.gallery:
        permissionSource = Permission.photos;
        break;
      case ImageSource.camera:
        permissionSource = Permission.camera;
        break;
      default:
        return const Error(AppException.general("Unknown image source."));
    }
    if (await permissionSource.request().isGranted) {
      var image = await _imagePicker.pickImage(source: imageSource);
      if (image != null) {
        return Success(await image.readAsBytes());
      } else {
        return const Error(
            AppException.general("Não foi escolhido nenhuma imagem."));
      }
    }
    return Error(AppException.permission(permissionSource));
  }

  @override
  Map<String, Uint8List> get transformedImages => _ref.read(_transformedPic);

  @override
  set transformedImages(Map<String, Uint8List> transformedImages) {
    _ref.read(_transformedPic.notifier).state = transformedImages;
  }
}
