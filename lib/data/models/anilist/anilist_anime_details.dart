import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_graphql_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_media_list_entry_entity.dart';
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/data/adapters/adapters_types.dart' as types;
import 'package:unyo/data/models/anilist/anilist_anime_model.dart';
import 'package:unyo/data/models/anilist/anilist_media_character.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/anime_details.dart';
import 'package:unyo/domain/entities/media/media_character.dart';
import 'package:unyo/domain/entities/list/media_list_entry.dart';

part 'anilist_anime_details.freezed.dart';

part 'anilist_anime_details.g.dart';

@freezed
@HiveType(
  typeId: types.anilistAnimeDetailsAdapterType,
  adapterName: names.anilistAnimeDetailsModelAdapterName,
)
abstract class AnilistAnimeDetailsModel with _$AnilistAnimeDetailsModel implements AnimeDetails {
  const factory AnilistAnimeDetailsModel({
    @HiveField(0) @MediaListEntryConverter() required MediaListEntry mediaListEntry,
    @HiveField(1) @AnimeConverter() required List<Anime> recommendedAnimes,
    @HiveField(2) @MediaCharacterConverter() required List<MediaCharacter> characters,
  }) = _AnilistAnimeDetailsModel;

  factory AnilistAnimeDetailsModel.empty() => AnilistAnimeDetailsModel(
    mediaListEntry: MediaListEntryModel.empty(),
    recommendedAnimes: [],
    characters: [],
  );

  factory AnilistAnimeDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistAnimeDetailsModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnilistAnimeDetailsModelToJson(this as _AnilistAnimeDetailsModel);

  factory AnilistAnimeDetailsModel.fromAnimeDetailsMediaList(MediaDetailsGraphqlMedia animeDetailsMediaList, MediaDetailsMediaListEntryEntity mediaListEntry) {
    return AnilistAnimeDetailsModel(
      mediaListEntry: MediaListEntryModel.fromMediaDetailsMediaListEntryEntity(mediaListEntry),
      recommendedAnimes:
          animeDetailsMediaList.recommendations.nodes
              .map(
                (recommendationNode) =>
                    AnilistAnimeModel.fromMediaRecommendationNode(recommendationNode.mediaRecommendation),
              )
              .toList(),
      characters:
          animeDetailsMediaList.characters.nodes
              .map((characterNode) => AnilistMediaCharacterModel.fromCharacterNode(characterNode))
              .toList(),
    );
  }
}
