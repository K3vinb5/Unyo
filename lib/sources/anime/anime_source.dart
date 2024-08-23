import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

abstract class AnimeSource {
  Future<List<List<String>>> getAnimeTitlesAndIds(String query);

  Future<StreamData> getAnimeStreamAndCaptions(String id, String name, int episode, BuildContext context);

  String getSourceName();

}
