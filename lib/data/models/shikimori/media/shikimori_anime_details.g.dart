// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shikimori_anime_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShikimoriAnimeDetailsModel _$ShikimoriAnimeDetailsModelFromJson(
  Map<String, dynamic> json,
) => _ShikimoriAnimeDetailsModel(
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

Map<String, dynamic> _$ShikimoriAnimeDetailsModelToJson(
  _ShikimoriAnimeDetailsModel instance,
) => <String, dynamic>{
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
