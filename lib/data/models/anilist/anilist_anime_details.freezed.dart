// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anilist_anime_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnilistAnimeDetailsModel {

@HiveField(0)@MediaListEntryConverter() MediaListEntry get mediaListEntry;@HiveField(1)@AnimeConverter() List<Anime> get recommendedAnimes;@HiveField(2)@MediaCharacterConverter() List<MediaCharacter> get characters;
/// Create a copy of AnilistAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnilistAnimeDetailsModelCopyWith<AnilistAnimeDetailsModel> get copyWith => _$AnilistAnimeDetailsModelCopyWithImpl<AnilistAnimeDetailsModel>(this as AnilistAnimeDetailsModel, _$identity);

  /// Serializes this AnilistAnimeDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnilistAnimeDetailsModel&&(identical(other.mediaListEntry, mediaListEntry) || other.mediaListEntry == mediaListEntry)&&const DeepCollectionEquality().equals(other.recommendedAnimes, recommendedAnimes)&&const DeepCollectionEquality().equals(other.characters, characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaListEntry,const DeepCollectionEquality().hash(recommendedAnimes),const DeepCollectionEquality().hash(characters));

@override
String toString() {
  return 'AnilistAnimeDetailsModel(mediaListEntry: $mediaListEntry, recommendedAnimes: $recommendedAnimes, characters: $characters)';
}


}

/// @nodoc
abstract mixin class $AnilistAnimeDetailsModelCopyWith<$Res>  {
  factory $AnilistAnimeDetailsModelCopyWith(AnilistAnimeDetailsModel value, $Res Function(AnilistAnimeDetailsModel) _then) = _$AnilistAnimeDetailsModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0)@MediaListEntryConverter() MediaListEntry mediaListEntry,@HiveField(1)@AnimeConverter() List<Anime> recommendedAnimes,@HiveField(2)@MediaCharacterConverter() List<MediaCharacter> characters
});




}
/// @nodoc
class _$AnilistAnimeDetailsModelCopyWithImpl<$Res>
    implements $AnilistAnimeDetailsModelCopyWith<$Res> {
  _$AnilistAnimeDetailsModelCopyWithImpl(this._self, this._then);

  final AnilistAnimeDetailsModel _self;
  final $Res Function(AnilistAnimeDetailsModel) _then;

/// Create a copy of AnilistAnimeDetailsModel
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


/// Adds pattern-matching-related methods to [AnilistAnimeDetailsModel].
extension AnilistAnimeDetailsModelPatterns on AnilistAnimeDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnilistAnimeDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnilistAnimeDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnilistAnimeDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)@MediaListEntryConverter()  MediaListEntry mediaListEntry, @HiveField(1)@AnimeConverter()  List<Anime> recommendedAnimes, @HiveField(2)@MediaCharacterConverter()  List<MediaCharacter> characters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)@MediaListEntryConverter()  MediaListEntry mediaListEntry, @HiveField(1)@AnimeConverter()  List<Anime> recommendedAnimes, @HiveField(2)@MediaCharacterConverter()  List<MediaCharacter> characters)  $default,) {final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)@MediaListEntryConverter()  MediaListEntry mediaListEntry, @HiveField(1)@AnimeConverter()  List<Anime> recommendedAnimes, @HiveField(2)@MediaCharacterConverter()  List<MediaCharacter> characters)?  $default,) {final _that = this;
switch (_that) {
case _AnilistAnimeDetailsModel() when $default != null:
return $default(_that.mediaListEntry,_that.recommendedAnimes,_that.characters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnilistAnimeDetailsModel implements AnilistAnimeDetailsModel {
  const _AnilistAnimeDetailsModel({@HiveField(0)@MediaListEntryConverter() required this.mediaListEntry, @HiveField(1)@AnimeConverter() required final  List<Anime> recommendedAnimes, @HiveField(2)@MediaCharacterConverter() required final  List<MediaCharacter> characters}): _recommendedAnimes = recommendedAnimes,_characters = characters;
  factory _AnilistAnimeDetailsModel.fromJson(Map<String, dynamic> json) => _$AnilistAnimeDetailsModelFromJson(json);

@override@HiveField(0)@MediaListEntryConverter() final  MediaListEntry mediaListEntry;
 final  List<Anime> _recommendedAnimes;
@override@HiveField(1)@AnimeConverter() List<Anime> get recommendedAnimes {
  if (_recommendedAnimes is EqualUnmodifiableListView) return _recommendedAnimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendedAnimes);
}

 final  List<MediaCharacter> _characters;
@override@HiveField(2)@MediaCharacterConverter() List<MediaCharacter> get characters {
  if (_characters is EqualUnmodifiableListView) return _characters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_characters);
}


/// Create a copy of AnilistAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnilistAnimeDetailsModelCopyWith<_AnilistAnimeDetailsModel> get copyWith => __$AnilistAnimeDetailsModelCopyWithImpl<_AnilistAnimeDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnilistAnimeDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnilistAnimeDetailsModel&&(identical(other.mediaListEntry, mediaListEntry) || other.mediaListEntry == mediaListEntry)&&const DeepCollectionEquality().equals(other._recommendedAnimes, _recommendedAnimes)&&const DeepCollectionEquality().equals(other._characters, _characters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaListEntry,const DeepCollectionEquality().hash(_recommendedAnimes),const DeepCollectionEquality().hash(_characters));

@override
String toString() {
  return 'AnilistAnimeDetailsModel(mediaListEntry: $mediaListEntry, recommendedAnimes: $recommendedAnimes, characters: $characters)';
}


}

/// @nodoc
abstract mixin class _$AnilistAnimeDetailsModelCopyWith<$Res> implements $AnilistAnimeDetailsModelCopyWith<$Res> {
  factory _$AnilistAnimeDetailsModelCopyWith(_AnilistAnimeDetailsModel value, $Res Function(_AnilistAnimeDetailsModel) _then) = __$AnilistAnimeDetailsModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0)@MediaListEntryConverter() MediaListEntry mediaListEntry,@HiveField(1)@AnimeConverter() List<Anime> recommendedAnimes,@HiveField(2)@MediaCharacterConverter() List<MediaCharacter> characters
});




}
/// @nodoc
class __$AnilistAnimeDetailsModelCopyWithImpl<$Res>
    implements _$AnilistAnimeDetailsModelCopyWith<$Res> {
  __$AnilistAnimeDetailsModelCopyWithImpl(this._self, this._then);

  final _AnilistAnimeDetailsModel _self;
  final $Res Function(_AnilistAnimeDetailsModel) _then;

/// Create a copy of AnilistAnimeDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaListEntry = null,Object? recommendedAnimes = null,Object? characters = null,}) {
  return _then(_AnilistAnimeDetailsModel(
mediaListEntry: null == mediaListEntry ? _self.mediaListEntry : mediaListEntry // ignore: cast_nullable_to_non_nullable
as MediaListEntry,recommendedAnimes: null == recommendedAnimes ? _self._recommendedAnimes : recommendedAnimes // ignore: cast_nullable_to_non_nullable
as List<Anime>,characters: null == characters ? _self._characters : characters // ignore: cast_nullable_to_non_nullable
as List<MediaCharacter>,
  ));
}


}

// dart format on
