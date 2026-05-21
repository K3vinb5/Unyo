import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/domain/entities/media/title.dart';

part 'episode_info.freezed.dart';
part 'episode_info.g.dart';

abstract class EpisodeInfo {
  final int id;
  final int episodeNumber;
  final Title title;
  final String airDate;
  final String image;
  final String duration;
  final String description;
  final String rating;

  const EpisodeInfo({
    required this.id,
    required this.episodeNumber,
    required this.title,
    required this.airDate,
    required this.image,
    required this.duration,
    required this.description,
    required this.rating,
  });

  @override
  String toString() {
    return 'EpisodeInfo(id: $id, episodeNumber: $episodeNumber, title: $title, airDate: $airDate, image: $image, duration: $duration, description: $description, rating: $rating)';
  }
}

@freezed
abstract class EpisodeInfoModel with _$EpisodeInfoModel implements EpisodeInfo {
  const factory EpisodeInfoModel({
    required int id,
    required int episodeNumber,
    @TitleConverter() required Title title,
    required String airDate,
    required String image,
    required String duration,
    required String description,
    required String rating,
  }) = _EpisodeInfoModel;

  factory EpisodeInfoModel.empty() => EpisodeInfoModel(
      id: -1,
      episodeNumber: -1,
      title: TitleModel.empty(),
      airDate: '',
      image: '',
      duration: '',
      description: '',
      rating: '',
  );

  factory EpisodeInfoModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$EpisodeInfoModelToJson(this as _EpisodeInfoModel);
}

class EpisodeInfoConverter implements JsonConverter<EpisodeInfo, Map<String, dynamic>> {
  const EpisodeInfoConverter();

  @override
  EpisodeInfo fromJson(Map<String, dynamic> json) => EpisodeInfoModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(EpisodeInfo object) =>
      (object as EpisodeInfoModel).toJson();
}