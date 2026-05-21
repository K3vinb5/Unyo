import 'package:freezed_annotation/freezed_annotation.dart';

import 'title.dart';

part 'manga.freezed.dart';
part 'manga.g.dart';

abstract class Manga {
  final int id;
  final int idMal;
  final Title title;
  final int averageScore;
  final String bannerImage;
  final int chapters;
  final String countryOfOrigin;
  final String coverImage;
  final String description;
  final String endDate;
  final String startDate;
  final List<String> genres;
  final String format;
  final bool isAdult;
  final int popularity;
  final int meanScore;
  final String status;
  final bool isFavourite;

  const Manga({
    required this.id,
    required this.idMal,
    required this.title,
    required this.averageScore,
    required this.bannerImage,
    required this.chapters,
    required this.countryOfOrigin,
    required this.coverImage,
    required this.description,
    required this.endDate,
    required this.startDate,
    required this.genres,
    required this.format,
    required this.isAdult,
    required this.popularity,
    required this.meanScore,
    required this.status,
    required this.isFavourite,
  });

  @override
  String toString() {
    return 'Manga(id: $id, idMal: $idMal, title: $title, averageScore: $averageScore, bannerImage: $bannerImage, chapters: $chapters, countryOfOrigin: $countryOfOrigin, coverImage: $coverImage, description: $description, endDate: $endDate, startDate: $startDate, genres: $genres, format: $format, isAdult: $isAdult, popularity: $popularity, meanScore: $meanScore, status: $status, isFavourite: $isFavourite)';
  }
}
@freezed
abstract class MangaModel with _$MangaModel implements Manga {
  const factory MangaModel({
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
  }) = _MangaModel;

  factory MangaModel.empty() => MangaModel(
    id: -1,
    idMal: 0,
    title: TitleModel.empty(),
    averageScore: 0,
    bannerImage: '',
    chapters: 0,
    countryOfOrigin: '',
    coverImage: '',
    description: '',
    endDate: '',
    startDate: '',
    genres: [],
    format: '',
    isAdult: false,
    popularity: 0,
    meanScore: 0,
    isFavourite: false,
    status: '',
  );

  factory MangaModel.fromJson(Map<String, dynamic> json) =>
      _$MangaModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MangaModelToJson(this as _MangaModel);
}
class MangaConverter implements JsonConverter<Manga, Map<String, dynamic>> {
  const MangaConverter();

  @override
  Manga fromJson(Map<String, dynamic> json) => MangaModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(Manga object) =>
      (object as MangaModel).toJson();
}