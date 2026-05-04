import 'package:unyo_lib/jmodels/jheaders.dart';

class Headers {
  final Map<String, String> headersMap;

  const Headers({required this.headersMap});

  factory Headers.fromJHeaders(JHeaders? jHeaders) {
    if (jHeaders == null) {
      return const Headers(headersMap: {});
    }
    return Headers(
      headersMap: jHeaders.toMultimap().map((key, value) => MapEntry(key.toDartString(), value.join(","))),
    );
  }

  factory Headers.fromJson(Map<String, dynamic> json) {
    return Headers(
      headersMap: Map<String, String>.from(json['headersMap'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headersMap': headersMap,
    };
  }
}
