// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anime.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnimeModel {

 int get id; int get idMal;@TitleConverter() Title get title; int get averageScore; String get bannerImage; String get countryOfOrigin; String get coverImage; String get description; int get duration; String get endDate; String get startDate; int get episodes; List<String> get genres; String get format; bool get isAdult; int get popularity; int get meanScore; String get season; bool get isFavourite; String get status;@AiringEpisodeConverter() AiringEpisode get nextAiringEpisode;
/// Create a copy of AnimeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimeModelCopyWith<AnimeModel> get copyWith => _$AnimeModelCopyWithImpl<AnimeModel>(this as AnimeModel, _$identity);

  /// Serializes this AnimeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.idMal, idMal) || other.idMal == idMal)&&(identical(other.title, title) || other.title == title)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.countryOfOrigin, countryOfOrigin) || other.countryOfOrigin == countryOfOrigin)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.description, description) || other.description == description)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.episodes, episodes) || other.episodes == episodes)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.format, format) || other.format == format)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.meanScore, meanScore) || other.meanScore == meanScore)&&(identical(other.season, season) || other.season == season)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextAiringEpisode, nextAiringEpisode) || other.nextAiringEpisode == nextAiringEpisode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,idMal,title,averageScore,bannerImage,countryOfOrigin,coverImage,description,duration,endDate,startDate,episodes,const DeepCollectionEquality().hash(genres),format,isAdult,popularity,meanScore,season,isFavourite,status,nextAiringEpisode]);



}

/// @nodoc
abstract mixin class $AnimeModelCopyWith<$Res>  {
  factory $AnimeModelCopyWith(AnimeModel value, $Res Function(AnimeModel) _then) = _$AnimeModelCopyWithImpl;
@useResult
$Res call({
 int id, int idMal,@TitleConverter() Title title, int averageScore, String bannerImage, String countryOfOrigin, String coverImage, String description, int duration, String endDate, String startDate, int episodes, List<String> genres, String format, bool isAdult, int popularity, int meanScore, String season, bool isFavourite, String status,@AiringEpisodeConverter() AiringEpisode nextAiringEpisode
});




}
/// @nodoc
class _$AnimeModelCopyWithImpl<$Res>
    implements $AnimeModelCopyWith<$Res> {
  _$AnimeModelCopyWithImpl(this._self, this._then);

  final AnimeModel _self;
  final $Res Function(AnimeModel) _then;

/// Create a copy of AnimeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? idMal = null,Object? title = null,Object? averageScore = null,Object? bannerImage = null,Object? countryOfOrigin = null,Object? coverImage = null,Object? description = null,Object? duration = null,Object? endDate = null,Object? startDate = null,Object? episodes = null,Object? genres = null,Object? format = null,Object? isAdult = null,Object? popularity = null,Object? meanScore = null,Object? season = null,Object? isFavourite = null,Object? status = null,Object? nextAiringEpisode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idMal: null == idMal ? _self.idMal : idMal // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Title,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as int,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,countryOfOrigin: null == countryOfOrigin ? _self.countryOfOrigin : countryOfOrigin // ignore: cast_nullable_to_non_nullable
as String,coverImage: null == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,isAdult: null == isAdult ? _self.isAdult : isAdult // ignore: cast_nullable_to_non_nullable
as bool,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as int,meanScore: null == meanScore ? _self.meanScore : meanScore // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,nextAiringEpisode: null == nextAiringEpisode ? _self.nextAiringEpisode : nextAiringEpisode // ignore: cast_nullable_to_non_nullable
as AiringEpisode,
  ));
}

}


/// Adds pattern-matching-related methods to [AnimeModel].
extension AnimeModelPatterns on AnimeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnimeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnimeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnimeModel value)  $default,){
final _that = this;
switch (_that) {
case _AnimeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnimeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnimeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int idMal, @TitleConverter()  Title title,  int averageScore,  String bannerImage,  String countryOfOrigin,  String coverImage,  String description,  int duration,  String endDate,  String startDate,  int episodes,  List<String> genres,  String format,  bool isAdult,  int popularity,  int meanScore,  String season,  bool isFavourite,  String status, @AiringEpisodeConverter()  AiringEpisode nextAiringEpisode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnimeModel() when $default != null:
return $default(_that.id,_that.idMal,_that.title,_that.averageScore,_that.bannerImage,_that.countryOfOrigin,_that.coverImage,_that.description,_that.duration,_that.endDate,_that.startDate,_that.episodes,_that.genres,_that.format,_that.isAdult,_that.popularity,_that.meanScore,_that.season,_that.isFavourite,_that.status,_that.nextAiringEpisode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int idMal, @TitleConverter()  Title title,  int averageScore,  String bannerImage,  String countryOfOrigin,  String coverImage,  String description,  int duration,  String endDate,  String startDate,  int episodes,  List<String> genres,  String format,  bool isAdult,  int popularity,  int meanScore,  String season,  bool isFavourite,  String status, @AiringEpisodeConverter()  AiringEpisode nextAiringEpisode)  $default,) {final _that = this;
switch (_that) {
case _AnimeModel():
return $default(_that.id,_that.idMal,_that.title,_that.averageScore,_that.bannerImage,_that.countryOfOrigin,_that.coverImage,_that.description,_that.duration,_that.endDate,_that.startDate,_that.episodes,_that.genres,_that.format,_that.isAdult,_that.popularity,_that.meanScore,_that.season,_that.isFavourite,_that.status,_that.nextAiringEpisode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int idMal, @TitleConverter()  Title title,  int averageScore,  String bannerImage,  String countryOfOrigin,  String coverImage,  String description,  int duration,  String endDate,  String startDate,  int episodes,  List<String> genres,  String format,  bool isAdult,  int popularity,  int meanScore,  String season,  bool isFavourite,  String status, @AiringEpisodeConverter()  AiringEpisode nextAiringEpisode)?  $default,) {final _that = this;
switch (_that) {
case _AnimeModel() when $default != null:
return $default(_that.id,_that.idMal,_that.title,_that.averageScore,_that.bannerImage,_that.countryOfOrigin,_that.coverImage,_that.description,_that.duration,_that.endDate,_that.startDate,_that.episodes,_that.genres,_that.format,_that.isAdult,_that.popularity,_that.meanScore,_that.season,_that.isFavourite,_that.status,_that.nextAiringEpisode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnimeModel implements AnimeModel {
  const _AnimeModel({required this.id, required this.idMal, @TitleConverter() required this.title, required this.averageScore, required this.bannerImage, required this.countryOfOrigin, required this.coverImage, required this.description, required this.duration, required this.endDate, required this.startDate, required this.episodes, required final  List<String> genres, required this.format, required this.isAdult, required this.popularity, required this.meanScore, required this.season, required this.isFavourite, required this.status, @AiringEpisodeConverter() required this.nextAiringEpisode}): _genres = genres;
  factory _AnimeModel.fromJson(Map<String, dynamic> json) => _$AnimeModelFromJson(json);

@override final  int id;
@override final  int idMal;
@override@TitleConverter() final  Title title;
@override final  int averageScore;
@override final  String bannerImage;
@override final  String countryOfOrigin;
@override final  String coverImage;
@override final  String description;
@override final  int duration;
@override final  String endDate;
@override final  String startDate;
@override final  int episodes;
 final  List<String> _genres;
@override List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override final  String format;
@override final  bool isAdult;
@override final  int popularity;
@override final  int meanScore;
@override final  String season;
@override final  bool isFavourite;
@override final  String status;
@override@AiringEpisodeConverter() final  AiringEpisode nextAiringEpisode;

/// Create a copy of AnimeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnimeModelCopyWith<_AnimeModel> get copyWith => __$AnimeModelCopyWithImpl<_AnimeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnimeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnimeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.idMal, idMal) || other.idMal == idMal)&&(identical(other.title, title) || other.title == title)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.countryOfOrigin, countryOfOrigin) || other.countryOfOrigin == countryOfOrigin)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.description, description) || other.description == description)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.episodes, episodes) || other.episodes == episodes)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.format, format) || other.format == format)&&(identical(other.isAdult, isAdult) || other.isAdult == isAdult)&&(identical(other.popularity, popularity) || other.popularity == popularity)&&(identical(other.meanScore, meanScore) || other.meanScore == meanScore)&&(identical(other.season, season) || other.season == season)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextAiringEpisode, nextAiringEpisode) || other.nextAiringEpisode == nextAiringEpisode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,idMal,title,averageScore,bannerImage,countryOfOrigin,coverImage,description,duration,endDate,startDate,episodes,const DeepCollectionEquality().hash(_genres),format,isAdult,popularity,meanScore,season,isFavourite,status,nextAiringEpisode]);



}

/// @nodoc
abstract mixin class _$AnimeModelCopyWith<$Res> implements $AnimeModelCopyWith<$Res> {
  factory _$AnimeModelCopyWith(_AnimeModel value, $Res Function(_AnimeModel) _then) = __$AnimeModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int idMal,@TitleConverter() Title title, int averageScore, String bannerImage, String countryOfOrigin, String coverImage, String description, int duration, String endDate, String startDate, int episodes, List<String> genres, String format, bool isAdult, int popularity, int meanScore, String season, bool isFavourite, String status,@AiringEpisodeConverter() AiringEpisode nextAiringEpisode
});




}
/// @nodoc
class __$AnimeModelCopyWithImpl<$Res>
    implements _$AnimeModelCopyWith<$Res> {
  __$AnimeModelCopyWithImpl(this._self, this._then);

  final _AnimeModel _self;
  final $Res Function(_AnimeModel) _then;

/// Create a copy of AnimeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? idMal = null,Object? title = null,Object? averageScore = null,Object? bannerImage = null,Object? countryOfOrigin = null,Object? coverImage = null,Object? description = null,Object? duration = null,Object? endDate = null,Object? startDate = null,Object? episodes = null,Object? genres = null,Object? format = null,Object? isAdult = null,Object? popularity = null,Object? meanScore = null,Object? season = null,Object? isFavourite = null,Object? status = null,Object? nextAiringEpisode = null,}) {
  return _then(_AnimeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,idMal: null == idMal ? _self.idMal : idMal // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as Title,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as int,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,countryOfOrigin: null == countryOfOrigin ? _self.countryOfOrigin : countryOfOrigin // ignore: cast_nullable_to_non_nullable
as String,coverImage: null == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,isAdult: null == isAdult ? _self.isAdult : isAdult // ignore: cast_nullable_to_non_nullable
as bool,popularity: null == popularity ? _self.popularity : popularity // ignore: cast_nullable_to_non_nullable
as int,meanScore: null == meanScore ? _self.meanScore : meanScore // ignore: cast_nullable_to_non_nullable
as int,season: null == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,nextAiringEpisode: null == nextAiringEpisode ? _self.nextAiringEpisode : nextAiringEpisode // ignore: cast_nullable_to_non_nullable
as AiringEpisode,
  ));
}


}

// dart format on
