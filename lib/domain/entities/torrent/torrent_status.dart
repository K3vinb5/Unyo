import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/domain/entities/torrent/torrent_file_stat.dart';

part 'torrent_status.freezed.dart';
part 'torrent_status.g.dart';

abstract class TorrentStatus {
  final String hash;
  final String name;
  final String title;
  final String poster;
  final String category;
  final int stat;
  final String? statString;
  final double? downloadSpeed;
  final double? uploadSpeed;
  final int? activePeers;
  final int? totalPeers;
  final int? connectedSeeders;
  final int? torrentSize;
  final int? preloadedBytes;
  final int? preloadSize;
  final List<TorrentFileStat> fileStats;

  const TorrentStatus({
    required this.hash,
    required this.name,
    required this.title,
    required this.poster,
    required this.category,
    required this.stat,
    this.statString,
    this.downloadSpeed,
    this.uploadSpeed,
    this.activePeers,
    this.totalPeers,
    this.connectedSeeders,
    this.torrentSize,
    this.preloadedBytes,
    this.preloadSize,
    required this.fileStats,
  });
}

@freezed
abstract class TorrentStatusModel with _$TorrentStatusModel implements TorrentStatus {
  const factory TorrentStatusModel({
    required String hash,
    required String name,
    required String title,
    required String poster,
    required String category,
    required int stat,
    String? statString,
    double? downloadSpeed,
    double? uploadSpeed,
    int? activePeers,
    int? totalPeers,
    int? connectedSeeders,
    int? torrentSize,
    int? preloadedBytes,
    int? preloadSize,
    @Default(<TorrentFileStat>[]) List<TorrentFileStat> fileStats,
  }) = _TorrentStatusModel;

  factory TorrentStatusModel.empty() => const TorrentStatusModel(
        hash: '',
        name: '',
        title: '',
        poster: '',
        category: '',
        stat: -1,
        fileStats: [],
      );

  factory TorrentStatusModel.fromJson(Map<String, dynamic> json) =>
      _$TorrentStatusModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$TorrentStatusModelToJson(this as _TorrentStatusModel);
}

class TorrentStatusConverter
    implements JsonConverter<TorrentStatus, Map<String, dynamic>> {
  const TorrentStatusConverter();

  @override
  TorrentStatus fromJson(Map<String, dynamic> json) =>
      TorrentStatusModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(TorrentStatus object) =>
      (object as TorrentStatusModel).toJson();
}
