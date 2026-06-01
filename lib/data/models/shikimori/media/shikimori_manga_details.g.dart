// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shikimori_manga_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShikimoriMangaDetailsModel _$ShikimoriMangaDetailsModelFromJson(
  Map<String, dynamic> json,
) => _ShikimoriMangaDetailsModel(
  mediaListEntry: const MediaListEntryConverter().fromJson(
    json['mediaListEntry'] as Map<String, dynamic>,
  ),
  recommendedMangas: (json['recommendedMangas'] as List<dynamic>)
      .map((e) => const MangaConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  characters: (json['characters'] as List<dynamic>)
      .map(
        (e) =>
            const MediaCharacterConverter().fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ShikimoriMangaDetailsModelToJson(
  _ShikimoriMangaDetailsModel instance,
) => <String, dynamic>{
  'mediaListEntry': const MediaListEntryConverter().toJson(
    instance.mediaListEntry,
  ),
  'recommendedMangas': instance.recommendedMangas
      .map(const MangaConverter().toJson)
      .toList(),
  'characters': instance.characters
      .map(const MediaCharacterConverter().toJson)
      .toList(),
};
