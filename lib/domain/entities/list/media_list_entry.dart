import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:unyo/core/services/api/dto/anilist/media_details_media_list_entry_entity.dart';
import 'package:unyo/core/services/api/dto/anilist/save_media_list_entry_entity.dart';
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/data/adapters/adapters_types.dart' as types;

part 'media_list_entry.freezed.dart';

part 'media_list_entry.g.dart';

abstract class MediaListEntry {
  final int progress;
  final int progressVolumes;
  final double score;
  final int repeat;
  final String status;
  final List<String> startedAt;
  final List<String> completedAt;

  // final List<> customLists;

  const MediaListEntry({
    required this.progress,
    required this.progressVolumes,
    required this.score,
    required this.repeat,
    required this.status,
    required this.startedAt,
    required this.completedAt,
  });
}

@freezed
@HiveType(typeId: types.mediaListEntryAdapterType, adapterName: names.mangaListEntryModelAdapterName)
abstract class MediaListEntryModel with _$MediaListEntryModel implements MediaListEntry {
  const factory MediaListEntryModel({
    @HiveField(0) required int progress,
    @HiveField(1) required int progressVolumes,
    @HiveField(2) required double score,
    @HiveField(3) required int repeat,
    @HiveField(4) required String status,
    @HiveField(5) required List<String> startedAt,
    @HiveField(6) required List<String> completedAt,
  }) = _MediaListEntryModel;

  factory MediaListEntryModel.empty() => const MediaListEntryModel(
    progress: -1,
    progressVolumes: -1,
    score: -1.0,
    repeat: -1,
    status: 'ADD TO LIST',
    startedAt: ["~", "~", "~"],
    completedAt: ["~", "~", "~"],
  );

  factory MediaListEntryModel.fromSaveMediaListEntryEntity(
    SaveMediaListEntrySaveMediaListEntry saveMediaListEntry,
  ) => MediaListEntryModel(
    progress: saveMediaListEntry.progress,
    progressVolumes: saveMediaListEntry.progressVolumes,
    score: saveMediaListEntry.score,
    repeat: saveMediaListEntry.repeat,
    status: saveMediaListEntry.status.toUpperCase().replaceAll("_", " "),
    startedAt: [
      "${saveMediaListEntry.startedAt.day != 0 ? saveMediaListEntry.startedAt.day : "~"}",
      "${saveMediaListEntry.startedAt.month != 0 ? saveMediaListEntry.startedAt.month : "~"}",
      "${saveMediaListEntry.startedAt.year != 0 ? saveMediaListEntry.startedAt.year : "~"}",
    ],
    completedAt: [
      "${saveMediaListEntry.completedAt.day != 0 ? saveMediaListEntry.completedAt.day : "~"}",
      "${saveMediaListEntry.completedAt.month != 0 ? saveMediaListEntry.completedAt.month : "~"}",
      "${saveMediaListEntry.completedAt.year != 0 ? saveMediaListEntry.completedAt.year : "~"}",
    ],
  );

  factory MediaListEntryModel.fromMediaDetailsMediaListEntryEntity(
      MediaDetailsMediaListEntryEntity mediaDetailsMediaListEntry,
      ) => MediaListEntryModel(
    progress: mediaDetailsMediaListEntry.media.mediaListEntry.progress,
    progressVolumes: mediaDetailsMediaListEntry.media.mediaListEntry.progressVolumes,
    score: mediaDetailsMediaListEntry.media.mediaListEntry.score,
    repeat: mediaDetailsMediaListEntry.media.mediaListEntry.repeat,
    status: mediaDetailsMediaListEntry.media.mediaListEntry.status.toUpperCase().replaceAll("_", " "),
    startedAt: [
      "${mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.day != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.day : "~"}",
      "${mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.month != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.month : "~"}",
      "${mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.year != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.startedAt.year : "~"}",
    ],
    completedAt: [
      "${mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.day != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.day : "~"}",
      "${mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.month != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.month : "~"}",
      "${mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.year != 0 ? mediaDetailsMediaListEntry.media.mediaListEntry.completedAt.year : "~"}",
    ],
  );

  factory MediaListEntryModel.fromJson(Map<String, dynamic> json) => _$MediaListEntryModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MediaListEntryModelToJson(this as _MediaListEntryModel);
}

class MediaListEntryConverter implements JsonConverter<MediaListEntry, Map<String, dynamic>> {
  const MediaListEntryConverter();

  @override
  MediaListEntry fromJson(Map<String, dynamic> json) => MediaListEntryModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(MediaListEntry object) => (object as MediaListEntryModel).toJson();
}
