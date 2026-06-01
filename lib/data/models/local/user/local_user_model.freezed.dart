// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocalUserModel {

@HiveField(0) String get id;@HiveField(1) String get name;@SettingsConverter()@HiveField(2) Settings get settings;@HiveField(3) String get avatarImage;@HiveField(4) String get bannerImage;
/// Create a copy of LocalUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalUserModelCopyWith<LocalUserModel> get copyWith => _$LocalUserModelCopyWithImpl<LocalUserModel>(this as LocalUserModel, _$identity);

  /// Serializes this LocalUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,settings,avatarImage,bannerImage);

@override
String toString() {
  return 'LocalUserModel(id: $id, name: $name, settings: $settings, avatarImage: $avatarImage, bannerImage: $bannerImage)';
}


}

/// @nodoc
abstract mixin class $LocalUserModelCopyWith<$Res>  {
  factory $LocalUserModelCopyWith(LocalUserModel value, $Res Function(LocalUserModel) _then) = _$LocalUserModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@SettingsConverter()@HiveField(2) Settings settings,@HiveField(3) String avatarImage,@HiveField(4) String bannerImage
});




}
/// @nodoc
class _$LocalUserModelCopyWithImpl<$Res>
    implements $LocalUserModelCopyWith<$Res> {
  _$LocalUserModelCopyWithImpl(this._self, this._then);

  final LocalUserModel _self;
  final $Res Function(LocalUserModel) _then;

/// Create a copy of LocalUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? settings = null,Object? avatarImage = null,Object? bannerImage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalUserModel].
extension LocalUserModelPatterns on LocalUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalUserModel value)  $default,){
final _that = this;
switch (_that) {
case _LocalUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _LocalUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalUserModel() when $default != null:
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage)  $default,) {final _that = this;
switch (_that) {
case _LocalUserModel():
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String name, @SettingsConverter()@HiveField(2)  Settings settings, @HiveField(3)  String avatarImage, @HiveField(4)  String bannerImage)?  $default,) {final _that = this;
switch (_that) {
case _LocalUserModel() when $default != null:
return $default(_that.id,_that.name,_that.settings,_that.avatarImage,_that.bannerImage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LocalUserModel extends LocalUserModel {
  const _LocalUserModel({@HiveField(0) required this.id, @HiveField(1) required this.name, @SettingsConverter()@HiveField(2) required this.settings, @HiveField(3) required this.avatarImage, @HiveField(4) required this.bannerImage}): super._();
  factory _LocalUserModel.fromJson(Map<String, dynamic> json) => _$LocalUserModelFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String name;
@override@SettingsConverter()@HiveField(2) final  Settings settings;
@override@HiveField(3) final  String avatarImage;
@override@HiveField(4) final  String bannerImage;

/// Create a copy of LocalUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalUserModelCopyWith<_LocalUserModel> get copyWith => __$LocalUserModelCopyWithImpl<_LocalUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocalUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.bannerImage, bannerImage) || other.bannerImage == bannerImage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,settings,avatarImage,bannerImage);

@override
String toString() {
  return 'LocalUserModel(id: $id, name: $name, settings: $settings, avatarImage: $avatarImage, bannerImage: $bannerImage)';
}


}

/// @nodoc
abstract mixin class _$LocalUserModelCopyWith<$Res> implements $LocalUserModelCopyWith<$Res> {
  factory _$LocalUserModelCopyWith(_LocalUserModel value, $Res Function(_LocalUserModel) _then) = __$LocalUserModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String name,@SettingsConverter()@HiveField(2) Settings settings,@HiveField(3) String avatarImage,@HiveField(4) String bannerImage
});




}
/// @nodoc
class __$LocalUserModelCopyWithImpl<$Res>
    implements _$LocalUserModelCopyWith<$Res> {
  __$LocalUserModelCopyWithImpl(this._self, this._then);

  final _LocalUserModel _self;
  final $Res Function(_LocalUserModel) _then;

/// Create a copy of LocalUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? settings = null,Object? avatarImage = null,Object? bannerImage = null,}) {
  return _then(_LocalUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Settings,avatarImage: null == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String,bannerImage: null == bannerImage ? _self.bannerImage : bannerImage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
