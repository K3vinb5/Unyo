// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anilist_manga_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnilistMangaModel _$AnilistMangaModelFromJson(
  Map<String, dynamic> json,
) => _AnilistMangaModel(
  id: (json['id'] as num).toInt(),
  idMal: (json['idMal'] as num).toInt(),
  title: const TitleConverter().fromJson(json['title'] as Map<String, dynamic>),
  averageScore: (json['averageScore'] as num).toInt(),
  bannerImage: json['bannerImage'] as String,
  countryOfOrigin: json['countryOfOrigin'] as String,
  coverImage: json['coverImage'] as String,
  description: json['description'] as String,
  duration: (json['duration'] as num).toInt(),
  endDate: json['endDate'] as String,
  startDate: json['startDate'] as String,
  chapters: (json['chapters'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  format: json['format'] as String,
  isAdult: json['isAdult'] as bool,
  popularity: (json['popularity'] as num).toInt(),
  meanScore: (json['meanScore'] as num).toInt(),
  status: json['status'] as String,
  isFavourite: json['isFavourite'] as bool,
);

Map<String, dynamic> _$AnilistMangaModelToJson(_AnilistMangaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idMal': instance.idMal,
      'title': const TitleConverter().toJson(instance.title),
      'averageScore': instance.averageScore,
      'bannerImage': instance.bannerImage,
      'countryOfOrigin': instance.countryOfOrigin,
      'coverImage': instance.coverImage,
      'description': instance.description,
      'duration': instance.duration,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'chapters': instance.chapters,
      'genres': instance.genres,
      'format': instance.format,
      'isAdult': instance.isAdult,
      'popularity': instance.popularity,
      'meanScore': instance.meanScore,
      'status': instance.status,
      'isFavourite': instance.isFavourite,
    };
