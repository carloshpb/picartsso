// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pic_arts_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PicArtsState {
  List<StyleImage> get arts => throw _privateConstructorUsedError;
  Uint8List get displayPicture => throw _privateConstructorUsedError;
  String get imageDataType => throw _privateConstructorUsedError;
  bool get isTransferedStyleToImage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PicArtsStateCopyWith<PicArtsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PicArtsStateCopyWith<$Res> {
  factory $PicArtsStateCopyWith(
          PicArtsState value, $Res Function(PicArtsState) then) =
      _$PicArtsStateCopyWithImpl<$Res>;
  $Res call(
      {List<StyleImage> arts,
      Uint8List displayPicture,
      String imageDataType,
      bool isTransferedStyleToImage});
}

/// @nodoc
class _$PicArtsStateCopyWithImpl<$Res> implements $PicArtsStateCopyWith<$Res> {
  _$PicArtsStateCopyWithImpl(this._value, this._then);

  final PicArtsState _value;
  // ignore: unused_field
  final $Res Function(PicArtsState) _then;

  @override
  $Res call({
    Object? arts = freezed,
    Object? displayPicture = freezed,
    Object? imageDataType = freezed,
    Object? isTransferedStyleToImage = freezed,
  }) {
    return _then(_value.copyWith(
      arts: arts == freezed
          ? _value.arts
          : arts // ignore: cast_nullable_to_non_nullable
              as List<StyleImage>,
      displayPicture: displayPicture == freezed
          ? _value.displayPicture
          : displayPicture // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      imageDataType: imageDataType == freezed
          ? _value.imageDataType
          : imageDataType // ignore: cast_nullable_to_non_nullable
              as String,
      isTransferedStyleToImage: isTransferedStyleToImage == freezed
          ? _value.isTransferedStyleToImage
          : isTransferedStyleToImage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_PicArtsStateCopyWith<$Res>
    implements $PicArtsStateCopyWith<$Res> {
  factory _$$_PicArtsStateCopyWith(
          _$_PicArtsState value, $Res Function(_$_PicArtsState) then) =
      __$$_PicArtsStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<StyleImage> arts,
      Uint8List displayPicture,
      String imageDataType,
      bool isTransferedStyleToImage});
}

/// @nodoc
class __$$_PicArtsStateCopyWithImpl<$Res>
    extends _$PicArtsStateCopyWithImpl<$Res>
    implements _$$_PicArtsStateCopyWith<$Res> {
  __$$_PicArtsStateCopyWithImpl(
      _$_PicArtsState _value, $Res Function(_$_PicArtsState) _then)
      : super(_value, (v) => _then(v as _$_PicArtsState));

  @override
  _$_PicArtsState get _value => super._value as _$_PicArtsState;

  @override
  $Res call({
    Object? arts = freezed,
    Object? displayPicture = freezed,
    Object? imageDataType = freezed,
    Object? isTransferedStyleToImage = freezed,
  }) {
    return _then(_$_PicArtsState(
      arts: arts == freezed
          ? _value._arts
          : arts // ignore: cast_nullable_to_non_nullable
              as List<StyleImage>,
      displayPicture: displayPicture == freezed
          ? _value.displayPicture
          : displayPicture // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      imageDataType: imageDataType == freezed
          ? _value.imageDataType
          : imageDataType // ignore: cast_nullable_to_non_nullable
              as String,
      isTransferedStyleToImage: isTransferedStyleToImage == freezed
          ? _value.isTransferedStyleToImage
          : isTransferedStyleToImage // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PicArtsState implements _PicArtsState {
  const _$_PicArtsState(
      {required final List<StyleImage> arts,
      required this.displayPicture,
      required this.imageDataType,
      required this.isTransferedStyleToImage})
      : _arts = arts;

  final List<StyleImage> _arts;
  @override
  List<StyleImage> get arts {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_arts);
  }

  @override
  final Uint8List displayPicture;
  @override
  final String imageDataType;
  @override
  final bool isTransferedStyleToImage;

  @override
  String toString() {
    return 'PicArtsState(arts: $arts, displayPicture: $displayPicture, imageDataType: $imageDataType, isTransferedStyleToImage: $isTransferedStyleToImage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PicArtsState &&
            const DeepCollectionEquality().equals(other._arts, _arts) &&
            const DeepCollectionEquality()
                .equals(other.displayPicture, displayPicture) &&
            const DeepCollectionEquality()
                .equals(other.imageDataType, imageDataType) &&
            const DeepCollectionEquality().equals(
                other.isTransferedStyleToImage, isTransferedStyleToImage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_arts),
      const DeepCollectionEquality().hash(displayPicture),
      const DeepCollectionEquality().hash(imageDataType),
      const DeepCollectionEquality().hash(isTransferedStyleToImage));

  @JsonKey(ignore: true)
  @override
  _$$_PicArtsStateCopyWith<_$_PicArtsState> get copyWith =>
      __$$_PicArtsStateCopyWithImpl<_$_PicArtsState>(this, _$identity);
}

abstract class _PicArtsState implements PicArtsState {
  const factory _PicArtsState(
      {required final List<StyleImage> arts,
      required final Uint8List displayPicture,
      required final String imageDataType,
      required final bool isTransferedStyleToImage}) = _$_PicArtsState;

  @override
  List<StyleImage> get arts;
  @override
  Uint8List get displayPicture;
  @override
  String get imageDataType;
  @override
  bool get isTransferedStyleToImage;
  @override
  @JsonKey(ignore: true)
  _$$_PicArtsStateCopyWith<_$_PicArtsState> get copyWith =>
      throw _privateConstructorUsedError;
}
