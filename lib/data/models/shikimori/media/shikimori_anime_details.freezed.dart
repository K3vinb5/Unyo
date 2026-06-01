// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shikimori_anime_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShikimoriAnimeDetailsModel {

@MediaListEntryConverter() MediaListEntry get mediaListEntry;@AnimeConverter() List<Anime> get recommendedAnimes;@MediaCharacterConverter() List<MediaCharacter> get characters;
/// Create a copy of ShikimoriAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShikimoriAnimeDetailsModelCopyWith<ShikimoriAnimeDetailsModel> get copyWith => _$ShikimoriAnimeDetailsModelCopyWithImpl<ShikimoriAnimeDetailsModel>(this as ShikimoriAnimeDetailsModel, _$identity);

  /// Serializes this ShikimoriAnimeDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShikimoriAnimeDetailsModel&&(identical(other.mediaListEntry, mediaListEntry) || other.mediaListEntry == mediaListEntry)&&const DeepCollectionEquality().equals(other.recommendedAnimes, recommendedAnimes)&&const DeepCollectionEquality().equals(other.characters, characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaListEntry,const DeepCollectionEquality().hash(recommendedAnimes),const DeepCollectionEquality().hash(characters));

@override
String toString() {
  return 'ShikimoriAnimeDetailsModel(mediaListEntry: $mediaListEntry, recommendedAnimes: $recommendedAnimes, characters: $characters)';
}


}

/// @nodoc
abstract mixin class $ShikimoriAnimeDetailsModelCopyWith<$Res>  {
  factory $ShikimoriAnimeDetailsModelCopyWith(ShikimoriAnimeDetailsModel value, $Res Function(ShikimoriAnimeDetailsModel) _then) = _$ShikimoriAnimeDetailsModelCopyWithImpl;
@useResult
$Res call({
@MediaListEntryConverter() MediaListEntry mediaListEntry,@AnimeConverter() List<Anime> recommendedAnimes,@MediaCharacterConverter() List<MediaCharacter> characters
});




}
/// @nodoc
class _$ShikimoriAnimeDetailsModelCopyWithImpl<$Res>
    implements $ShikimoriAnimeDetailsModelCopyWith<$Res> {
  _$ShikimoriAnimeDetailsModelCopyWithImpl(this._self, this._then);

  final ShikimoriAnimeDetailsModel _self;
  final $Res Function(ShikimoriAnimeDetailsModel) _then;

/// Create a copy of ShikimoriAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaListEntry = null,Object? recommendedAnimes = null,Object? characters = null,}) {
  return _then(_self.copyWith(
mediaListEntry: null == mediaListEntry ? _self.mediaListEntry : mediaListEntry // ignore: cast_nullable_to_non_nullable
as MediaListEntry,recommendedAnimes: null == recommendedAnimes ? _self.recommendedAnimes : recommendedAnimes // ignore: cast_nullable_to_non_nullable
as List<Anime>,characters: null == characters ? _self.characters : characters // ignore: cast_nullable_to_non_nullable
as List<MediaCharacter>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShikimoriAnimeDetailsModel].
extension ShikimoriAnimeDetailsModelPatterns on ShikimoriAnimeDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShikimoriAnimeDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShikimoriAnimeDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShikimoriAnimeDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@MediaListEntryConverter()  MediaListEntry mediaListEntry, @AnimeConverter()  List<Anime> recommendedAnimes, @MediaCharacterConverter()  List<MediaCharacter> characters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel() when $default != null:
return $default(_that.mediaListEntry,_that.recommendedAnimes,_that.characters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@MediaListEntryConverter()  MediaListEntry mediaListEntry, @AnimeConverter()  List<Anime> recommendedAnimes, @MediaCharacterConverter()  List<MediaCharacter> characters)  $default,) {final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel():
return $default(_that.mediaListEntry,_that.recommendedAnimes,_that.characters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@MediaListEntryConverter()  MediaListEntry mediaListEntry, @AnimeConverter()  List<Anime> recommendedAnimes, @MediaCharacterConverter()  List<MediaCharacter> characters)?  $default,) {final _that = this;
switch (_that) {
case _ShikimoriAnimeDetailsModel() when $default != null:
return $default(_that.mediaListEntry,_that.recommendedAnimes,_that.characters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShikimoriAnimeDetailsModel implements ShikimoriAnimeDetailsModel {
  const _ShikimoriAnimeDetailsModel({@MediaListEntryConverter() required this.mediaListEntry, @AnimeConverter() required final  List<Anime> recommendedAnimes, @MediaCharacterConverter() required final  List<MediaCharacter> characters}): _recommendedAnimes = recommendedAnimes,_characters = characters;
  factory _ShikimoriAnimeDetailsModel.fromJson(Map<String, dynamic> json) => _$ShikimoriAnimeDetailsModelFromJson(json);

@override@MediaListEntryConverter() final  MediaListEntry mediaListEntry;
 final  List<Anime> _recommendedAnimes;
@override@AnimeConverter() List<Anime> get recommendedAnimes {
  if (_recommendedAnimes is EqualUnmodifiableListView) return _recommendedAnimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedAnimes);
}

 final  List<MediaCharacter> _characters;
@override@MediaCharacterConverter() List<MediaCharacter> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}


/// Create a copy of ShikimoriAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShikimoriAnimeDetailsModelCopyWith<_ShikimoriAnimeDetailsModel> get copyWith => __$ShikimoriAnimeDetailsModelCopyWithImpl<_ShikimoriAnimeDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShikimoriAnimeDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShikimoriAnimeDetailsModel&&(identical(other.mediaListEntry, mediaListEntry) || other.mediaListEntry == mediaListEntry)&&const DeepCollectionEquality().equals(other._recommendedAnimes, _recommendedAnimes)&&const DeepCollectionEquality().equals(other._characters, _characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaListEntry,const DeepCollectionEquality().hash(_recommendedAnimes),const DeepCollectionEquality().hash(_characters));

@override
String toString() {
  return 'ShikimoriAnimeDetailsModel(mediaListEntry: $mediaListEntry, recommendedAnimes: $recommendedAnimes, characters: $characters)';
}


}

/// @nodoc
abstract mixin class _$ShikimoriAnimeDetailsModelCopyWith<$Res> implements $ShikimoriAnimeDetailsModelCopyWith<$Res> {
  factory _$ShikimoriAnimeDetailsModelCopyWith(_ShikimoriAnimeDetailsModel value, $Res Function(_ShikimoriAnimeDetailsModel) _then) = __$ShikimoriAnimeDetailsModelCopyWithImpl;
@override @useResult
$Res call({
@MediaListEntryConverter() MediaListEntry mediaListEntry,@AnimeConverter() List<Anime> recommendedAnimes,@MediaCharacterConverter() List<MediaCharacter> characters
});




}
/// @nodoc
class __$ShikimoriAnimeDetailsModelCopyWithImpl<$Res>
    implements _$ShikimoriAnimeDetailsModelCopyWith<$Res> {
  __$ShikimoriAnimeDetailsModelCopyWithImpl(this._self, this._then);

  final _ShikimoriAnimeDetailsModel _self;
  final $Res Function(_ShikimoriAnimeDetailsModel) _then;

/// Create a copy of ShikimoriAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaListEntry = null,Object? recommendedAnimes = null,Object? characters = null,}) {
  return _then(_ShikimoriAnimeDetailsModel(
mediaListEntry: null == mediaListEntry ? _self.mediaListEntry : mediaListEntry // ignore: cast_nullable_to_non_nullable
as MediaListEntry,recommendedAnimes: null == recommendedAnimes ? _self._recommendedAnimes : recommendedAnimes // ignore: cast_nullable_to_non_nullable
as List<Anime>,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<MediaCharacter>,
  ));
}


}

// dart format on
