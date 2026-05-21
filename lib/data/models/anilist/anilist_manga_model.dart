import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/core/services/api/dto/anilist/media_advanced_search_query_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_recently_completed_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_trendingOrPopular_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_collection_upcoming_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_graphql_entity.dart';
import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/media/title.dart';

part 'anilist_manga_model.freezed.dart';

part 'anilist_manga_model.g.dart';

@freezed
abstract class AnilistMangaModel with _$AnilistMangaModel implements Manga {
  const AnilistMangaModel._();

  factory AnilistMangaModel({
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
    required int chapters,
    required List<String> genres,
    required String format,
    required bool isAdult,
    required int popularity,
    required int meanScore,
    required String status,
    required bool isFavourite,
  }) = _AnilistMangaModel;

  factory AnilistMangaModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistMangaModelFromJson(json);

  factory AnilistMangaModel.fromUserMediaEntry(
    MediaCollectionGraphqlDtoDataMediaListCollectionListsEntriesMedia
    mediaEntry,
  ) {
    return AnilistMangaModel(
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
          "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry.endDate.year}",
      startDate:
          "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry.startDate.year}",
      chapters: mediaEntry.chapters ?? 0,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
    );
  }

  factory AnilistMangaModel.fromPopularOrTrendingMediaEntry(
    MediaCollectionTrendingOrPopularGraphqlDtoPageMedia mediaEntry,
  ) {
    return AnilistMangaModel(
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
          "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry.endDate.year}",
      startDate:
          "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry.startDate.year}",
      chapters: mediaEntry.chapters,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
    );
  }

  factory AnilistMangaModel.fromRecentlyCompletedMediaEntry(
    MediaCollectionRecentlyCompletedGraphqlDtoPageMedia mediaEntry,
  ) {
    return AnilistMangaModel(
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
          "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry.endDate.year}",
      startDate:
          "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry.startDate.year}",
      chapters: mediaEntry.chapters,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
    );
  }

  factory AnilistMangaModel.fromUpcomingMediaEntry(
      MediaCollectionUpcomingGraphqlDtoPageMedia
      mediaEntry,
      ) {
    return AnilistMangaModel(
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
      "${mediaEntry.endDate.day}/${mediaEntry.endDate.month}/${mediaEntry.endDate.year}",
      startDate:
      "${mediaEntry.startDate.day}/${mediaEntry.startDate.month}/${mediaEntry.startDate.year}",
      chapters: mediaEntry.chapters,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
    );
  }

  factory AnilistMangaModel.fromMediaRecommendationNode(
      MediaDetailsGraphqlMediaRecommendationsNodesMediaRecommendation mediaRecommendation) {
    return AnilistMangaModel(
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
      chapters: mediaRecommendation.chapters,
      genres: mediaRecommendation.genres,
      format: mediaRecommendation.format,
      isAdult: mediaRecommendation.isAdult,
      popularity: -1,
      meanScore: mediaRecommendation.meanScore,
      status: mediaRecommendation.status,
      isFavourite: mediaRecommendation.isFavourite
    );
  }

  factory AnilistMangaModel.fromAdvancedSearchMediaEntry(MediaAdvancedSearchQueryGraphqlPageMedia mediaEntry) {
    return AnilistMangaModel(
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
      chapters: mediaEntry.chapters,
      genres: mediaEntry.genres,
      format: mediaEntry.format,
      isAdult: mediaEntry.isAdult,
      popularity: mediaEntry.popularity,
      meanScore: mediaEntry.meanScore,
      status: mediaEntry.status,
      isFavourite: mediaEntry.isFavourite,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      _$AnilistMangaModelToJson(this as _AnilistMangaModel);
}
