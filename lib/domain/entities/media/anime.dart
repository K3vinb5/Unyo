import 'package:freezed_annotation/freezed_annotation.dart';

import 'airing_episode.dart';
import 'title.dart';

part 'anime.freezed.dart';
part 'anime.g.dart';

abstract class Anime {
  final int id;
  final int idMal;
  final Title title;
  final int averageScore;
  final String bannerImage;
  final String countryOfOrigin;
  final String coverImage;
  final String description;
  final int duration;
  final String endDate;
  final String startDate;
  final int episodes;
  final List<String> genres;
  final String format;
  final bool isAdult;
  final int popularity;
  final int meanScore;
  final String season;
  final bool isFavourite;
  final String status;
  final AiringEpisode nextAiringEpisode;

  const Anime({
    required this.id,
    required this.idMal,
    required this.title,
    required this.averageScore,
    required this.bannerImage,
    required this.countryOfOrigin,
    required this.coverImage,
    required this.description,
    required this.duration,
    required this.endDate,
    required this.startDate,
    required this.episodes,
    required this.genres,
    required this.format,
    required this.isAdult,
    required this.popularity,
    required this.meanScore,
    required this.season,
    required this.isFavourite,
    required this.status,
    required this.nextAiringEpisode,
  });

  @override
  String toString() {
    return 'Anime(id: $id, idMal: $idMal, title: $title, averageScore: $averageScore, bannerImage: $bannerImage, countryOfOrigin: $countryOfOrigin, coverImage: $coverImage, description: $description, duration: $duration, endDate: $endDate, startDate: $startDate, episodes: $episodes, genres: $genres, format: $format, isAdult: $isAdult, popularity: $popularity, meanScore: $meanScore, season: $season, isFavourite: $isFavourite, status: $status, nextAiringEpisode: $nextAiringEpisode)';
  }
}

@freezed
abstract class AnimeModel with _$AnimeModel implements Anime {
  const factory AnimeModel({
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
    required bool isFavourite,
    required String status,
    @AiringEpisodeConverter() required AiringEpisode nextAiringEpisode,
  }) = _AnimeModel;

  factory AnimeModel.empty() => AnimeModel(
        id: -1,
        idMal: 0,
        title: TitleModel.empty(),
        averageScore: 0,
        bannerImage: '',
        countryOfOrigin: '',
        coverImage: '',
        description: '',
        duration: 0,
        endDate: '',
        startDate: '',
        episodes: 0,
        genres: [],
        format: '',
        isAdult: false,
        popularity: 0,
        meanScore: 0,
        season: '',
        isFavourite: false,
        status: '',
        nextAiringEpisode: AiringEpisodeModel.empty(),
      );

  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AnimeModelToJson(this as _AnimeModel);
}
class AnimeConverter implements JsonConverter<Anime, Map<String, dynamic>> {
  const AnimeConverter();

  @override
  Anime fromJson(Map<String, dynamic> json) => AnimeModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(Anime object) =>
      (object as AnimeModel).toJson();
}