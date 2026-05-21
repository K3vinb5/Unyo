import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/media_character.dart';
import 'package:unyo/domain/entities/list/media_list_entry.dart';

part 'anime_details.freezed.dart';
part 'anime_details.g.dart';

abstract class AnimeDetails {
  final MediaListEntry mediaListEntry;
  final List<Anime> recommendedAnimes;
  final List<MediaCharacter> characters;

  const AnimeDetails({required this.mediaListEntry, required this.recommendedAnimes, required this.characters});
}

@freezed
abstract class AnimeDetailsModel with _$AnimeDetailsModel implements AnimeDetails {
  const factory AnimeDetailsModel({
    @MediaListEntryConverter() required MediaListEntry mediaListEntry,
    @AnimeConverter() required List<Anime> recommendedAnimes,
    @MediaCharacterConverter() required List<MediaCharacter> characters,
  }) = _AnimeDetailsModel;

  factory AnimeDetailsModel.empty() => AnimeDetailsModel(
      mediaListEntry: MediaListEntryModel.empty(),
      recommendedAnimes: [],
      characters: []
  );

  factory AnimeDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AnimeDetailsModelToJson(this as _AnimeDetailsModel);
}

class AnimeDetailsConverter implements JsonConverter<AnimeDetails, Map<String, dynamic>> {
  const AnimeDetailsConverter();

  @override
  AnimeDetails fromJson(Map<String, dynamic> json) => AnimeDetailsModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(AnimeDetails object) =>
      (object as AnimeDetailsModel).toJson();
}
