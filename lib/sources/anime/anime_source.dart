import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

abstract class AnimeSource {
  Future<List<List<String>>> getAnimeTitlesAndIds(String query);

  Future<StreamData> getAnimeStreamAndCaptions(String id, int episode, BuildContext context);

  String getSourceName();

}
