import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../domain/repositories/transfer_style_repository.dart';

class TransferStyleRepositoryImpl implements TransferStyleRepository {
  final Map<String, Uint8List> _transformedPictures = {};

  // A imagem do conteúdo deve ser (1, 384, 384, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_TRANSFER_IMAGE_SIZE = 384;

  // O tamanho da imagem do estilo deve ser (1, 256, 256, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_PREDICTION_IMAGE_SIZE = 256;

  @override
  Future<Map<String, Uint8List>> transfer(
      Uint8List originalPicture, Uint8List stylePicture) async {
    var decodedOriginalImage = decodeImage(originalPicture);

    if (decodedOriginalImage == null) {
      return Future.error("Invalid origin image");
    }

    var decodedStyleImage = decodeImage(stylePicture);
    // style_image 256 256 3

    if (decodedStyleImage == null) {
      return Future.error("Invalid style image");
    }

    //Resize images
    var modelTransferImageFloat16 = copyResize(decodedOriginalImage,
        width: MODEL_TRANSFER_IMAGE_SIZE, height: MODEL_TRANSFER_IMAGE_SIZE);

    var modelTransferImageInt8 = modelTransferImageFloat16.clone();

    var modelTransferInputFloat16 = _imageToByteListUInt8(
        modelTransferImageFloat16, MODEL_TRANSFER_IMAGE_SIZE, 0, 255);

    var modelTransferInputInt8 = _imageToByteListUInt8(
        modelTransferImageInt8, MODEL_TRANSFER_IMAGE_SIZE, 0, 255);

    print(
        "Style Image Size : ${decodedStyleImage.height} ${decodedStyleImage.width} ${decodedStyleImage.xOffset} ${decodedStyleImage.yOffset}");

    var modelPredictionImageFloat16 = copyResize(decodedStyleImage,
        width: MODEL_PREDICTION_IMAGE_SIZE,
        height: MODEL_PREDICTION_IMAGE_SIZE);

    var modelPredictionImageInt8 = modelPredictionImageFloat16.clone();

    // content_image 384 384 3
    var modelPredictionInputFloat16 = _imageToByteListUInt8(
        modelPredictionImageFloat16, MODEL_PREDICTION_IMAGE_SIZE, 0, 255);

    var modelPredictionInputInt8 = _imageToByteListUInt8(
        modelPredictionImageInt8, MODEL_PREDICTION_IMAGE_SIZE, 0, 255);

    // var modelPredictionInputImage =
    //     imageFormatter.decodeImage(modelPredictionInput);
    // print(
    //     "Prediction Image Size : ${modelPredictionInputImage?.height} ${modelPredictionInputImage?.width} ${modelPredictionInputImage?.xOffset} ${modelPredictionInputImage?.yOffset}");

    // Preparing for Prediction
    // style_image 1 256 256 3
    var inputsForPredictionFloat16 = [modelPredictionInputFloat16];
    var inputsForPredictionInt8 = [modelPredictionInputInt8];

    // style_bottleneck 1 1 100
    var outputsForPredictionFloat16 = <int, Object>{};
    var outputsForPredictionInt8 = <int, Object>{};
    var styleBottleneckFloat16 = [
      [
        [List.generate(100, (index) => 0.0)]
      ]
    ];

    var styleBottleneckInt8 = [
      [
        [List.generate(100, (index) => 0.0)]
      ]
    ];

    outputsForPredictionFloat16[0] = styleBottleneckFloat16;
    outputsForPredictionInt8[0] = styleBottleneckInt8;

    // style predict model Float 16
    interpreterPredictionFloat16.runForMultipleInputs(
        inputsForPredictionFloat16, outputsForPredictionFloat16);

    // style predict model Int 8
    interpreterPredictionInt8.runForMultipleInputs(
        inputsForPredictionInt8, outputsForPredictionInt8);

    // Now, to prepare for Transform
    // content_image + styleBottleneck
    var inputsForStyleTransferFloat16 = [
      modelTransferInputFloat16,
      styleBottleneckFloat16
    ];

    var inputsForStyleTransferInt8 = [
      modelTransferInputInt8,
      styleBottleneckInt8
    ];

    var outputsForStyleTransferFloat16 = <int, Object>{};
    var outputsForStyleTransferInt8 = <int, Object>{};
    // stylized_image 1 384 384 3
    var outputImageDataFloat16 = [
      List.generate(
        MODEL_TRANSFER_IMAGE_SIZE,
        (index) => List.generate(
          MODEL_TRANSFER_IMAGE_SIZE,
          (index) => List.generate(3, (index) => 0.0),
        ),
      ),
    ];
    var outputImageDataInt8 = [
      List.generate(
        MODEL_TRANSFER_IMAGE_SIZE,
        (index) => List.generate(
          MODEL_TRANSFER_IMAGE_SIZE,
          (index) => List.generate(3, (index) => 0.0),
        ),
      ),
    ];
    outputsForStyleTransferFloat16[0] = outputImageDataFloat16;
    outputsForStyleTransferInt8[0] = outputImageDataInt8;

    interpreterTransformFloat16.runForMultipleInputs(
        inputsForStyleTransferFloat16, outputsForStyleTransferFloat16);

    interpreterTransformInt8.runForMultipleInputs(
        inputsForStyleTransferInt8, outputsForStyleTransferInt8);

    // AQUI - Criar 2 endodedImage : Float16 e Int8 - com o código abaixo

    _transformedPictures['float16'] =
        encodeOutputImage(outputImageDataFloat16, decodedOriginalImage);
    _transformedPictures['int8'] =
        encodeOutputImage(outputImageDataInt8, decodedOriginalImage);

    return _transformedPictures;
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
