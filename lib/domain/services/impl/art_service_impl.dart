import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picartsso/domain/models/style_image.dart';

import '../art_service.dart';

final artService = Provider<ArtService>(
  (ref) => ArtServiceImpl(),
);

class ArtServiceImpl implements ArtService {
  @override
  List<StyleImage> getArts() {
    // TODO: implement getArts
    throw UnimplementedError();
  }

  @override
  Future<List<StyleImage>> getCustomArts() {
    // TODO: implement getCustomArts
    throw UnimplementedError();
  }

  @override
  Future<void> saveCustomArt(StyleImage art) {
    // TODO: implement saveCustomArt
    throw UnimplementedError();
  }
}
