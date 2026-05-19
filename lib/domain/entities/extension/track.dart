import 'package:unyo_lib/jmodels/jtrack.dart';

class Track {
  final String url;
  final String lang;
  final bool embedded;
  final int embeddedIndex;

  const Track({
    required this.url,
    required this.lang,
    required this.embedded,
    required this.embeddedIndex,
  });

  factory Track.fromJTrack(JTrack jTrack) {
    return Track(
        url: jTrack.getUrl().toDartString(),
        lang: jTrack.getLang().toDartString(),
        embedded: false,
        embeddedIndex: -1
    );
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      url: json['url'] as String,
      lang: json['lang'] as String,
      embedded: json['embedded'] as bool,
      embeddedIndex: json['embeddedIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'lang': lang,
      'embedded': embedded,
      'embeddedIndex': embeddedIndex,
    };
  }
}