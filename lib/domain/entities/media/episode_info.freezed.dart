// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpisodeInfoModel {

 int get id; int get episodeNumber;@TitleConverter() Title get title; String get airDate; String get image; String get duration; String get description; String get rating;
/// Create a copy of EpisodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeInfoModelCopyWith<EpisodeInfoModel> get copyWith => _$EpisodeInfoModelCopyWithImpl<EpisodeInfoModel>(this as EpisodeInfoModel, _$identity);

  /// Serializes this EpisodeInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.image, image) || other.image == image)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,title,airDate,image,duration,description,rating);



}

/// @nodoc
abstract mixin class $EpisodeInfoModelCopyWith<$Res>  {
  factory $EpisodeInfoModelCopyWith(EpisodeInfoModel value, $Res Function(EpisodeInfoModel) _then) = _$EpisodeInfoModelCopyWithImpl;
@useResult
$Res call({
 int id, int episodeNumber,@TitleConverter() Title title, String airDate, String image, String duration, String description, String rating
});




}
/// @nodoc
class _$EpisodeInfoModelCopyWithImpl<$Res>
    implements $EpisodeInfoModelCopyWith<$Res> {
  _$EpisodeInfoModelCopyWithImpl(this._self, this._then);

  final EpisodeInfoModel _self;
  final $Res Function(EpisodeInfoModel) _then;

/// Create a copy of EpisodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? episodeNumber = null,Object? title = null,Object? airDate = null,Object? image = null,Object? duration = null,Object? description = null,Object? rating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Title,airDate: null == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeInfoModel].
extension EpisodeInfoModelPatterns on EpisodeInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int episodeNumber, @TitleConverter()  Title title,  String airDate,  String image,  String duration,  String description,  String rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeInfoModel() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.title,_that.airDate,_that.image,_that.duration,_that.description,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int episodeNumber, @TitleConverter()  Title title,  String airDate,  String image,  String duration,  String description,  String rating)  $default,) {final _that = this;
switch (_that) {
case _EpisodeInfoModel():
return $default(_that.id,_that.episodeNumber,_that.title,_that.airDate,_that.image,_that.duration,_that.description,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int episodeNumber, @TitleConverter()  Title title,  String airDate,  String image,  String duration,  String description,  String rating)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeInfoModel() when $default != null:
return $default(_that.id,_that.episodeNumber,_that.title,_that.airDate,_that.image,_that.duration,_that.description,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpisodeInfoModel implements EpisodeInfoModel {
  const _EpisodeInfoModel({required this.id, required this.episodeNumber, @TitleConverter() required this.title, required this.airDate, required this.image, required this.duration, required this.description, required this.rating});
  factory _EpisodeInfoModel.fromJson(Map<String, dynamic> json) => _$EpisodeInfoModelFromJson(json);

@override final  int id;
@override final  int episodeNumber;
@override@TitleConverter() final  Title title;
@override final  String airDate;
@override final  String image;
@override final  String duration;
@override final  String description;
@override final  String rating;

/// Create a copy of EpisodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeInfoModelCopyWith<_EpisodeInfoModel> get copyWith => __$EpisodeInfoModelCopyWithImpl<_EpisodeInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.episodeNumber, episodeNumber) || other.episodeNumber == episodeNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.airDate, airDate) || other.airDate == airDate)&&(identical(other.image, image) || other.image == image)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,episodeNumber,title,airDate,image,duration,description,rating);



}

/// @nodoc
abstract mixin class _$EpisodeInfoModelCopyWith<$Res> implements $EpisodeInfoModelCopyWith<$Res> {
  factory _$EpisodeInfoModelCopyWith(_EpisodeInfoModel value, $Res Function(_EpisodeInfoModel) _then) = __$EpisodeInfoModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int episodeNumber,@TitleConverter() Title title, String airDate, String image, String duration, String description, String rating
});




}
/// @nodoc
class __$EpisodeInfoModelCopyWithImpl<$Res>
    implements _$EpisodeInfoModelCopyWith<$Res> {
  __$EpisodeInfoModelCopyWithImpl(this._self, this._then);

  final _EpisodeInfoModel _self;
  final $Res Function(_EpisodeInfoModel) _then;

/// Create a copy of EpisodeInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? episodeNumber = null,Object? title = null,Object? airDate = null,Object? image = null,Object? duration = null,Object? description = null,Object? rating = null,}) {
  return _then(_EpisodeInfoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,episodeNumber: null == episodeNumber ? _self.episodeNumber : episodeNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Title,airDate: null == airDate ? _self.airDate : airDate // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
