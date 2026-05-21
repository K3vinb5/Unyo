// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_list_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaListEntryModel {

@HiveField(0) int get progress;@HiveField(1) int get progressVolumes;@HiveField(2) double get score;@HiveField(3) int get repeat;@HiveField(4) String get status;@HiveField(5) List<String> get startedAt;@HiveField(6) List<String> get completedAt;
/// Create a copy of MediaListEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaListEntryModelCopyWith<MediaListEntryModel> get copyWith => _$MediaListEntryModelCopyWithImpl<MediaListEntryModel>(this as MediaListEntryModel, _$identity);

  /// Serializes this MediaListEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaListEntryModel&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.progressVolumes, progressVolumes) || other.progressVolumes == progressVolumes)&&(identical(other.score, score) || other.score == score)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.startedAt, startedAt)&&const DeepCollectionEquality().equals(other.completedAt, completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,progress,progressVolumes,score,repeat,status,const DeepCollectionEquality().hash(startedAt),const DeepCollectionEquality().hash(completedAt));

@override
String toString() {
  return 'MediaListEntryModel(progress: $progress, progressVolumes: $progressVolumes, score: $score, repeat: $repeat, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $MediaListEntryModelCopyWith<$Res>  {
  factory $MediaListEntryModelCopyWith(MediaListEntryModel value, $Res Function(MediaListEntryModel) _then) = _$MediaListEntryModelCopyWithImpl;
@useResult
$Res call({
@HiveField(0) int progress,@HiveField(1) int progressVolumes,@HiveField(2) double score,@HiveField(3) int repeat,@HiveField(4) String status,@HiveField(5) List<String> startedAt,@HiveField(6) List<String> completedAt
});




}
/// @nodoc
class _$MediaListEntryModelCopyWithImpl<$Res>
    implements $MediaListEntryModelCopyWith<$Res> {
  _$MediaListEntryModelCopyWithImpl(this._self, this._then);

  final MediaListEntryModel _self;
  final $Res Function(MediaListEntryModel) _then;

/// Create a copy of MediaListEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progress = null,Object? progressVolumes = null,Object? score = null,Object? repeat = null,Object? status = null,Object? startedAt = null,Object? completedAt = null,}) {
  return _then(_self.copyWith(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,progressVolumes: null == progressVolumes ? _self.progressVolumes : progressVolumes // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as List<String>,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaListEntryModel].
extension MediaListEntryModelPatterns on MediaListEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaListEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaListEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaListEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaListEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaListEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaListEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  int progress, @HiveField(1)  int progressVolumes, @HiveField(2)  double score, @HiveField(3)  int repeat, @HiveField(4)  String status, @HiveField(5)  List<String> startedAt, @HiveField(6)  List<String> completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaListEntryModel() when $default != null:
return $default(_that.progress,_that.progressVolumes,_that.score,_that.repeat,_that.status,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  int progress, @HiveField(1)  int progressVolumes, @HiveField(2)  double score, @HiveField(3)  int repeat, @HiveField(4)  String status, @HiveField(5)  List<String> startedAt, @HiveField(6)  List<String> completedAt)  $default,) {final _that = this;
switch (_that) {
case _MediaListEntryModel():
return $default(_that.progress,_that.progressVolumes,_that.score,_that.repeat,_that.status,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  int progress, @HiveField(1)  int progressVolumes, @HiveField(2)  double score, @HiveField(3)  int repeat, @HiveField(4)  String status, @HiveField(5)  List<String> startedAt, @HiveField(6)  List<String> completedAt)?  $default,) {final _that = this;
switch (_that) {
case _MediaListEntryModel() when $default != null:
return $default(_that.progress,_that.progressVolumes,_that.score,_that.repeat,_that.status,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaListEntryModel implements MediaListEntryModel {
  const _MediaListEntryModel({@HiveField(0) required this.progress, @HiveField(1) required this.progressVolumes, @HiveField(2) required this.score, @HiveField(3) required this.repeat, @HiveField(4) required this.status, @HiveField(5) required final  List<String> startedAt, @HiveField(6) required final  List<String> completedAt}): _startedAt = startedAt,_completedAt = completedAt;
  factory _MediaListEntryModel.fromJson(Map<String, dynamic> json) => _$MediaListEntryModelFromJson(json);

@override@HiveField(0) final  int progress;
@override@HiveField(1) final  int progressVolumes;
@override@HiveField(2) final  double score;
@override@HiveField(3) final  int repeat;
@override@HiveField(4) final  String status;
 final  List<String> _startedAt;
@override@HiveField(5) List<String> get startedAt {
  if (_startedAt is EqualUnmodifiableListView) return _startedAt;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_startedAt);
}

 final  List<String> _completedAt;
@override@HiveField(6) List<String> get completedAt {
  if (_completedAt is EqualUnmodifiableListView) return _completedAt;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedAt);
}


/// Create a copy of MediaListEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaListEntryModelCopyWith<_MediaListEntryModel> get copyWith => __$MediaListEntryModelCopyWithImpl<_MediaListEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaListEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaListEntryModel&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.progressVolumes, progressVolumes) || other.progressVolumes == progressVolumes)&&(identical(other.score, score) || other.score == score)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._startedAt, _startedAt)&&const DeepCollectionEquality().equals(other._completedAt, _completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,progress,progressVolumes,score,repeat,status,const DeepCollectionEquality().hash(_startedAt),const DeepCollectionEquality().hash(_completedAt));

@override
String toString() {
  return 'MediaListEntryModel(progress: $progress, progressVolumes: $progressVolumes, score: $score, repeat: $repeat, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaListEntryModelCopyWith<$Res> implements $MediaListEntryModelCopyWith<$Res> {
  factory _$MediaListEntryModelCopyWith(_MediaListEntryModel value, $Res Function(_MediaListEntryModel) _then) = __$MediaListEntryModelCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) int progress,@HiveField(1) int progressVolumes,@HiveField(2) double score,@HiveField(3) int repeat,@HiveField(4) String status,@HiveField(5) List<String> startedAt,@HiveField(6) List<String> completedAt
});




}
/// @nodoc
class __$MediaListEntryModelCopyWithImpl<$Res>
    implements _$MediaListEntryModelCopyWith<$Res> {
  __$MediaListEntryModelCopyWithImpl(this._self, this._then);

  final _MediaListEntryModel _self;
  final $Res Function(_MediaListEntryModel) _then;

/// Create a copy of MediaListEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? progressVolumes = null,Object? score = null,Object? repeat = null,Object? status = null,Object? startedAt = null,Object? completedAt = null,}) {
  return _then(_MediaListEntryModel(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,progressVolumes: null == progressVolumes ? _self.progressVolumes : progressVolumes // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self._startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as List<String>,completedAt: null == completedAt ? _self._completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
