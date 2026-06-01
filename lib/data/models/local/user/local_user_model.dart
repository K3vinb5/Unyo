//External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

//Internal dependencies
import 'package:unyo/domain/entities/user/user.dart';
import 'package:unyo/data/adapters/adapters_types.dart' as types;
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/domain/entities/user/settings.dart';

part 'local_user_model.freezed.dart';

part 'local_user_model.g.dart'; // For JSON serialization

@freezed
@HiveType(typeId: types.localUserAdapterType, adapterName: names.localUserModelAdapterName)
abstract class LocalUserModel with _$LocalUserModel implements User {
  const LocalUserModel._();

  const factory LocalUserModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @SettingsConverter() @HiveField(2) required Settings settings,
    @HiveField(3) required String avatarImage,
    @HiveField(4) required String bannerImage,
  }) = _LocalUserModel;

  factory LocalUserModel.fromJson(Map<String, dynamic> json) =>
      _$LocalUserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$LocalUserModelToJson(this as _LocalUserModel);
}

class LocalUserModelConverter implements JsonConverter<User, Map<String, dynamic>> {
  const LocalUserModelConverter();

  @override
  User fromJson(Map<String, dynamic> json) => LocalUserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(User object) =>
      (object as LocalUserModel).toJson();
}
