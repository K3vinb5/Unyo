// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaListModel {

@HiveField(0) String get name;@HiveField(1) MediaType get mediaType;
/// Create a copy of MediaListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaListModelCopyWith<MediaListModel> get copyWith => _$MediaListModelCopyWithImpl<MediaListModel>(this as MediaListModel, _$identity);

  /// Serializes this MediaListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaListModel&&(identical(other.name, name) || other.name == name)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mediaType);

@override
String toString() {
  return 'MediaListModel(name: $name, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class $MediaListModelCopyWith<$Res>  {
  factory $MediaListModelCopyWith(MediaListModel value, $Res Function(MediaListModel) _then) = _$MediaListModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String name,@HiveField(1) MediaType mediaType
});




}
/// @nodoc
class _$MediaListModelCopyWithImpl<$Res>
    implements $MediaListModelCopyWith<$Res> {
  _$MediaListModelCopyWithImpl(this._self, this._then);

  final MediaListModel _self;
  final $Res Function(MediaListModel) _then;

/// Create a copy of MediaListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? mediaType = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaListModel].
extension MediaListModelPatterns on MediaListModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaListModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaListModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaListModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaListModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaListModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String name, @HiveField(1)  MediaType mediaType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaListModel() when $default != null:
return $default(_that.name,_that.mediaType);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String name, @HiveField(1)  MediaType mediaType)  $default,) {final _that = this;
switch (_that) {
case _MediaListModel():
return $default(_that.name,_that.mediaType);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String name, @HiveField(1)  MediaType mediaType)?  $default,) {final _that = this;
switch (_that) {
case _MediaListModel() when $default != null:
return $default(_that.name,_that.mediaType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaListModel implements MediaListModel {
  const _MediaListModel({@HiveField(0) required this.name, @HiveField(1) required this.mediaType});
  factory _MediaListModel.fromJson(Map<String, dynamic> json) => _$MediaListModelFromJson(json);

@override@HiveField(0) final  String name;
@override@HiveField(1) final  MediaType mediaType;

/// Create a copy of MediaListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaListModelCopyWith<_MediaListModel> get copyWith => __$MediaListModelCopyWithImpl<_MediaListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaListModel&&(identical(other.name, name) || other.name == name)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,mediaType);

@override
String toString() {
  return 'MediaListModel(name: $name, mediaType: $mediaType)';
}


}

/// @nodoc
abstract mixin class _$MediaListModelCopyWith<$Res> implements $MediaListModelCopyWith<$Res> {
  factory _$MediaListModelCopyWith(_MediaListModel value, $Res Function(_MediaListModel) _then) = __$MediaListModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String name,@HiveField(1) MediaType mediaType
});




}
/// @nodoc
class __$MediaListModelCopyWithImpl<$Res>
    implements _$MediaListModelCopyWith<$Res> {
  __$MediaListModelCopyWithImpl(this._self, this._then);

  final _MediaListModel _self;
  final $Res Function(_MediaListModel) _then;

/// Create a copy of MediaListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? mediaType = null,}) {
  return _then(_MediaListModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,
  ));
}


}

// dart format on
