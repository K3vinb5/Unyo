// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoInfoModel _$VideoInfoModelFromJson(Map<String, dynamic> json) =>
    _VideoInfoModel(
      currentVideo: const VideoConverter().fromJson(
        json['currentVideo'] as Map<String, dynamic>,
      ),
      alternativeVideos: (json['alternativeVideos'] as List<dynamic>)
          .map(
            (e) => const VideoConverter().fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      videoIndex: (json['videoIndex'] as num).toInt(),
      playlistIndex: (json['playlistIndex'] as num).toInt(),
    );

Map<String, dynamic> _$VideoInfoModelToJson(_VideoInfoModel instance) =>
    <String, dynamic>{
      'currentVideo': const VideoConverter().toJson(instance.currentVideo),
      'alternativeVideos': instance.alternativeVideos
          .map(const VideoConverter().toJson)
          .toList(),
      'videoIndex': instance.videoIndex,
      'playlistIndex': instance.playlistIndex,
    };
