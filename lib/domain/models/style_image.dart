import 'dart:typed_data';

class StyleImage {
  final String artName;
  final String authorName;
  final Uint8List image;

  const StyleImage(
    this.artName,
    this.authorName,
    this.image,
  );
}
