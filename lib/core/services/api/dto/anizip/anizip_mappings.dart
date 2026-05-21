import 'package:unyo/core/services/api/dto/anizip/anizip_episode_info_entity.dart';
import 'package:unyo/domain/entities/media/episode_info.dart';
import 'package:unyo/domain/entities/media/title.dart';

class AnizipMappings {
  final Title title;
  final String mediaImage;
  final int episodeCount;
  final List<EpisodeInfo> episodesInfo;

  const AnizipMappings({
    required this.title,
    required this.mediaImage,
    required this.episodeCount,
    required this.episodesInfo,
  });

  factory AnizipMappings.fromJson(Map<String, dynamic> json) {
    return AnizipMappings(
        title: TitleModel(
            romaji: json['titles']?['ja'] ?? '',
            english: json['titles']?['en'] ?? '',
            nativeTitle: json['titles']?['ja'] ?? '',
            userPreferred: json['titles']?['x-jat'] ?? ''
        ),
        mediaImage: ((json['images'] as List<dynamic>?)?.length ?? 0) > 2 ? (json['images']?[2]?['url'] ?? '') : '',
        episodeCount: json['episodeCount'] ?? -1,
        episodesInfo: _extractEpisodeInfoFromJson(json)
    );
  }

  static List<EpisodeInfo> _extractEpisodeInfoFromJson(
      Map<String, dynamic> json) {
    Map<String, dynamic> episodesJson = json['episodes'] ?? [];
    episodesJson.removeWhere((episodeNumber, episodeData) =>
    int.tryParse(episodeNumber) == null);
    return episodesJson.values.map((episodeData) =>
        AnizipEpisodeInfoEntity.fromJson(episodeData)
    ).map((anizipEpisodeInfo) =>
        EpisodeInfoModel(
            id: anizipEpisodeInfo.tvdbId,
            episodeNumber: anizipEpisodeInfo.episodeNumber,
            title: TitleModel(
                romaji: anizipEpisodeInfo.title.ja,
                english: anizipEpisodeInfo.title.en,
                nativeTitle: anizipEpisodeInfo.title.ja,
                userPreferred: anizipEpisodeInfo.title.xJat
            ),
            airDate: anizipEpisodeInfo.airdate,
            image: anizipEpisodeInfo.image,
            duration: "${anizipEpisodeInfo.length}min",
            description: anizipEpisodeInfo.overview,
            rating: anizipEpisodeInfo.rating,
        )
    ).toList();
  }
}