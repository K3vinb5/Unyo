// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

// Internal dependencies
import 'package:unyo/domain/entities/list/media_list_entry.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/anime_details.dart';
import 'package:unyo/domain/entities/media/media_character.dart';

part 'shikimori_anime_details.freezed.dart';
part 'shikimori_anime_details.g.dart';

@freezed
abstract class ShikimoriAnimeDetailsModel
    with _$ShikimoriAnimeDetailsModel
    implements AnimeDetails {
  const factory ShikimoriAnimeDetailsModel({
    @MediaListEntryConverter() required MediaListEntry mediaListEntry,
    @AnimeConverter() required List<Anime> recommendedAnimes,
    @MediaCharacterConverter() required List<MediaCharacter> characters,
  }) = _ShikimoriAnimeDetailsModel;

  factory ShikimoriAnimeDetailsModel.empty() => ShikimoriAnimeDetailsModel(
    mediaListEntry: MediaListEntryModel.empty(),
    recommendedAnimes: [],
    characters: [],
  );

  factory ShikimoriAnimeDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShikimoriAnimeDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ShikimoriAnimeDetailsModelToJson(this as _ShikimoriAnimeDetailsModel);

  // factory ShikimoriAnimeDetailsModel.fromDetailsEntry(
  //     ShikimoriAnimeDetailsGraphqlAnime entry,) {
  //   final recommendedAnimes = <Anime>[];
  //   for (final related in entry.related) {
  //     recommendedAnimes.add(
  //       ShikimoriAnimeModel.fromRelatedEntry(related.anime),
  //     );
  //   }
  //
  //   final characters = entry.characterRoles
  //       .map((role) => ShikimoriMediaCharacterModel.fromCharacterRole(role))
  //       .toList();
  //
  //   return ShikimoriAnimeDetailsModel(
  //     mediaListEntry: MediaListEntryModel.empty(),
  //     recommendedAnimes: recommendedAnimes,
  //     characters: characters,
  //   );
  // }
}
