import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:image/image.dart' as image_formatter;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../../data/repositories/ai_models_repository_impl.dart';
import '../../../data/repositories/picture_image_repository_impl.dart';
import '../../../exceptions/app_exception.dart';
import '../../repositories/ai_models_repository.dart';
import '../../repositories/picture_image_repository.dart';
import '../transfer_style_service.dart';

final transferStyleService = Provider<TransferStyleService>(
  (ref) => TransferStyleServiceImpl(
    ref.watch(aiModelsRepository),
    ref.watch(pictureImageRepository),
  ),
);

class TransferStyleServiceImpl implements TransferStyleService {
  final AiModelsRepository _aiModelsRepository;
  final PictureImageRepository _pictureImageRepository;

  TransferStyleServiceImpl(
    this._aiModelsRepository,
    this._pictureImageRepository,
  );

  // A imagem do conteúdo deve ser (1, 384, 384, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int imageContentSize = 384;

  // O tamanho da imagem do estilo deve ser (1, 256, 256, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int imageStyleSize = 256;

  // Função que carregará os modelos
  @override
  Future<Result<void, AppException>> loadModel() =>
      _aiModelsRepository.loadAiModels();

  @override
  Result<Uint8List, AppException> transferStyle(
      Uint8List originalPicture, Uint8List stylePicture) {
    Uint8List preprocessedContentImage;
    Uint8List preprocessedStyleImage;

    var decodedOriginalImage = image_formatter.decodeImage(originalPicture);
    if (decodedOriginalImage == null) {
      throw AppException.invalidImage(originalPicture.toString());
    }

    var decodedStyleImage = image_formatter.decodeImage(stylePicture);
    if (decodedStyleImage == null) {
      throw AppException.invalidImage(stylePicture.toString());
    }

    try {
      preprocessedContentImage =
          _loadImage(decodedOriginalImage, imageContentSize);

      preprocessedStyleImage = _loadImage(decodedStyleImage, imageStyleSize);
    } on AppException catch (e) {
      return Error(e);
    }

    // var preprocessedContentImage = image_formatter.copyResize(
    //   decodedContentImage,
    //   width: imageContentSize,
    //   height: imageContentSize,
    // );
    // )..convert(format: image_formatter.Format.int32);

    // var preprocessedStyleImage = image_formatter.copyResize(
    //   decodedStyleImage,
    //   width: imageStyleSize,
    //   height: imageStyleSize,
    // );
    // )..convert(format: image_formatter.Format.int32);

    // print(
    //     "Prediction Image Size : ${modelPredictionInputImage?.height} ${modelPredictionInputImage?.width} ${modelPredictionInputImage?.xOffset} ${modelPredictionInputImage?.yOffset}");

    // Preparing for Prediction Content Image
    // style_image 1 256 256 3
    var inputsForPrediction = [preprocessedStyleImage];

    // style_bottleneck 1 1 100
    var outputsForPrediction = <int, Object>{};
    var styleBottleneck = [
      [
        [List.generate(100, (index) => 0.0)]
      ]
    ];
    outputsForPrediction[0] = styleBottleneck;

    // Check if interpreter has loaded the model

    try {
      _aiModelsRepository.interpreterPredictionFloat16.when(
        (interpreterPrediction) {
          // got the loaded style prediction model
          // RUN INPUTS FOR PREDICTION
          interpreterPrediction.runForMultipleInputs(
              inputsForPrediction, outputsForPrediction);
        },
        (error) {
          throw error;
        },
      );
    } on AppException catch (e) {
      return Error(e);
    }

    // Now, to prepare for Transform
    // content_image + styleBottleneck
    var inputsStyleTransform = [preprocessedContentImage, styleBottleneck];

    var outputsStyleTransform = <int, Object>{};

    // stylized_image 1 384 384 3
    var outputImageData = [
      List.generate(
        imageContentSize,
        (index) => List.generate(
          imageContentSize,
          (index) => List.generate(3, (index) => 0.0),
        ),
      ),
    ];

    outputsStyleTransform[0] = outputImageData;

    try {
      _aiModelsRepository.interpreterTransformFloat16.when(
          (interpreterTransform) {
        // got the loaded image transform model
        interpreterTransform.runForMultipleInputs(
            inputsStyleTransform, outputsStyleTransform);
      }, (error) {
        throw error;
      });
    } on AppException catch (e) {
      return Error(e);
    }

    // AQUI - Criar 2 endodedImage : Float16 e Int8 - com o código abaixo

    // final transformedPictures = <String, Uint8List>{};

    final encodedTransformedPicture =
        encodeOutputImage(outputImageData, decodedOriginalImage);

    // if (transformedPictures['int8']!.isEmpty) {
    //   return const Error(
    //     AppException.general(
    //         "Não foi possível fazer a transferencia de estilo para a imagem solicitada no formato binário INT8. Tente novamente."),
    //   );
    // }

    // Save locally
    //_pictureImageRepository.transformedImages = transformedPictures;

    return Success(encodedTransformedPicture);
  }

  // HELPER
  Uint8List encodeOutputImage(
      List<List<List<List<double>>>> outputImageDataLists,
      image_formatter.Image decodedOriginalImage) {
    var outputImage =
        _convertArrayToImage(outputImageDataLists, imageContentSize);

    var rotateOutputImage = image_formatter.copyRotate(
      outputImage,
      angle: 90,
    );

    var flipOutputImage = image_formatter.flipHorizontal(rotateOutputImage);

    var resultImage = image_formatter.copyResize(flipOutputImage,
        width: decodedOriginalImage.width, height: decodedOriginalImage.height);

    var encodedImage =
        Uint8List.fromList(image_formatter.encodeJpg(resultImage));

    // TODO : Pode dar problema por conta dessa parte
    return encodedImage;
  }

  // BELLOW HELPERS ARE LOCAL BECAUSE THEY ARE ONLY GOING TO BE USED INSIDE THIS SERVICE

  // HELPER : Convert Array to Image
  image_formatter.Image _convertArrayToImage(
      List<List<List<List<double>>>> imageArray, int inputSize) {
    // image_formatter.Image image =
    //     image_formatter.Image.rgb(inputSize, inputSize);

    // TODO : Pode dar problema aqui ao ter usado o Image.empty
    // var image = image_formatter.Image.fromResized(
    //   image_formatter.Image.empty(),
    //   width: inputSize,
    //   height: inputSize,
    // );

    var image = image_formatter.Image(
      height: inputSize,
      width: inputSize,
    );

    for (var x = 0; x < imageArray[0].length; x++) {
      for (var y = 0; y < imageArray[0][0].length; y++) {
        var r = (imageArray[0][x][y][0] * 255).toInt();
        var g = (imageArray[0][x][y][1] * 255).toInt();
        var b = (imageArray[0][x][y][2] * 255).toInt();
        image.setPixelRgb(x, y, r, g, b);
      }
    }
    return image;
  }

  // HELPER : Convert Image to Uint8List in Float32List byte format
  Uint8List _imageToByteListFloat32(
    image_formatter.Image image,
    int inputSize,
    double mean,
    double std,
  ) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - mean) / std;
        buffer[pixelIndex++] = (pixel.g - mean) / std;
        buffer[pixelIndex++] = (pixel.b - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  /// Load image from Uint8List to Image in format Float32 and RGB
  Uint8List _loadImage(image_formatter.Image image, int sizeForType) {
    /// The image must be RGB images with pixel values being float32 numbers between [0..1].
    // if (decodedImage.format != image_formatter.Format.float32 ||
    //     decodedImage.numChannels != 3) {
    //   decodedImage = decodedImage.convert(
    //     format: image_formatter.Format.float32, // Float32
    //     numChannels: 3, // RGB
    //   );
    // }

    var preprocessedContentImage = image_formatter.copyResize(
      image,
      width: sizeForType,
      height: sizeForType,
    );

    var imageFloat32AsUint8 =
        _imageToByteListFloat32(preprocessedContentImage, sizeForType, 0, 255);

    return imageFloat32AsUint8;
  }

  /// Function to run style prediction on preprocessed style image.
  // Uint8List runStylePredict(image_formatter.Image preprocessedStyleImage) {
  //   // Load the model.
  // }
}
