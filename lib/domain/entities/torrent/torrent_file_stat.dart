class TorrentFileStat {
  final int id;
  final int length;
  final String path;

  const TorrentFileStat({
    required this.id,
    required this.length,
    required this.path,
  });

  factory TorrentFileStat.fromJson(Map<String, dynamic> json) {
    return TorrentFileStat(
      id: json['id'] as int,
      length: json['length'] as int,
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'length': length,
      'path': path,
    };
  }
}
