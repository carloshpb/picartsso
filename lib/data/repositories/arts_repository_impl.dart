import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:enough_convert/enough_convert.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picartsso/exceptions/app_exception.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/style_image.dart';
import '../../domain/repositories/arts_repository.dart';
import '../../domain/repositories/store_data_repository.dart';
import '../datasources/arts_datasource.dart';
import '../datasources/impl/arts_datasource_impl.dart';

final artsRepository = Provider<ArtsRepository>(
  (ref) => ArtsRepositoryImpl(
    ref.watch(artsDataSource),
  ),
);

class ArtsRepositoryImpl implements ArtsRepository {
  final ArtsDataSource _artsDataSource;

  ArtsRepositoryImpl(this._artsDataSource);

  @override
  Future<Result<AppException, void>> addCustomArt(StyleImage newCustomArt) {
    // TODO: implement addCustomArt
    throw UnimplementedError();
  }

  @override
  // TODO: implement customArts
  List<StyleImage> get customArts => throw UnimplementedError();

  @override
  // TODO: implement defaultArts
  Result<AppException, List<StyleImage>> get defaultArts =>
      throw UnimplementedError();

  @override
  Result<AppException, StyleImage> findArtByName(String artName) {
    // TODO: implement findArtByName
    throw UnimplementedError();
  }

  @override
  Future<Result<AppException, void>> loadCustomArts() {
    // TODO: implement loadCustomArts
    throw UnimplementedError();
  }

  @override
  Future<Result<AppException, void>> loadDefaultImages() {
    // TODO: implement loadDefaultImages
    throw UnimplementedError();
  }

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

}
