// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'torrent_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TorrentStatusModel _$TorrentStatusModelFromJson(Map<String, dynamic> json) =>
    _TorrentStatusModel(
      hash: json['hash'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      poster: json['poster'] as String,
      category: json['category'] as String,
      stat: (json['stat'] as num).toInt(),
      statString: json['statString'] as String?,
      downloadSpeed: (json['downloadSpeed'] as num?)?.toDouble(),
      uploadSpeed: (json['uploadSpeed'] as num?)?.toDouble(),
      activePeers: (json['activePeers'] as num?)?.toInt(),
      totalPeers: (json['totalPeers'] as num?)?.toInt(),
      connectedSeeders: (json['connectedSeeders'] as num?)?.toInt(),
      torrentSize: (json['torrentSize'] as num?)?.toInt(),
      preloadedBytes: (json['preloadedBytes'] as num?)?.toInt(),
      preloadSize: (json['preloadSize'] as num?)?.toInt(),
      fileStats:
          (json['fileStats'] as List<dynamic>?)
              ?.map((e) => TorrentFileStat.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TorrentFileStat>[],
    );

Map<String, dynamic> _$TorrentStatusModelToJson(_TorrentStatusModel instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'name': instance.name,
      'title': instance.title,
      'poster': instance.poster,
      'category': instance.category,
      'stat': instance.stat,
      'statString': instance.statString,
      'downloadSpeed': instance.downloadSpeed,
      'uploadSpeed': instance.uploadSpeed,
      'activePeers': instance.activePeers,
      'totalPeers': instance.totalPeers,
      'connectedSeeders': instance.connectedSeeders,
      'torrentSize': instance.torrentSize,
      'preloadedBytes': instance.preloadedBytes,
      'preloadSize': instance.preloadSize,
      'fileStats': instance.fileStats,
    };
