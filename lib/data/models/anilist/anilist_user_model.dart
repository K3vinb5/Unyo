//External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

//Internal dependencies
import 'package:unyo/domain/entities/user/user.dart';
import 'package:unyo/data/adapters/adapters_types.dart' as types;
import 'package:unyo/data/adapters/adapters_names.dart' as names;
import 'package:unyo/domain/entities/user/settings.dart';

part 'anilist_user_model.freezed.dart';
part 'anilist_user_model.g.dart'; // For JSON serialization

@freezed
@HiveType(typeId: types.anilistUserAdapterType, adapterName: names.anilistUserModelAdapterName)
abstract class AnilistUserModel with _$AnilistUserModel implements User {
  const AnilistUserModel._();

  const factory AnilistUserModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @SettingsConverter() @HiveField(2) required Settings settings,
    @HiveField(3) required String avatarImage,
    @HiveField(4) required String bannerImage,
    @HiveField(5) required String accessCode,
    @HiveField(6) required String accessToken,
    @HiveField(7) required String refreshToken,
  }) = _AnilistUserModel;

  factory AnilistUserModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistUserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$AnilistUserModelToJson(this as _AnilistUserModel);
}

class AnilistUserModelConverter
    implements JsonConverter<User, Map<String, dynamic>> {
  const AnilistUserModelConverter();

  @override
  User fromJson(Map<String, dynamic> json) => AnilistUserModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(User object) =>
      (object as AnilistUserModel).toJson();
}
