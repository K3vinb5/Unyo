// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoInfoModel {

@ext.VideoConverter() ext.Video get currentVideo;@ext.VideoConverter() List<ext.Video> get alternativeVideos; int get videoIndex; int get playlistIndex;
/// Create a copy of VideoInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoInfoModelCopyWith<VideoInfoModel> get copyWith => _$VideoInfoModelCopyWithImpl<VideoInfoModel>(this as VideoInfoModel, _$identity);

  /// Serializes this VideoInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoInfoModel&&(identical(other.currentVideo, currentVideo) || other.currentVideo == currentVideo)&&const DeepCollectionEquality().equals(other.alternativeVideos, alternativeVideos)&&(identical(other.videoIndex, videoIndex) || other.videoIndex == videoIndex)&&(identical(other.playlistIndex, playlistIndex) || other.playlistIndex == playlistIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentVideo,const DeepCollectionEquality().hash(alternativeVideos),videoIndex,playlistIndex);

@override
String toString() {
  return 'VideoInfoModel(currentVideo: $currentVideo, alternativeVideos: $alternativeVideos, videoIndex: $videoIndex, playlistIndex: $playlistIndex)';
}


}

/// @nodoc
abstract mixin class $VideoInfoModelCopyWith<$Res>  {
  factory $VideoInfoModelCopyWith(VideoInfoModel value, $Res Function(VideoInfoModel) _then) = _$VideoInfoModelCopyWithImpl;
@useResult
$Res call({
@ext.VideoConverter() ext.Video currentVideo,@ext.VideoConverter() List<ext.Video> alternativeVideos, int videoIndex, int playlistIndex
});




}
/// @nodoc
class _$VideoInfoModelCopyWithImpl<$Res>
    implements $VideoInfoModelCopyWith<$Res> {
  _$VideoInfoModelCopyWithImpl(this._self, this._then);

  final VideoInfoModel _self;
  final $Res Function(VideoInfoModel) _then;

/// Create a copy of VideoInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentVideo = null,Object? alternativeVideos = null,Object? videoIndex = null,Object? playlistIndex = null,}) {
  return _then(_self.copyWith(
currentVideo: null == currentVideo ? _self.currentVideo : currentVideo // ignore: cast_nullable_to_non_nullable
as ext.Video,alternativeVideos: null == alternativeVideos ? _self.alternativeVideos : alternativeVideos // ignore: cast_nullable_to_non_nullable
as List<ext.Video>,videoIndex: null == videoIndex ? _self.videoIndex : videoIndex // ignore: cast_nullable_to_non_nullable
as int,playlistIndex: null == playlistIndex ? _self.playlistIndex : playlistIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoInfoModel].
extension VideoInfoModelPatterns on VideoInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ext.VideoConverter()  ext.Video currentVideo, @ext.VideoConverter()  List<ext.Video> alternativeVideos,  int videoIndex,  int playlistIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoInfoModel() when $default != null:
return $default(_that.currentVideo,_that.alternativeVideos,_that.videoIndex,_that.playlistIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ext.VideoConverter()  ext.Video currentVideo, @ext.VideoConverter()  List<ext.Video> alternativeVideos,  int videoIndex,  int playlistIndex)  $default,) {final _that = this;
switch (_that) {
case _VideoInfoModel():
return $default(_that.currentVideo,_that.alternativeVideos,_that.videoIndex,_that.playlistIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ext.VideoConverter()  ext.Video currentVideo, @ext.VideoConverter()  List<ext.Video> alternativeVideos,  int videoIndex,  int playlistIndex)?  $default,) {final _that = this;
switch (_that) {
case _VideoInfoModel() when $default != null:
return $default(_that.currentVideo,_that.alternativeVideos,_that.videoIndex,_that.playlistIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoInfoModel implements VideoInfoModel {
  const _VideoInfoModel({@ext.VideoConverter() required this.currentVideo, @ext.VideoConverter() required final  List<ext.Video> alternativeVideos, required this.videoIndex, required this.playlistIndex}): _alternativeVideos = alternativeVideos;
  factory _VideoInfoModel.fromJson(Map<String, dynamic> json) => _$VideoInfoModelFromJson(json);

@override@ext.VideoConverter() final  ext.Video currentVideo;
 final  List<ext.Video> _alternativeVideos;
@override@ext.VideoConverter() List<ext.Video> get alternativeVideos {
  if (_alternativeVideos is EqualUnmodifiableListView) return _alternativeVideos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternativeVideos);
}

@override final  int videoIndex;
@override final  int playlistIndex;

/// Create a copy of VideoInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoInfoModelCopyWith<_VideoInfoModel> get copyWith => __$VideoInfoModelCopyWithImpl<_VideoInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoInfoModel&&(identical(other.currentVideo, currentVideo) || other.currentVideo == currentVideo)&&const DeepCollectionEquality().equals(other._alternativeVideos, _alternativeVideos)&&(identical(other.videoIndex, videoIndex) || other.videoIndex == videoIndex)&&(identical(other.playlistIndex, playlistIndex) || other.playlistIndex == playlistIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentVideo,const DeepCollectionEquality().hash(_alternativeVideos),videoIndex,playlistIndex);

@override
String toString() {
  return 'VideoInfoModel(currentVideo: $currentVideo, alternativeVideos: $alternativeVideos, videoIndex: $videoIndex, playlistIndex: $playlistIndex)';
}


}

/// @nodoc
abstract mixin class _$VideoInfoModelCopyWith<$Res> implements $VideoInfoModelCopyWith<$Res> {
  factory _$VideoInfoModelCopyWith(_VideoInfoModel value, $Res Function(_VideoInfoModel) _then) = __$VideoInfoModelCopyWithImpl;
@override @useResult
$Res call({
@ext.VideoConverter() ext.Video currentVideo,@ext.VideoConverter() List<ext.Video> alternativeVideos, int videoIndex, int playlistIndex
});




}
/// @nodoc
class __$VideoInfoModelCopyWithImpl<$Res>
    implements _$VideoInfoModelCopyWith<$Res> {
  __$VideoInfoModelCopyWithImpl(this._self, this._then);

  final _VideoInfoModel _self;
  final $Res Function(_VideoInfoModel) _then;

/// Create a copy of VideoInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentVideo = null,Object? alternativeVideos = null,Object? videoIndex = null,Object? playlistIndex = null,}) {
  return _then(_VideoInfoModel(
currentVideo: null == currentVideo ? _self.currentVideo : currentVideo // ignore: cast_nullable_to_non_nullable
as ext.Video,alternativeVideos: null == alternativeVideos ? _self._alternativeVideos : alternativeVideos // ignore: cast_nullable_to_non_nullable
as List<ext.Video>,videoIndex: null == videoIndex ? _self.videoIndex : videoIndex // ignore: cast_nullable_to_non_nullable
as int,playlistIndex: null == playlistIndex ? _self.playlistIndex : playlistIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
