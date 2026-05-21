// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpisodeInfoModel _$EpisodeInfoModelFromJson(Map<String, dynamic> json) =>
    _EpisodeInfoModel(
      id: (json['id'] as num).toInt(),
      episodeNumber: (json['episodeNumber'] as num).toInt(),
      title: const TitleConverter().fromJson(
        json['title'] as Map<String, dynamic>,
      ),
      airDate: json['airDate'] as String,
      image: json['image'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      rating: json['rating'] as String,
    );

Map<String, dynamic> _$EpisodeInfoModelToJson(_EpisodeInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episodeNumber': instance.episodeNumber,
      'title': const TitleConverter().toJson(instance.title),
      'airDate': instance.airDate,
      'image': instance.image,
      'duration': instance.duration,
      'description': instance.description,
      'rating': instance.rating,
    };
