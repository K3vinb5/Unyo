import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:unyo/core/enums/extension_type.dart';
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/data/adapters/adapters_types.dart' as types;

part 'extension.freezed.dart';

part 'extension.g.dart';

abstract class Extension {
  final String name;
  final String pkg;
  final String apk;
  final String icon;
  final String lang;
  final String version;
  final int nsfw;
  final String type;
  final String repositoryUrl;

  const Extension({
    required this.name,
    required this.pkg,
    required this.apk,
    required this.icon,
    required this.lang,
    required this.version,
    required this.nsfw,
    required this.type,
    required this.repositoryUrl,
  });

  @override
  String toString() {
    return 'Extension{name: $name, pkg: $pkg, apk: $apk, icon: $icon, lang: $lang, version: $version, nsfw: $nsfw, type: $type, repositoryUrl: $repositoryUrl}';
  }
}

@freezed
@HiveType(typeId: types.extensionAdapterType, adapterName: names.extensionModelAdapterName)
abstract class ExtensionModel with _$ExtensionModel implements Extension {
  const factory ExtensionModel({
    @HiveField(0) required String name,
    @HiveField(1) required String pkg,
    @HiveField(2) required String apk,
    @HiveField(3) required String icon,
    @HiveField(4) required String lang,
    @HiveField(5) required String version,
    @HiveField(6) required int nsfw,
    @HiveField(7) required String type,
    @HiveField(8) @Default("") String repositoryUrl,
  }) = _ExtensionModel;

  factory ExtensionModel.empty() => const ExtensionModel(
    name: '',
    pkg: '',
    apk: '',
    icon: '',
    lang: '',
    version: '',
    nsfw: 0,
    type: ExtensionType.ANIYOMI,
    repositoryUrl: '',
  );

  factory ExtensionModel.fromJson(Map<String, dynamic> json) => _$ExtensionModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ExtensionModelToJson(this as _ExtensionModel);
}

class ExtensionConverter implements JsonConverter<Extension, Map<String, dynamic>> {
  const ExtensionConverter();

  @override
  Extension fromJson(Map<String, dynamic> json) => ExtensionModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(Extension object) => (object as ExtensionModel).toJson();
}
