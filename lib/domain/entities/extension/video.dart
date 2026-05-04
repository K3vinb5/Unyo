import 'package:json_annotation/json_annotation.dart';
import 'package:unyo_lib/jmodels/jheaders.dart';
import 'package:unyo_lib/jmodels/jtrack.dart';
import 'package:unyo_lib/jmodels/jvideo.dart';
import 'package:unyo/domain/entities/extension/headers.dart';
import 'package:unyo/domain/entities/extension/track.dart';

class Video {
  final String url;
  final String title;
  final String quality;
  final String videoUrl;
  final Headers? headers;
  final bool initialized;
  final List<Track> audioTracks;
  final List<Track> subtitleTracks;
  final int? bitrate;
  final int? resolution;

  const Video({
    required this.url,
    required this.title,
    required this.quality,
    required this.videoUrl,
    required this.headers,
    required this.initialized,
    required this.audioTracks,
    required this.subtitleTracks,
    required this.bitrate,
    required this.resolution,
  });

  factory Video.fromJVideo(JVideo jVideo) {
    jObjIsNotNull(jObj) => jObj != null;
    return Video(
      url: jVideo.getUrl().toDartString(),
      title: jVideo.getVideoTitle().toDartString(),
      quality: jVideo.getQuality().toDartString(),
      videoUrl: jVideo.getVideoUrl().toDartString(),
      headers: Headers.fromJHeaders(jVideo.getHeaders()?.as<JHeaders>(JHeaders.type)),
      initialized: jVideo.getInitialized(),
      audioTracks:
          jVideo
              .getAudioTracks()
              .where(jObjIsNotNull)
              .map((jObj) => Track.fromJTrack(jObj.as<JTrack>(JTrack.type)))
              .toList(),
      subtitleTracks:
          jVideo
              .getSubtitleTracks()
              .where(jObjIsNotNull)
              .map((jObj) => Track.fromJTrack(jObj.as<JTrack>(JTrack.type)))
              .toList(),
      bitrate: jVideo.getBitrate()?.intValue(),
      resolution: jVideo.getResolution()?.intValue(),
    );
  }

  factory Video.empty() {
    return const Video(
      url: '',
      title: '',
      quality: '',
      videoUrl: '',
      headers: null,
      initialized: false,
      audioTracks: [],
      subtitleTracks: [],
      bitrate: null,
      resolution: null,
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      url: json['url'] as String,
      title: json['title'] as String,
      quality: json['quality'] as String,
      videoUrl: json['videoUrl'] as String,
      headers: json['headers'] != null
          ? Headers.fromJson(json['headers'] as Map<String, dynamic>)
          : null,
      initialized: json['initialized'] as bool,
      audioTracks: (json['audioTracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitleTracks: (json['subtitleTracks'] as List<dynamic>)
          .map((e) => Track.fromJson(e as Map<String, dynamic>))
          .toList(),
      bitrate: json['bitrate'] as int?,
      resolution: json['resolution'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'quality': quality,
      'videoUrl': videoUrl,
      'headers': headers?.toJson(),
      'initialized': initialized,
      'audioTracks': audioTracks.map((e) => e.toJson()).toList(),
      'subtitleTracks': subtitleTracks.map((e) => e.toJson()).toList(),
      'bitrate': bitrate,
      'resolution': resolution,
    };
  }
}

class VideoConverter implements JsonConverter<Video, Map<String, dynamic>> {
  const VideoConverter();

  @override
  Video fromJson(Map<String, dynamic> json) => Video.fromJson(json);

  @override
  Map<String, dynamic> toJson(Video object) =>
      (object).toJson();
}