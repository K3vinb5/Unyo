// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anilist_media_character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnilistMediaCharacterModel {

 int get id; String get image; String get name; String get gender; String get description; String get dateOfBirth; int get age;
/// Create a copy of AnilistMediaCharacterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnilistMediaCharacterModelCopyWith<AnilistMediaCharacterModel> get copyWith => _$AnilistMediaCharacterModelCopyWithImpl<AnilistMediaCharacterModel>(this as AnilistMediaCharacterModel, _$identity);

  /// Serializes this AnilistMediaCharacterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnilistMediaCharacterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.image, image) || other.image == image)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,image,name,gender,description,dateOfBirth,age);



}

/// @nodoc
abstract mixin class $AnilistMediaCharacterModelCopyWith<$Res>  {
  factory $AnilistMediaCharacterModelCopyWith(AnilistMediaCharacterModel value, $Res Function(AnilistMediaCharacterModel) _then) = _$AnilistMediaCharacterModelCopyWithImpl;
@useResult
$Res call({
 int id, String image, String name, String gender, String description, String dateOfBirth, int age
});




}
/// @nodoc
class _$AnilistMediaCharacterModelCopyWithImpl<$Res>
    implements $AnilistMediaCharacterModelCopyWith<$Res> {
  _$AnilistMediaCharacterModelCopyWithImpl(this._self, this._then);

  final AnilistMediaCharacterModel _self;
  final $Res Function(AnilistMediaCharacterModel) _then;

/// Create a copy of AnilistMediaCharacterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? image = null,Object? name = null,Object? gender = null,Object? description = null,Object? dateOfBirth = null,Object? age = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AnilistMediaCharacterModel].
extension AnilistMediaCharacterModelPatterns on AnilistMediaCharacterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnilistMediaCharacterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnilistMediaCharacterModel value)  $default,){
final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnilistMediaCharacterModel value)?  $default,){
final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String image,  String name,  String gender,  String description,  String dateOfBirth,  int age)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel() when $default != null:
return $default(_that.id,_that.image,_that.name,_that.gender,_that.description,_that.dateOfBirth,_that.age);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String image,  String name,  String gender,  String description,  String dateOfBirth,  int age)  $default,) {final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel():
return $default(_that.id,_that.image,_that.name,_that.gender,_that.description,_that.dateOfBirth,_that.age);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String image,  String name,  String gender,  String description,  String dateOfBirth,  int age)?  $default,) {final _that = this;
switch (_that) {
case _AnilistMediaCharacterModel() when $default != null:
return $default(_that.id,_that.image,_that.name,_that.gender,_that.description,_that.dateOfBirth,_that.age);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnilistMediaCharacterModel implements AnilistMediaCharacterModel {
  const _AnilistMediaCharacterModel({required this.id, required this.image, required this.name, required this.gender, required this.description, required this.dateOfBirth, required this.age});
  factory _AnilistMediaCharacterModel.fromJson(Map<String, dynamic> json) => _$AnilistMediaCharacterModelFromJson(json);

@override final  int id;
@override final  String image;
@override final  String name;
@override final  String gender;
@override final  String description;
@override final  String dateOfBirth;
@override final  int age;

/// Create a copy of AnilistMediaCharacterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnilistMediaCharacterModelCopyWith<_AnilistMediaCharacterModel> get copyWith => __$AnilistMediaCharacterModelCopyWithImpl<_AnilistMediaCharacterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnilistMediaCharacterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnilistMediaCharacterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.image, image) || other.image == image)&&(identical(other.name, name) || other.name == name)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.description, description) || other.description == description)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.age, age) || other.age == age));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,image,name,gender,description,dateOfBirth,age);



}

/// @nodoc
abstract mixin class _$AnilistMediaCharacterModelCopyWith<$Res> implements $AnilistMediaCharacterModelCopyWith<$Res> {
  factory _$AnilistMediaCharacterModelCopyWith(_AnilistMediaCharacterModel value, $Res Function(_AnilistMediaCharacterModel) _then) = __$AnilistMediaCharacterModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String image, String name, String gender, String description, String dateOfBirth, int age
});




}
/// @nodoc
class __$AnilistMediaCharacterModelCopyWithImpl<$Res>
    implements _$AnilistMediaCharacterModelCopyWith<$Res> {
  __$AnilistMediaCharacterModelCopyWithImpl(this._self, this._then);

  final _AnilistMediaCharacterModel _self;
  final $Res Function(_AnilistMediaCharacterModel) _then;

/// Create a copy of AnilistMediaCharacterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? image = null,Object? name = null,Object? gender = null,Object? description = null,Object? dateOfBirth = null,Object? age = null,}) {
  return _then(_AnilistMediaCharacterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
