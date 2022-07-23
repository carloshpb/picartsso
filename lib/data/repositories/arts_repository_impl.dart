import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:enough_convert/enough_convert.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/arts_repository.dart';
import '../../domain/repositories/store_data_repository.dart';

class ArtsRepositoryImpl implements ArtsRepository {
  // final _defaultArts = [
  //   const StyleImage('Ar, Ferro e Água', 'Robert Delaunay',
  //       _loadImagePath('assets/style_imgs/style0.jpg')),
  //   const StyleImage('Bicentennial Print', 'Roy Lichtenstein',
  //       'assets/style_imgs/style1.jpg'),
  //   const StyleImage(
  //       'Mancha Negra', 'Wassily Kandinsky', 'assets/style_imgs/style2.jpg'),
  //   const StyleImage(
  //       'Brushstrokes', 'Sol LeWitt', 'assets/style_imgs/style3.jpg'),
  //   const StyleImage(
  //       'June Tree', 'Natasha Wescoat', 'assets/style_imgs/style4.jpg'),
  //   const StyleImage(
  //       'Composição VII', 'Wassily Kandinsky', 'assets/style_imgs/style5.jpg'),
  //   const StyleImage('Dawn', 'Kyū Ei', 'assets/style_imgs/style6.jpg'),
  //   const StyleImage('Tons da Noite', 'Oscar Florianus Bluemner',
  //       'assets/style_imgs/style7.jpg'),
  //   const StyleImage(
  //       'Felsenhuhn', 'Wiener Werkstätte', 'assets/style_imgs/style9.jpg'),
  //   const StyleImage(
  //       'Bruxas da Floresta', 'Paul Klee', 'assets/style_imgs/style10.jpg'),
  //   const StyleImage('Jalousie (Jealousy)', 'Eugène Grasset',
  //       'assets/style_imgs/style11.jpg'),
  //   const StyleImage('La ville de Paris', 'Robert Delaunay',
  //       'assets/style_imgs/style12.jpg'),
  //   const StyleImage(
  //       'La Muse', 'Pablo Picasso', 'assets/style_imgs/style13.jpg'),
  //   const StyleImage('Landscape of Daydream 9553', 'Ik Mo Kim',
  //       'assets/style_imgs/style14.jpg'),
  //   const StyleImage(
  //       'Perfume', 'Luigi Russolo', 'assets/style_imgs/style16.jpg'),
  //   const StyleImage('A Noite Estrelada', 'Vincent van Gogh',
  //       'assets/style_imgs/style19.jpg'),
  //   const StyleImage('The Idea-Motion-Fight – Dedicated to Karl Liebknecht',
  //       'Johannes Molzahn', 'assets/style_imgs/style20.jpg'),
  //   const StyleImage(
  //       'The Mellow Pad', 'Stuart Davis', 'assets/style_imgs/style21.jpg'),
  //   const StyleImage(
  //       "L'Escalier", 'Fernand Léger', 'assets/style_imgs/style22.jpg'),
  //   const StyleImage(
  //       'Udnie', 'Francis Picabia', 'assets/style_imgs/style23.jpg'),
  //   const StyleImage('A Grande Onda de Kanagawa', 'Katsushika Hokusai',
  //       'assets/style_imgs/style24.jpg'),
  //   const StyleImage('Wild Garden', 'Nikos Hadjikyriakos-Ghikas',
  //       'assets/style_imgs/style25.jpg'),
  // ];

  final _defaultArts = <StyleImage>[];
  final _customArts = <StyleImage>[];

  final StoreDataRepository _storeDataRepository;

  ArtsRepositoryImpl(this._storeDataRepository);

  @override
  List<StyleImage> get defaultArts {
    return [..._defaultArts];
  }

  @override
  StyleImage findArtByName(String artName) {
    return _defaultArts.firstWhere(
      (defaultArt) => defaultArt.artName.contains(artName),
      orElse: () => _customArts.firstWhere(
        (customArt) => customArt.artName.contains(artName),
        orElse: () => throw Exception('Not Found'),
      ),
    );
  }

  @override
  List<StyleImage> get customArts {
    return [..._customArts];
  }

  @override
  void addCustomArt(StyleImage art) {
    _customArts.add(art);
  }

  Future<Uint8List> _loadImagePath(String imagePath) async {
    var styleImageByteData = await rootBundle.load(imagePath);
    return styleImageByteData.buffer.asUint8List();
  }

  @override
  Future<void> loadDefaultImages() async {
    final manifestContent = await rootBundle.loadString("AssetManifest.json");
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/style_imgs/')) // 0 - 17
        .where((String key) => key.contains('.jpg')) // 0 - 3
        .toList();

    imagePaths.sort();

    for (var artPath in imagePaths) {
      var pathDecoded = Uri.decodeComponent(artPath);
      var cleanedPath = pathDecoded.replaceAll('assets/style_imgs/', '');
      cleanedPath = cleanedPath.replaceAll('.jpg', '');
      cleanedPath = cleanedPath.replaceAll('_', ' ');
      var separatedNames = cleanedPath.split('--');
      var image = await _loadImagePath(pathDecoded);
      var newStyleImage = StyleImage(
        artName: separatedNames[0],
        authorName: separatedNames[1],
        image: image,
      );
      _defaultArts.add(newStyleImage);
    }
  }

  @override
  Future<void> loadCustomArts() async {
    try {
      var result = await _storeDataRepository.readLocalCustomArts();
      result.sort((a, b) => a.artName.compareTo(b.artName));
      for (var customArt in result) {
        _customArts.add(customArt);
      }
    } on Exception {
      //DO NOTHING YET
    }
  }
}
