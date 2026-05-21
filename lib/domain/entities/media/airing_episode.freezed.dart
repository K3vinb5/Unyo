// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'airing_episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiringEpisodeModel {

 int get episode; String get airingAt;
/// Create a copy of AiringEpisodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiringEpisodeModelCopyWith<AiringEpisodeModel> get copyWith => _$AiringEpisodeModelCopyWithImpl<AiringEpisodeModel>(this as AiringEpisodeModel, _$identity);

  /// Serializes this AiringEpisodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiringEpisodeModel&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.airingAt, airingAt) || other.airingAt == airingAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,episode,airingAt);



}

/// @nodoc
abstract mixin class $AiringEpisodeModelCopyWith<$Res>  {
  factory $AiringEpisodeModelCopyWith(AiringEpisodeModel value, $Res Function(AiringEpisodeModel) _then) = _$AiringEpisodeModelCopyWithImpl;
@useResult
$Res call({
 int episode, String airingAt
});




}
/// @nodoc
class _$AiringEpisodeModelCopyWithImpl<$Res>
    implements $AiringEpisodeModelCopyWith<$Res> {
  _$AiringEpisodeModelCopyWithImpl(this._self, this._then);

  final AiringEpisodeModel _self;
  final $Res Function(AiringEpisodeModel) _then;

/// Create a copy of AiringEpisodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? episode = null,Object? airingAt = null,}) {
  return _then(_self.copyWith(
episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as int,airingAt: null == airingAt ? _self.airingAt : airingAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiringEpisodeModel].
extension AiringEpisodeModelPatterns on AiringEpisodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiringEpisodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiringEpisodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiringEpisodeModel value)  $default,){
final _that = this;
switch (_that) {
case _AiringEpisodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiringEpisodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AiringEpisodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int episode,  String airingAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiringEpisodeModel() when $default != null:
return $default(_that.episode,_that.airingAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int episode,  String airingAt)  $default,) {final _that = this;
switch (_that) {
case _AiringEpisodeModel():
return $default(_that.episode,_that.airingAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int episode,  String airingAt)?  $default,) {final _that = this;
switch (_that) {
case _AiringEpisodeModel() when $default != null:
return $default(_that.episode,_that.airingAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiringEpisodeModel implements AiringEpisodeModel {
  const _AiringEpisodeModel({required this.episode, required this.airingAt});
  factory _AiringEpisodeModel.fromJson(Map<String, dynamic> json) => _$AiringEpisodeModelFromJson(json);

@override final  int episode;
@override final  String airingAt;

/// Create a copy of AiringEpisodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiringEpisodeModelCopyWith<_AiringEpisodeModel> get copyWith => __$AiringEpisodeModelCopyWithImpl<_AiringEpisodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiringEpisodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiringEpisodeModel&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.airingAt, airingAt) || other.airingAt == airingAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,episode,airingAt);



}

/// @nodoc
abstract mixin class _$AiringEpisodeModelCopyWith<$Res> implements $AiringEpisodeModelCopyWith<$Res> {
  factory _$AiringEpisodeModelCopyWith(_AiringEpisodeModel value, $Res Function(_AiringEpisodeModel) _then) = __$AiringEpisodeModelCopyWithImpl;
@override @useResult
$Res call({
 int episode, String airingAt
});




}
/// @nodoc
class __$AiringEpisodeModelCopyWithImpl<$Res>
    implements _$AiringEpisodeModelCopyWith<$Res> {
  __$AiringEpisodeModelCopyWithImpl(this._self, this._then);

  final _AiringEpisodeModel _self;
  final $Res Function(_AiringEpisodeModel) _then;

/// Create a copy of AiringEpisodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? episode = null,Object? airingAt = null,}) {
  return _then(_AiringEpisodeModel(
episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as int,airingAt: null == airingAt ? _self.airingAt : airingAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
