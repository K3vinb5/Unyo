import 'package:flutter/material.dart';

abstract class AnimeSource {
  Future<List<List<String>>> getAnimeTitlesAndIds(String query);

  Future<List<String?>> getAnimeStreamAndCaptions(String id, int episode, BuildContext context);

  String getSourceName();
}
