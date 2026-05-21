// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnimeDetailsModel _$AnimeDetailsModelFromJson(
  Map<String, dynamic> json,
) => _AnimeDetailsModel(
  mediaListEntry: const MediaListEntryConverter().fromJson(
    json['mediaListEntry'] as Map<String, dynamic>,
  ),
  recommendedAnimes: (json['recommendedAnimes'] as List<dynamic>)
      .map((e) => const AnimeConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  characters: (json['characters'] as List<dynamic>)
      .map(
        (e) =>
            const MediaCharacterConverter().fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$AnimeDetailsModelToJson(_AnimeDetailsModel instance) =>
    <String, dynamic>{
      'mediaListEntry': const MediaListEntryConverter().toJson(
        instance.mediaListEntry,
      ),
      'recommendedAnimes': instance.recommendedAnimes
          .map(const AnimeConverter().toJson)
          .toList(),
      'characters': instance.characters
          .map(const MediaCharacterConverter().toJson)
          .toList(),
    };
