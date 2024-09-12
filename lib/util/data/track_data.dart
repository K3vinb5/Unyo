class TrackData {
  TrackData({required this.file, required this.lang, this.embedded, this.index}); 

  final String file;
  final String lang;
  final bool? embedded;
  final int? index;
}
