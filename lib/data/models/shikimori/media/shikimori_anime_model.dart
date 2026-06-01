// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

// Internal dependencies
import 'package:unyo/domain/entities/media/airing_episode.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/title.dart';

part 'shikimori_anime_model.freezed.dart';
part 'shikimori_anime_model.g.dart';

@freezed
abstract class ShikimoriAnimeModel with _$ShikimoriAnimeModel implements Anime {
  const ShikimoriAnimeModel._();

  factory ShikimoriAnimeModel({
    required int id,
    required int idMal,
    @TitleConverter() required Title title,
    required int averageScore,
    required String bannerImage,
    required String countryOfOrigin,
    required String coverImage,
    required String description,
    required int duration,
    required String endDate,
    required String startDate,
    required int episodes,
    required List<String> genres,
    required String format,
    required bool isAdult,
    required int popularity,
    required int meanScore,
    required String season,
    required String status,
    required bool isFavourite,
    @AiringEpisodeConverter() required AiringEpisode nextAiringEpisode,
  }) = _ShikimoriAnimeModel;

  factory ShikimoriAnimeModel.fromJson(Map<String, dynamic> json) =>
      _$ShikimoriAnimeModelFromJson(json);

  // factory ShikimoriAnimeModel.fromListEntry(
  //     ShikimoriAnimeListGraphqlAnimes entry,) {
  //   return ShikimoriAnimeModel(
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
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: '',
  //     duration: entry.duration,
  //     endDate: _formatIncompleteDate(entry.releasedOn),
  //     startDate: _formatIncompleteDate(entry.airedOn),
  //     episodes: entry.episodes,
  //     genres: entry.genres.map((g) => g.name).toList(),
  //     format: _mapKindToFormat(entry.kind),
  //     isAdult: entry.rating == 'rx' || !entry.isCensored,
  //     popularity: 0,
  //     meanScore: (entry.score * 10).round(),
  //     season: entry.season,
  //     status: _mapStatusToAnilist(entry.status),
  //     isFavourite: false,
  //     nextAiringEpisode: AiringEpisodeModel(
  //       episode: entry.episodesAired,
  //       airingAt: entry.nextEpisodeAt is String ? entry.nextEpisodeAt as String : '',
  //     ),
  //   );
  // }

  // factory ShikimoriAnimeModel.fromDetailsEntry(
  //     ShikimoriAnimeDetailsGraphqlAnime entry,) {
  //   return ShikimoriAnimeModel(
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
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: entry.description,
  //     duration: entry.duration,
  //     endDate: _formatIncompleteDate(entry.releasedOn),
  //     startDate: _formatIncompleteDate(entry.airedOn),
  //     episodes: entry.episodes,
  //     genres: entry.genres.map((g) => g.name).toList(),
  //     format: _mapKindToFormat(entry.kind),
  //     isAdult: entry.rating == 'rx' || !entry.isCensored,
  //     popularity: entry.scoresStats.fold(0, (sum, s) => sum + s.count),
  //     meanScore: (entry.score * 10).round(),
  //     season: entry.season,
  //     status: _mapStatusToAnilist(entry.status),
  //     isFavourite: false,
  //     nextAiringEpisode: AiringEpisodeModel(
  //       episode: entry.episodesAired,
  //       airingAt: entry.nextEpisodeAt is String ? entry.nextEpisodeAt as String : '',
  //     ),
  //   );
  // }

  // factory ShikimoriAnimeModel.fromRelatedEntry(
  //     ShikimoriAnimeDetailsGraphqlAnimeRelatedAnime entry,) {
  //   return ShikimoriAnimeModel(
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
  //     countryOfOrigin: 'JP',
  //     coverImage: entry.poster.mainUrl,
  //     description: '',
  //     duration: 0,
  //     endDate: '',
  //     startDate: '',
  //     episodes: entry.episodes,
  //     genres: [],
  //     format: _mapKindToFormat(entry.kind),
  //     isAdult: false,
  //     popularity: 0,
  //     meanScore: 0,
  //     season: '',
  //     status: 'FINISHED',
  //     isFavourite: false,
  //     nextAiringEpisode: AiringEpisodeModel.empty(),
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

String _mapKindToFormat(String kind) {
  switch (kind) {
    case 'tv':
      return 'TV';
    case 'movie':
      return 'MOVIE';
    case 'ova':
      return 'OVA';
    case 'ona':
      return 'ONA';
    case 'special':
      return 'SPECIAL';
    case 'tv_special':
      return 'TV_SHORT';
    case 'music':
      return 'MUSIC';
    case 'pv':
      return 'MUSIC';
    case 'cm':
      return 'SPECIAL';
    default:
      return kind.toUpperCase();
  }
}

String _mapStatusToAnilist(String status) {
  switch (status) {
    case 'anons':
      return 'NOT_YET_RELEASED';
    case 'ongoing':
      return 'RELEASING';
    case 'released':
      return 'FINISHED';
    default:
      return status.toUpperCase();
  }
}
