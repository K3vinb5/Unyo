import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:unyo/core/enums/media_type.dart';
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/data/adapters/adapters_types.dart' as types;

part 'media_list.freezed.dart';
part 'media_list.g.dart';

abstract class MediaList {
  final String name;
  final MediaType mediaType;

  const MediaList({required this.name, required this.mediaType});
}

@freezed
@HiveType(typeId: types.mediaListAdapterType, adapterName: names.mediaListModelAdapterName)
abstract class MediaListModel with _$MediaListModel implements MediaList {
  const factory MediaListModel({
    @HiveField(0) required String name,
    @HiveField(1) required MediaType mediaType,
  }) = _MediaListModel;

  factory MediaListModel.empty() => const MediaListModel(
      name: '',
      mediaType: MediaType.anime
  );

  factory MediaListModel.fromJson(Map<String, dynamic> json) =>
      _$MediaListModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$MediaListModelToJson(this as _MediaListModel);
}

class MediaListConverter implements JsonConverter<MediaList, Map<String, dynamic>> {
  const MediaListConverter();

  @override
  MediaList fromJson(Map<String, dynamic> json) => MediaListModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(MediaList object) =>
      (object as MediaListModel).toJson();
}