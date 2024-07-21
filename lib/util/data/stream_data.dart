import 'package:unyo/util/utils.dart';

class StreamData {
  StreamData({
    required this.streams,
    required this.qualities,
    required this.captions,
    required this.tracks,
    required this.headersKeys,
    required this.headersValues,
  });

  StreamData.empy({
    this.streams = const [],
    this.qualities = const [],
    this.captions,
    this.tracks,
    this.headersKeys = const [],
    this.headersValues = const [],
  });

  final List<String> streams;
  final List<String> qualities;
  final List<List<CaptionData>>? captions;
  final List<List<TrackData>>? tracks;
  final List<List<String>> headersKeys;
  final List<List<String>> headersValues;

  Map<String, String>? getHeaders(int source) {
    if (headersKeys.isNotEmpty) {
      Map<String, String> headers = {};
      List<String> values = headersValues[source];
      List<String> keys = headersKeys[source];
      for (int i = 0; i < values.length; i++) {
        headers.addAll(
            {keys[i][0].toUpperCase() + keys[i].substring(1): values[i]});
      }
      return headers;
    }else{
      return null;
    }
  }
}
