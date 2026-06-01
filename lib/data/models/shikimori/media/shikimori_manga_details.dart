// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

// Internal dependencies
import 'package:unyo/domain/entities/list/media_list_entry.dart';
import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/media/manga_details.dart';
import 'package:unyo/domain/entities/media/media_character.dart';

part 'shikimori_manga_details.freezed.dart';
part 'shikimori_manga_details.g.dart';

@freezed
abstract class ShikimoriMangaDetailsModel
    with _$ShikimoriMangaDetailsModel
    implements MangaDetails {
  const factory ShikimoriMangaDetailsModel({
    @MediaListEntryConverter() required MediaListEntry mediaListEntry,
    @MangaConverter() required List<Manga> recommendedMangas,
    @MediaCharacterConverter() required List<MediaCharacter> characters,
  }) = _ShikimoriMangaDetailsModel;

  factory ShikimoriMangaDetailsModel.empty() => ShikimoriMangaDetailsModel(
    mediaListEntry: MediaListEntryModel.empty(),
    recommendedMangas: [],
    characters: [],
  );

  factory ShikimoriMangaDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ShikimoriMangaDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$ShikimoriMangaDetailsModelToJson(this as _ShikimoriMangaDetailsModel);

  // factory ShikimoriMangaDetailsModel.fromDetailsEntry(
  //     ShikimoriMangaDetailsGraphqlManga entry,) {
  //   final recommendedMangas = <Manga>[];
  //   for (final related in entry.related) {
  //     recommendedMangas.add(
  //       ShikimoriMangaModel.fromRelatedEntry(related.anime),
  //     );
  //   }
  //
  //   final characters = entry.characterRoles
  //       .map((role) => ShikimoriMediaCharacterModel.fromMangaCharacterRole(role))
  //       .toList();
  //
  //   return ShikimoriMangaDetailsModel(
  //     mediaListEntry: MediaListEntryModel.empty(),
  //     recommendedMangas: recommendedMangas,
  //     characters: characters,
  //   );
  // }
}
