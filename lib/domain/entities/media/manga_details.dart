import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/media/media_character.dart';

import 'package:unyo/domain/entities/list/media_list_entry.dart';

part 'manga_details.freezed.dart';
part 'manga_details.g.dart';

abstract class MangaDetails {
  final MediaListEntry mediaListEntry;
  final List<Manga> recommendedMangas;
  final List<MediaCharacter> characters;

  const MangaDetails({required this.mediaListEntry, required this.recommendedMangas, required this.characters});
}

@freezed
abstract class MangaDetailsModel with _$MangaDetailsModel implements MangaDetails {
  const factory MangaDetailsModel({
    @MediaListEntryConverter() required MediaListEntry mediaListEntry,
    @MangaConverter() required List<Manga> recommendedMangas,
    @MediaCharacterConverter() required List<MediaCharacter> characters,
  }) = _MangaDetailsModel;

  factory MangaDetailsModel.empty() => MangaDetailsModel(
      mediaListEntry: MediaListEntryModel.empty(),
      recommendedMangas: [],
      characters: []
  );

  factory MangaDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MangaDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MangaDetailsModelToJson(this as _MangaDetailsModel);
}

class MangaDetailsConverter implements JsonConverter<MangaDetails, Map<String, dynamic>> {
  const MangaDetailsConverter();

  @override
  MangaDetails fromJson(Map<String, dynamic> json) => MangaDetailsModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(MangaDetails object) =>
      (object as MangaDetailsModel).toJson();
}
