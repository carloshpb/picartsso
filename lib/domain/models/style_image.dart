// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../util/converters/uint8list_converter.dart';

part 'style_image.freezed.dart';
part 'style_image.g.dart';

@freezed
class StyleImage with _$StyleImage {
  const factory StyleImage({
    required String artName,
    required String authorName,
    @Uint8ListConverter() required Uint8List image,
  }) = _StyleImage;

  factory StyleImage.fromJson(Map<String, Object?> json) =>
      _$StyleImageFromJson(json);

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'artName': artName,
  //     'authorName': authorName,
  //     'image': String.fromCharCodes(image),
  //   };
  // }

  // factory StyleImage.fromMap(Map<String, dynamic> map) {
  //   return StyleImage(
  //     map['artName'] as String,
  //     map['authorName'] as String,
  //     Uint8List.fromList((map['image'] as String).codeUnits),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory StyleImage.fromJson(String source) =>
  //     StyleImage.fromMap(json.decode(source) as Map<String, dynamic>);
}
