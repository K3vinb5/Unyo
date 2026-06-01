// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

// Internal dependencies
import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/media/title.dart';

part 'shikimori_manga_model.freezed.dart';
part 'shikimori_manga_model.g.dart';

@freezed
abstract class ShikimoriMangaModel with _$ShikimoriMangaModel implements Manga {
  const ShikimoriMangaModel._();

  factory ShikimoriMangaModel({
    required int id,
    required int idMal,
    @TitleConverter() required Title title,
    required int averageScore,
    required String bannerImage,
    required int chapters,
    required String countryOfOrigin,
    required String coverImage,
    required String description,
    required String endDate,
    required String startDate,
    required List<String> genres,
    required String format,
    required bool isAdult,
    required int popularity,
    required int meanScore,
    required String status,
    required bool isFavourite,
  }) = _ShikimoriMangaModel;

  factory ShikimoriMangaModel.fromJson(Map<String, dynamic> json) =>
      _$ShikimoriMangaModelFromJson(json);

  // factory ShikimoriMangaModel.fromListEntry(
  //     ShikimoriMangaListGraphqlMangas entry,) {
  //   return ShikimoriMangaModel(
  //     id: int.parse(entry.id),
  //     idMal: int.tryParse(entry.malId) ?? -1,
  //     title: TitleModel(
  //       romaji: entry.name,
  //       english: entry.english,
  //       userPreferred: entry.name,
  //       nativeTitle: entry.japanese,
  //     ),
  //     averageScore: (entry.score * 10).round(),
  //     bannerImage: entry.poster.originalUrl,
  //     chapters: entry.chapters,
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: '',
  //     endDate: _formatIncompleteDate(entry.releasedOn),
  //     startDate: _formatIncompleteDate(entry.airedOn),
  //     genres: entry.genres.map((g) => g.name).toList(),
  //     format: _mapMangaKindToFormat(entry.kind),
  //     isAdult: !entry.isCensored,
  //     popularity: 0,
  //     meanScore: (entry.score * 10).round(),
  //     status: _mapMangaStatusToAnilist(entry.status),
  //     isFavourite: false,
  //   );
  // }

  // factory ShikimoriMangaModel.fromDetailsEntry(
  //     ShikimoriMangaDetailsGraphqlManga entry,) {
  //   return ShikimoriMangaModel(
  //     id: int.parse(entry.id),
  //     idMal: int.tryParse(entry.malId) ?? -1,
  //     title: TitleModel(
  //       romaji: entry.name,
  //       english: entry.english,
  //       userPreferred: entry.name,
  //       nativeTitle: entry.japanese,
  //     ),
  //     averageScore: (entry.score * 10).round(),
  //     bannerImage: entry.poster.originalUrl,
  //     chapters: entry.chapters,
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: entry.description,
  //     endDate: _formatIncompleteDate(entry.releasedOn),
  //     startDate: _formatIncompleteDate(entry.airedOn),
  //     genres: entry.genres.map((g) => g.name).toList(),
  //     format: _mapMangaKindToFormat(entry.kind),
  //     isAdult: !entry.isCensored,
  //     popularity: 0,
  //     meanScore: (entry.score * 10).round(),
  //     status: _mapMangaStatusToAnilist(entry.status),
  //     isFavourite: false,
  //   );
  // }

  // factory ShikimoriMangaModel.fromRelatedEntry(
  //     ShikimoriMangaDetailsGraphqlMangaRelatedAnime entry,) {
  //   return ShikimoriMangaModel(
  //     id: int.parse(entry.id),
  //     idMal: -1,
  //     title: TitleModel(
  //       romaji: entry.name,
  //       english: '',
  //       userPreferred: entry.name,
  //       nativeTitle: '',
  //     ),
  //     averageScore: 0,
  //     bannerImage: entry.poster.mainUrl,
  //     chapters: entry.episodes,
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: '',
  //     endDate: '',
  //     startDate: '',
  //     genres: [],
  //     format: _mapMangaKindToFormat(entry.kind),
  //     isAdult: false,
  //     popularity: 0,
  //     meanScore: 0,
  //     status: 'FINISHED',
  //     isFavourite: false,
  //   );
  // }

}

String _formatIncompleteDate(dynamic dateObj) {
  if (dateObj == null) return '';
  final year = dateObj.year;
  final month = dateObj.month;
  final day = dateObj.day;
  if (year == 0 && month == 0 && day == 0) return '';
  final parts = <String>[];
  if (day > 0) parts.add(day.toString().padLeft(2, '0'));
  if (month > 0) parts.add(month.toString().padLeft(2, '0'));
  if (year > 0) parts.add(year.toString());
  return parts.join('/');
}

String _mapMangaKindToFormat(String kind) {
  switch (kind) {
    case 'manga':
      return 'MANGA';
    case 'manhwa':
      return 'MANHWA';
    case 'manhua':
      return 'MANHUA';
    case 'light_novel':
      return 'NOVEL';
    case 'novel':
      return 'NOVEL';
    case 'one_shot':
      return 'ONE_SHOT';
    case 'doujin':
      return 'DOUJINSHI';
    default:
      return kind.toUpperCase();
  }
}

String _mapMangaStatusToAnilist(String status) {
  switch (status) {
    case 'anons':
      return 'NOT_YET_RELEASED';
    case 'ongoing':
      return 'RELEASING';
    case 'released':
      return 'FINISHED';
    case 'paused':
      return 'HIATUS';
    case 'discontinued':
      return 'CANCELLED';
    default:
      return status.toUpperCase();
  }
}
