// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extension.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExtensionModel {

@HiveField(0) String get name;@HiveField(1) String get pkg;@HiveField(2) String get apk;@HiveField(3) String get icon;@HiveField(4) String get lang;@HiveField(5) String get version;@HiveField(6) int get nsfw;@HiveField(7) String get type;@HiveField(8) String get repositoryUrl;
/// Create a copy of ExtensionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExtensionModelCopyWith<ExtensionModel> get copyWith => _$ExtensionModelCopyWithImpl<ExtensionModel>(this as ExtensionModel, _$identity);

  /// Serializes this ExtensionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExtensionModel&&(identical(other.name, name) || other.name == name)&&(identical(other.pkg, pkg) || other.pkg == pkg)&&(identical(other.apk, apk) || other.apk == apk)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.version, version) || other.version == version)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw)&&(identical(other.type, type) || other.type == type)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,pkg,apk,icon,lang,version,nsfw,type,repositoryUrl);



}

/// @nodoc
abstract mixin class $ExtensionModelCopyWith<$Res>  {
  factory $ExtensionModelCopyWith(ExtensionModel value, $Res Function(ExtensionModel) _then) = _$ExtensionModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String name,@HiveField(1) String pkg,@HiveField(2) String apk,@HiveField(3) String icon,@HiveField(4) String lang,@HiveField(5) String version,@HiveField(6) int nsfw,@HiveField(7) String type,@HiveField(8) String repositoryUrl
});




}
/// @nodoc
class _$ExtensionModelCopyWithImpl<$Res>
    implements $ExtensionModelCopyWith<$Res> {
  _$ExtensionModelCopyWithImpl(this._self, this._then);

  final ExtensionModel _self;
  final $Res Function(ExtensionModel) _then;

/// Create a copy of ExtensionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? pkg = null,Object? apk = null,Object? icon = null,Object? lang = null,Object? version = null,Object? nsfw = null,Object? type = null,Object? repositoryUrl = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pkg: null == pkg ? _self.pkg : pkg // ignore: cast_nullable_to_non_nullable
as String,apk: null == apk ? _self.apk : apk // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,repositoryUrl: null == repositoryUrl ? _self.repositoryUrl : repositoryUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExtensionModel].
extension ExtensionModelPatterns on ExtensionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExtensionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExtensionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExtensionModel value)  $default,){
final _that = this;
switch (_that) {
case _ExtensionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExtensionModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExtensionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String name, @HiveField(1)  String pkg, @HiveField(2)  String apk, @HiveField(3)  String icon, @HiveField(4)  String lang, @HiveField(5)  String version, @HiveField(6)  int nsfw, @HiveField(7)  String type, @HiveField(8)  String repositoryUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExtensionModel() when $default != null:
return $default(_that.name,_that.pkg,_that.apk,_that.icon,_that.lang,_that.version,_that.nsfw,_that.type,_that.repositoryUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String name, @HiveField(1)  String pkg, @HiveField(2)  String apk, @HiveField(3)  String icon, @HiveField(4)  String lang, @HiveField(5)  String version, @HiveField(6)  int nsfw, @HiveField(7)  String type, @HiveField(8)  String repositoryUrl)  $default,) {final _that = this;
switch (_that) {
case _ExtensionModel():
return $default(_that.name,_that.pkg,_that.apk,_that.icon,_that.lang,_that.version,_that.nsfw,_that.type,_that.repositoryUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String name, @HiveField(1)  String pkg, @HiveField(2)  String apk, @HiveField(3)  String icon, @HiveField(4)  String lang, @HiveField(5)  String version, @HiveField(6)  int nsfw, @HiveField(7)  String type, @HiveField(8)  String repositoryUrl)?  $default,) {final _that = this;
switch (_that) {
case _ExtensionModel() when $default != null:
return $default(_that.name,_that.pkg,_that.apk,_that.icon,_that.lang,_that.version,_that.nsfw,_that.type,_that.repositoryUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExtensionModel implements ExtensionModel {
  const _ExtensionModel({@HiveField(0) required this.name, @HiveField(1) required this.pkg, @HiveField(2) required this.apk, @HiveField(3) required this.icon, @HiveField(4) required this.lang, @HiveField(5) required this.version, @HiveField(6) required this.nsfw, @HiveField(7) required this.type, @HiveField(8) this.repositoryUrl = ""});
  factory _ExtensionModel.fromJson(Map<String, dynamic> json) => _$ExtensionModelFromJson(json);

@override@HiveField(0) final  String name;
@override@HiveField(1) final  String pkg;
@override@HiveField(2) final  String apk;
@override@HiveField(3) final  String icon;
@override@HiveField(4) final  String lang;
@override@HiveField(5) final  String version;
@override@HiveField(6) final  int nsfw;
@override@HiveField(7) final  String type;
@override@JsonKey()@HiveField(8) final  String repositoryUrl;

/// Create a copy of ExtensionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExtensionModelCopyWith<_ExtensionModel> get copyWith => __$ExtensionModelCopyWithImpl<_ExtensionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExtensionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExtensionModel&&(identical(other.name, name) || other.name == name)&&(identical(other.pkg, pkg) || other.pkg == pkg)&&(identical(other.apk, apk) || other.apk == apk)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.version, version) || other.version == version)&&(identical(other.nsfw, nsfw) || other.nsfw == nsfw)&&(identical(other.type, type) || other.type == type)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,pkg,apk,icon,lang,version,nsfw,type,repositoryUrl);



}

/// @nodoc
abstract mixin class _$ExtensionModelCopyWith<$Res> implements $ExtensionModelCopyWith<$Res> {
  factory _$ExtensionModelCopyWith(_ExtensionModel value, $Res Function(_ExtensionModel) _then) = __$ExtensionModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String name,@HiveField(1) String pkg,@HiveField(2) String apk,@HiveField(3) String icon,@HiveField(4) String lang,@HiveField(5) String version,@HiveField(6) int nsfw,@HiveField(7) String type,@HiveField(8) String repositoryUrl
});




}
/// @nodoc
class __$ExtensionModelCopyWithImpl<$Res>
    implements _$ExtensionModelCopyWith<$Res> {
  __$ExtensionModelCopyWithImpl(this._self, this._then);

  final _ExtensionModel _self;
  final $Res Function(_ExtensionModel) _then;

/// Create a copy of ExtensionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? pkg = null,Object? apk = null,Object? icon = null,Object? lang = null,Object? version = null,Object? nsfw = null,Object? type = null,Object? repositoryUrl = null,}) {
  return _then(_ExtensionModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pkg: null == pkg ? _self.pkg : pkg // ignore: cast_nullable_to_non_nullable
as String,apk: null == apk ? _self.apk : apk // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,nsfw: null == nsfw ? _self.nsfw : nsfw // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,repositoryUrl: null == repositoryUrl ? _self.repositoryUrl : repositoryUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
