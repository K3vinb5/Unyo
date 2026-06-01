// External dependencies
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

// Internal dependencies
import 'package:unyo/config/config.dart' as config;
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/services/api/graphql/graphql_service.dart';
import 'package:unyo/core/services/api/graphql/queries/shikimori_queries.dart' as shikimori_queries;
import 'package:unyo/data/repositories/repository_mixin.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/anime_details.dart';
import 'package:unyo/domain/entities/list/media_list_entry.dart';
import 'package:unyo/domain/entities/user/user.dart';
import 'package:unyo/domain/repositories/anime_repository.dart';

class AnimeRepositoryShikimori with RepositoryMixin implements AnimeRepository {
  final GraphQLService _shikimoriGraphQLService = sl<GraphQLService>(
    instanceName: config.shikimoriGraphQlService,
  );
  final Logger _logger = sl<Logger>();

  @override
  Future<(bool, AnimeDetails)> getAnimeDetails(Anime selectedAnime, User loggedUser) {
    // TODO: implement getAnimeDetails
    throw UnimplementedError();
  }

  @override
  Future<Map<String, List<Anime>>> getCalendarReleases(int page, User loggedUser) {
    // TODO: implement getCalendarReleases
    throw UnimplementedError();
  }

  // Daqui
  @override
  Future<(bool, List<Anime>)> getPopularAnimes(int page, User loggedUser, {bool ignoreCache = false}) {
    // TODO: implement getPopularAnimes
    throw UnimplementedError();
  }

  @override
  Future<(bool, List<Anime>)> getRecentlyCompletedAnimes(int page, User loggedUser, {bool ignoreCache = false}) {
    // TODO: implement getRecentlyCompletedAnimes
    throw UnimplementedError();
  }

  @override
  Future<(bool, List<Anime>)> getRecentlyReleasedAnimes(int page, User loggedUser, {bool ignoreCache = false}) {
    // TODO: implement getRecentlyReleasedAnimes
    throw UnimplementedError();
  }

  @override
  Future<(bool, List<Anime>)> getTrendingAnimes(int page, User loggedUser, {bool ignoreCache = false}) {
    // TODO: implement getTrendingAnimes
    throw UnimplementedError();
  }

  @override
  Future<(bool, List<Anime>)> getUpcomingAnimes(int page, User loggedUser, {bool ignoreCache = false}) {
    // TODO: implement getUpcomingAnimes
    throw UnimplementedError();
  }
  // Ate aqui
  @override
  Future<Map<String, (bool, List<String>)>> getUserAnimeAdvancedSearchFilters() {
    // TODO: implement getUserAnimeAdvancedSearchFilters
    throw UnimplementedError();
  }

  @override
  Future<List<Anime>> performAnimeAdvancedSearch(String query, List<String> selectedGenres, String? selectedSeason, String? selectedFormat, int? selectedYear, String? selectedAiringStatus, String sort, int page, User loggedUser) {
    // TODO: implement performAnimeAdvancedSearch
    throw UnimplementedError();
  }

  // @override
  // Future<(bool, List<Anime>)> getPopularAnimes(int page, User loggedUser, {bool ignoreCache = false}) async {
  //   _logger.i("Fetching Shikimori popular anime");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 31,
  //       "order": "popularity",
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //     ignoreCache: ignoreCache,
  //   );
  //   throwIfGraphQlError(response);
  //   final animes = _processPaginatedResponse(response.data.animes, 30);
  //   return (animes.$1, animes.$2.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList());
  // }

  // @override
  // Future<(bool, List<Anime>)> getTrendingAnimes(int page, User loggedUser, {bool ignoreCache = false}) async {
  //   _logger.i("Fetching Shikimori trending anime");
  //   // Shikimori doesn't have a native "trending" concept; use popularity as closest equivalent
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 31,
  //       "order": "popularity",
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //     ignoreCache: ignoreCache,
  //   );
  //   throwIfGraphQlError(response);
  //   final animes = _processPaginatedResponse(response.data.animes, 30);
  //   return (animes.$1, animes.$2.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList());
  // }

  // @override
  // Future<(bool, List<Anime>)> getRecentlyReleasedAnimes(int page, User loggedUser, {bool ignoreCache = false}) async {
  //   _logger.i("Fetching Shikimori recently released anime");
  //   final now = DateTime.now();
  //   final currentSeason = _getCurrentSeason(now);
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 31,
  //       "order": "aired_on",
  //       "status": "released",
  //       "season": currentSeason,
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //     ignoreCache: ignoreCache,
  //   );
  //   throwIfGraphQlError(response);
  //   final animes = _processPaginatedResponse(response.data.animes, 30);
  //   return (animes.$1, animes.$2.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList());
  // }

  // @override
  // Future<(bool, List<Anime>)> getRecentlyCompletedAnimes(int page, User loggedUser, {bool ignoreCache = false}) async {
  //   _logger.i("Fetching Shikimori recently completed anime");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 31,
  //       "order": "aired_on",
  //       "status": "released",
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //     ignoreCache: ignoreCache,
  //   );
  //   throwIfGraphQlError(response);
  //   final animes = _processPaginatedResponse(response.data.animes, 30);
  //   return (animes.$1, animes.$2.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList());
  // }

  // @override
  // Future<(bool, List<Anime>)> getUpcomingAnimes(int page, User loggedUser, {bool ignoreCache = false}) async {
  //   _logger.i("Fetching Shikimori upcoming anime");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 31,
  //       "order": "popularity",
  //       "status": "anons",
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //     ignoreCache: ignoreCache,
  //   );
  //   throwIfGraphQlError(response);
  //   final animes = _processPaginatedResponse(response.data.animes, 30);
  //   return (animes.$1, animes.$2.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList());
  // }

  // @override
  // Future<Map<String, List<Anime>>> getCalendarReleases(int page, User loggedUser) async {
  //   _logger.i("Fetching Shikimori calendar releases");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 50,
  //       "order": "ranked",
  //       "status": "ongoing",
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //   );
  //   throwIfGraphQlError(response);
  //   final localeTag = loggedUser.settings.language;
  //   final calendarReleases = <String, List<Anime>>{};
  //   for (final entry in response.data.animes) {
  //     final anime = ShikimoriAnimeModel.fromListEntry(entry);
  //     if (anime.isAdult && !loggedUser.settings.enableNsfwContent) continue;
  //     if (entry.nextEpisodeAt != null) {
  //       final episodeRelease = DateTime.parse(entry.nextEpisodeAt.toString());
  //       final dateKey = DateFormat('EEEE, MMMM d, y', localeTag).format(episodeRelease);
  //       if (!calendarReleases.containsKey(dateKey)) {
  //         calendarReleases[dateKey] = [anime];
  //       } else {
  //         calendarReleases[dateKey]!.add(anime);
  //       }
  //     }
  //   }
  //   // Sort each list by airing time
  //   calendarReleases.forEach((date, animeList) {
  //     animeList.sort((a, b) => a.nextAiringEpisode.airingAt.compareTo(b.nextAiringEpisode.airingAt));
  //   });
  //   // Sort map entries by date
  //   final sortedEntries = calendarReleases.entries.toList()
  //     ..sort((a, b) {
  //       final dateA = DateFormat('EEEE, MMMM d, y', localeTag).parse(a.key);
  //       final dateB = DateFormat('EEEE, MMMM d, y', localeTag).parse(b.key);
  //       return dateA.millisecondsSinceEpoch.compareTo(dateB.millisecondsSinceEpoch);
  //     });
  //   return Map.fromEntries(sortedEntries);
  // }

  // @override
  // Future<(bool, AnimeDetails)> getAnimeDetails(Anime selectedAnime, User loggedUser) async {
  //   _logger.i("Fetching Anime Details from Shikimori for ${selectedAnime.title.userPreferred}");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeDetailsGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeDetailsQuery,
  //     fromJson: ShikimoriAnimeDetailsGraphqlEntity.fromJson,
  //     variables: {"ids": selectedAnime.id.toString()},
  //   );
  //   throwIfGraphQlError(response);
  //   if (response.data.anime.isEmpty) {
  //     return (false, AnimeDetailsModel.empty());
  //   }
  //   final animeDetails = ShikimoriAnimeDetailsModel.fromDetailsEntry(response.data.anime.first);
  //   return (true, animeDetails);
  // }

  // @override
  // Future<Map<String, (bool, List<String>)>> getUserAnimeAdvancedSearchFilters() async {
  //   _logger.i("Fetching Shikimori anime advanced search filters");
  //   final filters = <String, (bool, List<String>)>{};
  //   // Fetch genres from API
  //   final genresResponse = await _shikimoriGraphQLService.query<ShikimoriGenresGraphqlEntity>(
  //     query: shikimori_queries.shikimoriGenresListQuery,
  //     fromJson: ShikimoriGenresGraphqlEntity.fromJson,
  //     variables: {"entryType": "Anime"},
  //   );
  //   throwIfGraphQlError(genresResponse);
  //   final genreNames = genresResponse.data.genres.map((g) => g.name).toList();
  //   filters.addAll({
  //     'genres': (true, TextUtils.capitalizeList(genreNames)),
  //   });
  //   filters.addAll({
  //     'seasons': (
  //       true,
  //       TextUtils.capitalizeList(
  //         ShikimoriSeasonFilters.values.map((e) => e.name).toList(),
  //       ),
  //     ),
  //   });
  //   filters.addAll({
  //     'formats': (
  //       true,
  //       TextUtils.capitalizeList(
  //         ShikimoriFormatFilters.values.map((e) => e.name.replaceAll('_', ' ')).toList(),
  //       ),
  //     ),
  //   });
  //   filters.addAll({
  //     'airingStatuses': (
  //       true,
  //       TextUtils.capitalizeList(
  //         ShikimoriAiringStatusFilters.values.map((e) => e.name.replaceAll('_', ' ')).toList(),
  //       ),
  //     ),
  //   });
  //   filters.addAll({
  //     'years': (
  //       true,
  //       List<String>.generate(
  //         DateTime.now().year - 1939,
  //         (index) => (1940 + index).toString(),
  //       ).reversed.toList(),
  //     ),
  //   });
  //   filters.addAll({
  //     'sortOptions': (
  //       true,
  //       TextUtils.capitalizeList(
  //         ShikimoriSortOptions.values.map((e) => e.name.replaceAll('_', ' ')).toList(),
  //       ),
  //     ),
  //   });
  //   filters.addAll({
  //     'sortOrders': (
  //       true,
  //       TextUtils.capitalizeList(
  //         ShikimoriSortOrder.values.map((e) => e.name).toList(),
  //       ),
  //     ),
  //   });
  //   return filters;
  // }

  // @override
  // Future<List<Anime>> performAnimeAdvancedSearch(
  //   String query,
  //   List<String> selectedGenres,
  //   String? selectedSeason,
  //   String? selectedFormat,
  //   int? selectedYear,
  //   String? selectedAiringStatus,
  //   String sort,
  //   int page,
  //   User loggedUser,
  // ) async {
  //   _logger.i("Performing Shikimori anime advanced search");
  //   // Map genre names to IDs if needed - for now, Shikimori search uses genre IDs
  //   // But since we don't have ID mapping easily, we'll use genre names
  //   // Actually Shikimori genre filter accepts IDs, not names
  //   // For simplicity, we'll skip genre filtering in search or map common ones
  //   final genreIds = await _mapGenreNamesToIds(selectedGenres, "Anime");
  //   final response = await _shikimoriGraphQLService.query<ShikimoriAnimeListGraphqlEntity>(
  //     query: shikimori_queries.shikimoriAnimeListQuery,
  //     fromJson: ShikimoriAnimeListGraphqlEntity.fromJson,
  //     variables: {
  //       "page": page,
  //       "limit": 50,
  //       "order": _mapSortToShikimori(sort),
  //       if (query.isNotEmpty) "search": query,
  //       if (genreIds.isNotEmpty) "genre": genreIds.join(','),
  //       if (selectedSeason != null && selectedSeason.isNotEmpty) "season": selectedSeason.toLowerCase(),
  //       if (selectedYear != null) "season": "$selectedYear",
  //       if (selectedAiringStatus != null && selectedAiringStatus.isNotEmpty)
  //         "status": _mapAiringStatusToShikimori(selectedAiringStatus),
  //       if (selectedFormat != null && selectedFormat.isNotEmpty)
  //         "kind": _mapFormatToShikimoriKind(selectedFormat),
  //       "censored": loggedUser.settings.enableNsfwContent ? null : false,
  //     },
  //   );
  //   throwIfGraphQlError(response);
  //   return response.data.animes.map((e) => ShikimoriAnimeModel.fromListEntry(e)).toList();
  // }

  @override
  Future<List<String>> getMediaCoverImages(User loggedUser, {bool ignoreCache = false}) async {
    _logger.i("Fetching Media Cover Images from Shikimori");
    final (hasNext, animes) = await getPopularAnimes(1, loggedUser, ignoreCache: ignoreCache);
    return animes.map((anime) => anime.coverImage).where((coverImage) => coverImage != "").shuffled(Random()).toList();
  }

  @override
  Future<MediaListEntry> updateMediaListEntry(MediaListEntry newMediaListEntry, Anime selectedAnime, User loggedUser) async {
    _logger.i("Updating Media List Entry to $newMediaListEntry on Shikimori");
    // Metadata-only scope: return empty
    return MediaListEntryModel.empty();
  }

  @override
  Future<MediaListEntry> getMediaListEntry(Anime selectedAnime, User loggedUser, {bool ignoreCache = false}) async {
    _logger.i("Fetching User Media List Entry from Shikimori for ${selectedAnime.title.userPreferred}");
    // Metadata-only scope: return empty
    return MediaListEntryModel.empty();
  }

  // Helper methods

  // (bool, List<ShikimoriAnimeListGraphqlAnimes>) _processPaginatedResponse(
  //   List<ShikimoriAnimeListGraphqlAnimes> results,
  //   int limit,
  // ) {
  //   final hasNextPage = results.length > limit;
  //   final items = hasNextPage ? results.take(limit).toList() : results;
  //   return (hasNextPage, items);
  // }

  String _getCurrentSeason(DateTime date) {
    final month = date.month;
    String season;
    if (month >= 1 && month <= 3) {
      season = 'winter';
    } else if (month >= 4 && month <= 6) {
      season = 'spring';
    } else if (month >= 7 && month <= 9) {
      season = 'summer';
    } else {
      season = 'fall';
    }
    return "${season}_${date.year}";
  }

  // Future<List<String>> _mapGenreNamesToIds(List<String> genreNames, String entryType) async {
  //   if (genreNames.isEmpty) return [];
  //   final genresResponse = await _shikimoriGraphQLService.query<ShikimoriGenresGraphqlEntity>(
  //     query: shikimori_queries.shikimoriGenresListQuery,
  //     fromJson: ShikimoriGenresGraphqlEntity.fromJson,
  //     variables: {"entryType": entryType},
  //   );
  //   throwIfGraphQlError(genresResponse);
  //   final genreMap = <String, String>{};
  //   for (final genre in genresResponse.data.genres) {
  //     genreMap[genre.name.toLowerCase()] = genre.id;
  //   }
  //   return genreNames
  //       .map((name) => genreMap[name.toLowerCase()])
  //       .whereType<String>()
  //       .toList();
  // }

  String _mapSortToShikimori(String sort) {
    // sort comes as "popularity_desc" or "score_desc" etc.
    final parts = sort.toLowerCase().split('_');
    if (parts.length < 2) return 'popularity';
    final field = parts.first;
    switch (field) {
      case 'popularity':
        return 'popularity';
      case 'score':
        return 'ranked';
      case 'startdate':
      case 'start_date':
        return 'aired_on';
      case 'enddate':
      case 'end_date':
        return 'aired_on';
      case 'title':
        return 'name';
      case 'episodes':
        return 'episodes';
      case 'status':
        return 'status';
      case 'trending':
        return 'popularity';
      default:
        return 'popularity';
    }
  }

  String _mapAiringStatusToShikimori(String status) {
    switch (status.toLowerCase().replaceAll(' ', '_')) {
      case 'releasing':
        return 'ongoing';
      case 'finished':
        return 'released';
      case 'not_yet_released':
        return 'anons';
      case 'cancelled':
        return 'released'; // Shikimori doesn't have cancelled
      default:
        return status.toLowerCase();
    }
  }

  String _mapFormatToShikimoriKind(String format) {
    switch (format.toLowerCase().replaceAll(' ', '_')) {
      case 'tv':
        return 'tv';
      case 'tv_short':
        return 'tv_special';
      case 'movie':
        return 'movie';
      case 'special':
        return 'special';
      case 'ova':
        return 'ova';
      case 'ona':
        return 'ona';
      case 'music':
        return 'music';
      default:
        return format.toLowerCase().replaceAll(' ', '_');
    }
  }
}

enum ShikimoriSeasonFilters { winter, spring, summer, fall }

enum ShikimoriFormatFilters { tv, movie, tv_special, special, ova, ona, music }

enum ShikimoriAiringStatusFilters { ongoing, released, anons }

enum ShikimoriSortOptions {
  popularity,
  ranked,
  name,
  aired_on,
  episodes,
  status,
}

enum ShikimoriSortOrder { asc, desc }
