import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../domain/repositories/transfer_style_repository.dart';

class TransferStyleRepositoryImpl implements TransferStyleRepository {
  final _predictionModelFileFloat16 =
      'models/magenta_arbitrary-image-stylization-v1-256_fp16_prediction_1.tflite';
  final _transformModelFileFloat16 =
      'models/magenta_arbitrary-image-stylization-v1-256_fp16_transfer_1.tflite';

  final _predictionModelFileInt8 =
      'models/magenta_arbitrary-image-stylization-v1-256_int8_prediction_1.tflite';
  final _transformModelFileInt8 =
      'models/magenta_arbitrary-image-stylization-v1-256_int8_transfer_1.tflite';

  final Map<String, Uint8List> _transformedPictures = {};

  // A imagem do conteúdo deve ser (1, 384, 384, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_TRANSFER_IMAGE_SIZE = 384;

  // O tamanho da imagem do estilo deve ser (1, 256, 256, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_PREDICTION_IMAGE_SIZE = 256;

  // A classe Interpreter tem a função de carregar um modelo e conduzir a inferência do modelo.
  // Inferência é o termo que descreve o ato de utilizar uma rede neural para
  // fornecer insights após ela ter sido treinada. É como se alguém que
  // estudou algum assunto (passou por treinamento) e se formou,
  // estivesse indo trabalhar em um cenário da vida real (inferência).
  late Interpreter interpreterPredictionFloat16;
  late Interpreter interpreterTransformFloat16;
  late Interpreter interpreterPredictionInt8;
  late Interpreter interpreterTransformInt8;

  // Função que carregará os modelos
  @override
  Future<void> loadModel() async {
    // TODO Exception
    interpreterPredictionFloat16 =
        await Interpreter.fromAsset(_predictionModelFileFloat16);
    interpreterTransformFloat16 =
        await Interpreter.fromAsset(_transformModelFileFloat16);
    interpreterPredictionInt8 =
        await Interpreter.fromAsset(_predictionModelFileInt8);
    interpreterTransformInt8 =
        await Interpreter.fromAsset(_transformModelFileInt8);
  }

  @override
  Future<Map<String, Uint8List>> transfer(
      Uint8List originalPicture, Uint8List stylePicture) async {
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

    // Preparing for Prediction
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
        interpreterPrediction.runForMultipleInputs(
            inputsForPrediction, outputsForPrediction);
      }, (error) {
        throw error;
      });
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

    final encodedTransformedPicture =
        encodeOutputImage(outputImageData, decodedOriginalImage);

    return Success(encodedTransformedPicture);
  }

  // HELPER
  Uint8List encodeOutputImage(List<List<List<List<double>>>> outputImageData,
      Image decodedOriginalImage) {
    var outputImage =
        _convertArrayToImage(outputImageData, MODEL_TRANSFER_IMAGE_SIZE);
    var rotateOutputImageFloat16 = copyRotate(outputImage, 90);
    var flipOutputImage = flipHorizontal(rotateOutputImageFloat16);
    var resultImage = copyResize(flipOutputImage,
        width: decodedOriginalImage.width, height: decodedOriginalImage.height);
    var encodedImage = Uint8List.fromList(encodeJpg(resultImage));
    return encodedImage;
  }

  // HELPER : Convert Array to Image
  Image _convertArrayToImage(
      List<List<List<List<double>>>> imageArray, int inputSize) {
    Image image = Image.rgb(inputSize, inputSize);
    for (var x = 0; x < imageArray[0].length; x++) {
      for (var y = 0; y < imageArray[0][0].length; y++) {
        var r = (imageArray[0][x][y][0] * 255).toInt();
        var g = (imageArray[0][x][y][1] * 255).toInt();
        var b = (imageArray[0][x][y][2] * 255).toInt();
        image.setPixelRgba(x, y, r, g, b);
      }
    }
    return image;
  }

  // HELPER : Convert Image to Uint8List
  Uint8List _imageToByteListUInt8(
    Image image,
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
        buffer[pixelIndex++] = (getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  @override
  Map<String, Uint8List> get transformedImages => _transformedPictures;
}
