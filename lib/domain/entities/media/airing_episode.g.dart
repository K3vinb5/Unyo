// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airing_episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiringEpisodeModel _$AiringEpisodeModelFromJson(Map<String, dynamic> json) =>
    _AiringEpisodeModel(
      episode: (json['episode'] as num).toInt(),
      airingAt: json['airingAt'] as String,
    );

Map<String, dynamic> _$AiringEpisodeModelToJson(_AiringEpisodeModel instance) =>
    <String, dynamic>{
      'episode': instance.episode,
      'airingAt': instance.airingAt,
    };
