import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as image_formatter;

class ImageTransferService with ChangeNotifier {
  final _predictionModelFile = 'models/style_predict.tflite';
  final _transformModelFile = 'models/style_transform.tflite';

  // A imagem do conteúdo deve ser (1, 384, 384, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_TRANSFER_IMAGE_SIZE = 384;

  // O tamanho da imagem do estilo deve ser (1, 256, 256, 3). Recortamos a imagem centralmente e a redimensionamos.
  static const int MODEL_PREDICTION_IMAGE_SIZE = 256;

  // A classe Interpreter tem a função de carregar um modelo e conduzir a inferência do modelo.
  // Inferência é o termo que descreve o ato de utilizar uma rede neural para
  // fornecer insights após ela ter sido treinada. É como se alguém que
  // estudou algum assunto (passou por treinamento) e se formou,
  // estivesse indo trabalhar em um cenário da vida real (inferência).
  late Interpreter interpreterPrediction;
  late Interpreter interpreterTransform;

  // Função que carregará os modelos
  Future<void> loadModel() async {
    // TODO Exception
    interpreterPrediction = await Interpreter.fromAsset(_predictionModelFile);
    interpreterTransform = await Interpreter.fromAsset(_transformModelFile);
  }

  // Future<Uint8List> loadImagePath(String imagePath) async {
  //   print("Image Path : $imagePath");
  //   var styleImageByteData = await rootBundle.load(imagePath);
  //   print("ByteData : ${styleImageByteData.toString()}");
  //   return styleImageByteData.buffer.asUint8List();
  // }

  Future<Uint8List> transfer(Uint8List originData, Uint8List styleData) async {
    var count = 1;
    var originImage = image_formatter.decodeImage(originData);

    if (originImage == null) {
      return Future.error("Invalid origin image");
    }
    //Resize images
    var modelTransferImage = image_formatter.copyResize(originImage,
        width: MODEL_TRANSFER_IMAGE_SIZE, height: MODEL_TRANSFER_IMAGE_SIZE);

    var modelTransferInput = _imageToByteListUInt8(
        modelTransferImage, MODEL_TRANSFER_IMAGE_SIZE, 0, 255);

    var styleImage = image_formatter.decodeImage(styleData);
    // style_image 256 256 3

    if (styleImage == null) {
      return Future.error("Invalid style image");
    }
    print(
        "Style Image Size : ${styleImage.height} ${styleImage.width} ${styleImage.xOffset} ${styleImage.yOffset}");

    var modelPredictionImage = image_formatter.copyResize(styleImage,
        width: MODEL_PREDICTION_IMAGE_SIZE,
        height: MODEL_PREDICTION_IMAGE_SIZE);

    // content_image 384 384 3
    var modelPredictionInput = _imageToByteListUInt8(
        modelPredictionImage, MODEL_PREDICTION_IMAGE_SIZE, 0, 255);

    // var modelPredictionInputImage =
    //     imageFormatter.decodeImage(modelPredictionInput);
    // print(
    //     "Prediction Image Size : ${modelPredictionInputImage?.height} ${modelPredictionInputImage?.width} ${modelPredictionInputImage?.xOffset} ${modelPredictionInputImage?.yOffset}");

    // style_image 1 256 256 3
    var inputsForPrediction = [modelPredictionInput];

    // style_bottleneck 1 1 100
    var outputsForPrediction = <int, Object>{};
    var styleBottleneck = [
      [
        [List.generate(100, (index) => 0.0)]
      ]
    ];
    outputsForPrediction[0] = styleBottleneck;

    // style predict model
    interpreterPrediction.runForMultipleInputs(
        inputsForPrediction, outputsForPrediction);

    print("TEST $count");
    count++;

    // content_image + styleBottleneck
    var inputsForStyleTransfer = [modelTransferInput, styleBottleneck];

    var outputsForStyleTransfer = <int, Object>{};
    // stylized_image 1 384 384 3
    var outputImageData = [
      List.generate(
        MODEL_TRANSFER_IMAGE_SIZE,
        (index) => List.generate(
          MODEL_TRANSFER_IMAGE_SIZE,
          (index) => List.generate(3, (index) => 0.0),
        ),
      ),
    ];
    outputsForStyleTransfer[0] = outputImageData;

    interpreterTransform.runForMultipleInputs(
        inputsForStyleTransfer, outputsForStyleTransfer);

    var outputImage =
        _convertArrayToImage(outputImageData, MODEL_TRANSFER_IMAGE_SIZE);
    var rotateOutputImage = image_formatter.copyRotate(outputImage, 90);
    var flipOutputImage = image_formatter.flipHorizontal(rotateOutputImage);
    var resultImage = image_formatter.copyResize(flipOutputImage,
        width: originImage.width, height: originImage.height);
    var encodedImage =
        Uint8List.fromList(image_formatter.encodeJpg(resultImage));
    return encodedImage;
  }

  image_formatter.Image _convertArrayToImage(
      List<List<List<List<double>>>> imageArray, int inputSize) {
    image_formatter.Image image =
        image_formatter.Image.rgb(inputSize, inputSize);
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

  Uint8List _imageToByteListUInt8(
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
        buffer[pixelIndex++] = (image_formatter.getRed(pixel) - mean) / std;
        buffer[pixelIndex++] = (image_formatter.getGreen(pixel) - mean) / std;
        buffer[pixelIndex++] = (image_formatter.getBlue(pixel) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
