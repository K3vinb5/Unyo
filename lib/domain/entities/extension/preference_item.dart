class PreferenceItem {
  final String key;
  final String title;
  final String type;
  final dynamic value;
  final List<String>? entries;
  final List<String>? entryValues;
  final String? summary;

  const PreferenceItem({
    required this.key,
    required this.title,
    required this.type,
    required this.value,
    this.entries,
    this.entryValues,
    this.summary,
  });
}
