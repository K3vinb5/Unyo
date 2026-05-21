// External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/core/services/api/dto/anilist/media_advanced_search_query_graphql_entity.dart';
// Internal dependencies
import 'package:unyo/core/services/api/dto/anilist/media_collection_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_recently_completed_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_recently_released_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_trendingOrPopular_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_upcoming_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_graphql_entity.dart';
import 'package:unyo/domain/entities/media/airing_episode.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/title.dart';

part 'anilist_anime_model.freezed.dart';
part 'anilist_anime_model.g.dart';

@freezed
abstract class AnilistAnimeModel with _$AnilistAnimeModel implements Anime {
  const AnilistAnimeModel._();

  factory AnilistAnimeModel({
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
  }) = _AnilistAnimeModel;

  factory AnilistAnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistAnimeModelFromJson(json);

  factory AnilistAnimeModel.fromUserMediaEntry(
      MediaCollectionGraphqlDtoDataMediaListCollectionListsEntriesMedia
      mediaEntry,) {
    return AnilistAnimeModel(
      id: mediaEntry.id,
      idMal: mediaEntry.idMal,
      title: TitleModel(
        romaji: mediaEntry.title.romaji,
        english: mediaEntry.title.english,
        userPreferred: mediaEntry.title.userPreferred,
        nativeTitle: mediaEntry.title.native,
      ),
      averageScore: mediaEntry.averageScore,
      bannerImage: mediaEntry.bannerImage,
      countryOfOrigin: mediaEntry.countryOfOrigin,
      coverImage: mediaEntry.coverImage.large,
      description: mediaEntry.description,
      duration: mediaEntry.duration,
      endDate:
      "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry
          .endDate.year}",
      startDate:
      "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry
          .startDate.year}",
      episodes: mediaEntry.episodes,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      season: mediaEntry.season,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: mediaEntry.nextAiringEpisode?['episode'] ?? 0,
        airingAt: mediaEntry.nextAiringEpisode?['airingAt'].toString() ?? "",
      ),
    );
  }

  factory AnilistAnimeModel.fromScheduleEntry(
      MediaCollectionRecentlyReleasedGraphqlDtoPageAiringSchedules
      schedule,) {
    return AnilistAnimeModel(
      id: schedule.media.id,
      idMal: schedule.media.idMal,
      title: TitleModel(
        romaji: schedule.media.title.romaji,
        english: schedule.media.title.english,
        userPreferred: schedule.media.title.userPreferred,
        nativeTitle: schedule.media.title.native,
      ),
      averageScore: schedule.media.averageScore,
      bannerImage: schedule.media.bannerImage,
      countryOfOrigin: schedule.media.countryOfOrigin,
      coverImage: schedule.media.coverImage.large,
      description: schedule.media.description,
      duration: schedule.media.duration,
      endDate:
      "${schedule.media.endDate.day}/${schedule.media.endDate.month}/${schedule
          .media.endDate.year}",
      startDate:
      "${schedule.media.startDate.day}/${schedule.media.startDate
          .month}/${schedule.media.startDate.year}",
      episodes: schedule.media.episodes,
      genres: schedule.media.genres,
      format: schedule.media.format,
      isAdult: schedule.media.isAdult,
      popularity: schedule.media.popularity,
      meanScore: schedule.media.meanScore,
      season: schedule.media.season,
      status: schedule.media.status,
      isFavourite: schedule.media.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: schedule.media.nextAiringEpisode.episode,
        airingAt: schedule.media.nextAiringEpisode.airingAt.toString(),
      ),
    );
  }

  factory AnilistAnimeModel.fromPopularOrTrendingMediaEntry(
      MediaCollectionTrendingOrPopularGraphqlDtoPageMedia
      mediaEntry,) {
    return AnilistAnimeModel(
      id: mediaEntry.id,
      idMal: mediaEntry.idMal,
      title: TitleModel(
        romaji: mediaEntry.title.romaji,
        english: mediaEntry.title.english,
        userPreferred: mediaEntry.title.userPreferred,
        nativeTitle: mediaEntry.title.native,
      ),
      averageScore: mediaEntry.averageScore,
      bannerImage: mediaEntry.bannerImage,
      countryOfOrigin: mediaEntry.countryOfOrigin,
      coverImage: mediaEntry.coverImage.large,
      description: mediaEntry.description,
      duration: mediaEntry.duration,
      endDate:
      "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry
          .endDate.year}",
      startDate:
      "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry
          .startDate.year}",
      episodes: mediaEntry.episodes,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      season: mediaEntry.season,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: mediaEntry.nextAiringEpisode?['episode'] ?? 0,
        airingAt: mediaEntry.nextAiringEpisode?['airingAt'].toString() ?? "",
      ),
    );
  }

  factory AnilistAnimeModel.fromRecentlyCompletedMediaEntry(
      MediaCollectionRecentlyCompletedGraphqlDtoPageMedia
      mediaEntry,) {
    return AnilistAnimeModel(
      id: mediaEntry.id,
      idMal: mediaEntry.idMal,
      title: TitleModel(
        romaji: mediaEntry.title.romaji,
        english: mediaEntry.title.english,
        userPreferred: mediaEntry.title.userPreferred,
        nativeTitle: mediaEntry.title.native,
      ),
      averageScore: mediaEntry.averageScore,
      bannerImage: mediaEntry.bannerImage,
      countryOfOrigin: mediaEntry.countryOfOrigin,
      coverImage: mediaEntry.coverImage.large,
      description: mediaEntry.description,
      duration: mediaEntry.duration,
      endDate:
      "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry
          .endDate.year}",
      startDate:
      "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry
          .startDate.year}",
      episodes: mediaEntry.episodes,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      season: mediaEntry.season,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: mediaEntry.nextAiringEpisode?['episode'] ?? 0,
        airingAt: mediaEntry.nextAiringEpisode?['airingAt'].toString() ?? "",
      ),
    );
  }

  factory AnilistAnimeModel.fromUpcomingMediaEntry(
      MediaCollectionUpcomingGraphqlDtoPageMedia
      mediaEntry,) {
    return AnilistAnimeModel(
      id: mediaEntry.id,
      idMal: mediaEntry.idMal,
      title: TitleModel(
        romaji: mediaEntry.title.romaji,
        english: mediaEntry.title.english,
        userPreferred: mediaEntry.title.userPreferred,
        nativeTitle: mediaEntry.title.native,
      ),
      averageScore: mediaEntry.averageScore,
      bannerImage: mediaEntry.bannerImage,
      countryOfOrigin: mediaEntry.countryOfOrigin,
      coverImage: mediaEntry.coverImage.large,
      description: mediaEntry.description,
      duration: mediaEntry.duration,
      endDate:
      "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry
          .endDate.year}",
      startDate:
      "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry
          .startDate.year}",
      episodes: mediaEntry.episodes,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      season: mediaEntry.season,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: mediaEntry.nextAiringEpisode.episode,
        airingAt: mediaEntry.nextAiringEpisode.airingAt.toString(),
      ),
    );
  }

  factory AnilistAnimeModel.fromMediaRecommendationNode(
      MediaDetailsGraphqlMediaRecommendationsNodesMediaRecommendation mediaRecommendation) {
    return AnilistAnimeModel(
        id: mediaRecommendation.id,
        idMal: mediaRecommendation.idMal,
        title: TitleModel(romaji: mediaRecommendation.title.romaji,
            english: mediaRecommendation.title.english,
            nativeTitle: mediaRecommendation.title.native,
            userPreferred: mediaRecommendation.title.userPreferred),
        averageScore: mediaRecommendation.averageScore,
        bannerImage: mediaRecommendation.bannerImage,
        countryOfOrigin: "Unimplemented",
        coverImage: mediaRecommendation.coverImage.large,
        description: mediaRecommendation.description,
        duration: mediaRecommendation.duration,
        endDate: "${mediaRecommendation.endDate.day}/${mediaRecommendation.endDate.month}/${mediaRecommendation.endDate.year}",
        startDate: "${mediaRecommendation.startDate.day}/${mediaRecommendation.startDate.month}/${mediaRecommendation.startDate.year}",
        episodes: mediaRecommendation.episodes,
        genres: mediaRecommendation.genres,
        format: mediaRecommendation.format,
        isAdult: mediaRecommendation.isAdult,
        popularity: -1,
        meanScore: mediaRecommendation.meanScore,
        season: mediaRecommendation.season,
        status: mediaRecommendation.status,
        isFavourite: mediaRecommendation.isFavourite,
        nextAiringEpisode: AiringEpisodeModel(
        episode: mediaRecommendation.nextAiringEpisode?['episode'] ?? 0,
        airingAt: mediaRecommendation.nextAiringEpisode?['airingAt'].toString() ?? "",
      ),
    );
  }

  factory AnilistAnimeModel.fromAdvancedSearchMediaEntry(MediaAdvancedSearchQueryGraphqlPageMedia mediaEntry) {
    return AnilistAnimeModel(
      id: mediaEntry.id,
      idMal: mediaEntry.idMal,
      title: TitleModel(romaji: mediaEntry.title.romaji,
          english: mediaEntry.title.english,
          nativeTitle: mediaEntry.title.native,
          userPreferred: mediaEntry.title.userPreferred),
      averageScore: mediaEntry.averageScore,
      bannerImage: mediaEntry.bannerImage,
      countryOfOrigin: mediaEntry.countryOfOrigin,
      coverImage: mediaEntry.coverImage.large,
      description: mediaEntry.description,
      duration: mediaEntry.duration,
      endDate: "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry.endDate.year}",
      startDate: "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry.startDate.year}",
      episodes: mediaEntry.episodes,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      season: mediaEntry.season,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
      nextAiringEpisode: AiringEpisodeModel(
        episode: mediaEntry.nextAiringEpisode.episode,
        airingAt: mediaEntry.nextAiringEpisode.airingAt.toString(),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      _$AnilistAnimeModelToJson(this as _AnilistAnimeModel);
}
