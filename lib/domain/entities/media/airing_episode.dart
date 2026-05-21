import 'package:freezed_annotation/freezed_annotation.dart';

part 'airing_episode.freezed.dart';
part 'airing_episode.g.dart';

abstract class AiringEpisode {
  final int episode;
  final String airingAt;

  const AiringEpisode({
    required this.episode,
    required this.airingAt,
  });

  @override
  String toString() {
    return 'AiringEpisode(episode: $episode, airingAt: $airingAt)';
  }
}

@freezed
abstract class AiringEpisodeModel with _$AiringEpisodeModel implements AiringEpisode {
  const factory AiringEpisodeModel({
    required int episode,
    required String airingAt,
  }) = _AiringEpisodeModel;

  factory AiringEpisodeModel.empty() => const AiringEpisodeModel(
    episode: -1,
    airingAt: '',
  );

  factory AiringEpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$AiringEpisodeModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AiringEpisodeModelToJson(this as _AiringEpisodeModel);
}

class AiringEpisodeConverter implements JsonConverter<AiringEpisode, Map<String, dynamic>> {
  const AiringEpisodeConverter();

  @override
  AiringEpisode fromJson(Map<String, dynamic> json) => AiringEpisodeModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(AiringEpisode object) =>
      (object as AiringEpisodeModel).toJson();
}