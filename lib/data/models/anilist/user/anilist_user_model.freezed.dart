// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anilist_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnilistUserModel {

@HiveField(0) String get id;@HiveField(1) String get name;@SettingsConverter()@HiveField(2) Settings get settings;@HiveField(3) String get avatarImage;@HiveField(4) String get bannerImage;@HiveField(5) String get accessCode;@HiveField(6) String get accessToken;@HiveField(7) String get refreshToken;
/// Create a copy of AnilistUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnilistUserModelCopyWith<AnilistUserModel> get copyWith => _$AnilistUserModelCopyWithImpl<AnilistUserModel>(this as AnilistUserModel, _$identity);

  /// Serializes this AnilistUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnilistUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.accessCode, accessCode) || other.accessCode == accessCode)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,settings,avatarImage,bannerImage,accessCode,accessToken,refreshToken);

@override
String toString() {
  return 'AnilistUserModel(id: $id, name: $name, settings: $settings, avatarImage: $avatarImage, bannerImage: $bannerImage, accessCode: $accessCode, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class $AnilistUserModelCopyWith<$Res>  {
  factory $AnilistUserModelCopyWith(AnilistUserModel value, $Res Function(AnilistUserModel) _then) = _$AnilistUserModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@SettingsConverter()@HiveField(2) Settings settings,@HiveField(3) String avatarImage,@HiveField(4) String bannerImage,@HiveField(5) String accessCode,@HiveField(6) String accessToken,@HiveField(7) String refreshToken
});




}
/// @nodoc
class _$AnilistUserModelCopyWithImpl<$Res>
    implements $AnilistUserModelCopyWith<$Res> {
  _$AnilistUserModelCopyWithImpl(this._self, this._then);

  final AnilistUserModel _self;
  final $Res Function(AnilistUserModel) _then;

/// Create a copy of AnilistUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? settings = null,Object? avatarImage = null,Object? bannerImage = null,Object? accessCode = null,Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,accessCode: null == accessCode ? _self.accessCode : accessCode // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnilistUserModel].
extension AnilistUserModelPatterns on AnilistUserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnilistUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnilistUserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnilistUserModel value)  $default,){
final _that = this;
switch (_that) {
case _AnilistUserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnilistUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnilistUserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage, @HiveField(5)  String accessCode, @HiveField(6)  String accessToken, @HiveField(7)  String refreshToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnilistUserModel() when $default != null:
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage,_that.accessCode,_that.accessToken,_that.refreshToken);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage, @HiveField(5)  String accessCode, @HiveField(6)  String accessToken, @HiveField(7)  String refreshToken)  $default,) {final _that = this;
switch (_that) {
case _AnilistUserModel():
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage,_that.accessCode,_that.accessToken,_that.refreshToken);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage, @HiveField(5)  String accessCode, @HiveField(6)  String accessToken, @HiveField(7)  String refreshToken)?  $default,) {final _that = this;
switch (_that) {
case _AnilistUserModel() when $default != null:
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage,_that.accessCode,_that.accessToken,_that.refreshToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnilistUserModel extends AnilistUserModel {
  const _AnilistUserModel({@HiveField(0) required this.id, @HiveField(1) required this.name, @SettingsConverter()@HiveField(2) required this.settings, @HiveField(3) required this.avatarImage, @HiveField(4) required this.bannerImage, @HiveField(5) required this.accessCode, @HiveField(6) required this.accessToken, @HiveField(7) required this.refreshToken}): super._();
  factory _AnilistUserModel.fromJson(Map<String, dynamic> json) => _$AnilistUserModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String name;
@override@SettingsConverter()@HiveField(2) final  Settings settings;
@override@HiveField(3) final  String avatarImage;
@override@HiveField(4) final  String bannerImage;
@override@HiveField(5) final  String accessCode;
@override@HiveField(6) final  String accessToken;
@override@HiveField(7) final  String refreshToken;

/// Create a copy of AnilistUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnilistUserModelCopyWith<_AnilistUserModel> get copyWith => __$AnilistUserModelCopyWithImpl<_AnilistUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnilistUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnilistUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage)&&(identical(other.accessCode, accessCode) || other.accessCode == accessCode)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,settings,avatarImage,bannerImage,accessCode,accessToken,refreshToken);

@override
String toString() {
  return 'AnilistUserModel(id: $id, name: $name, settings: $settings, avatarImage: $avatarImage, bannerImage: $bannerImage, accessCode: $accessCode, accessToken: $accessToken, refreshToken: $refreshToken)';
}


}

/// @nodoc
abstract mixin class _$AnilistUserModelCopyWith<$Res> implements $AnilistUserModelCopyWith<$Res> {
  factory _$AnilistUserModelCopyWith(_AnilistUserModel value, $Res Function(_AnilistUserModel) _then) = __$AnilistUserModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@SettingsConverter()@HiveField(2) Settings settings,@HiveField(3) String avatarImage,@HiveField(4) String bannerImage,@HiveField(5) String accessCode,@HiveField(6) String accessToken,@HiveField(7) String refreshToken
});




}
/// @nodoc
class __$AnilistUserModelCopyWithImpl<$Res>
    implements _$AnilistUserModelCopyWith<$Res> {
  __$AnilistUserModelCopyWithImpl(this._self, this._then);

  final _AnilistUserModel _self;
  final $Res Function(_AnilistUserModel) _then;

/// Create a copy of AnilistUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? settings = null,Object? avatarImage = null,Object? bannerImage = null,Object? accessCode = null,Object? accessToken = null,Object? refreshToken = null,}) {
  return _then(_AnilistUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,accessCode: null == accessCode ? _self.accessCode : accessCode // ignore: cast_nullable_to_non_nullable
as String,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
