import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/domain/entities/extension/video.dart' as ext;
import 'package:unyo/domain/entities/extension/video.dart';

part 'video_info.freezed.dart';
part 'video_info.g.dart';

abstract class VideoInfo {
  final ext.Video currentVideo;
  final List<ext.Video> alternativeVideos;
  final int videoIndex;
  final int playlistIndex;

  const VideoInfo({required this.currentVideo, required this.alternativeVideos, required this.videoIndex, required this.playlistIndex});
}

@freezed
abstract class VideoInfoModel with _$VideoInfoModel implements VideoInfo {
  const factory VideoInfoModel({
    @ext.VideoConverter() required ext.Video currentVideo,
    @ext.VideoConverter() required List<ext.Video> alternativeVideos,
    required int videoIndex,
    required int playlistIndex,
  }) = _VideoInfoModel;

  factory VideoInfoModel.empty() => VideoInfoModel(
      currentVideo: ext.Video.empty(),
      alternativeVideos: [],
      videoIndex: -1,
      playlistIndex: -1
  );

  factory VideoInfoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$VideoInfoModelToJson(this as _VideoInfoModel);
}

class VideoInfoConverter implements JsonConverter<VideoInfo, Map<String, dynamic>> {
  const VideoInfoConverter();

  @override
  VideoInfo fromJson(Map<String, dynamic> json) => VideoInfoModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(VideoInfo object) =>
      (object as VideoInfoModel).toJson();
}