// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'torrent_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TorrentStatusModel {

 String get hash; String get name; String get title; String get poster; String get category; int get stat; String? get statString; double? get downloadSpeed; double? get uploadSpeed; int? get activePeers; int? get totalPeers; int? get connectedSeeders; int? get torrentSize; int? get preloadedBytes; int? get preloadSize; List<TorrentFileStat> get fileStats;
/// Create a copy of TorrentStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TorrentStatusModelCopyWith<TorrentStatusModel> get copyWith => _$TorrentStatusModelCopyWithImpl<TorrentStatusModel>(this as TorrentStatusModel, _$identity);

  /// Serializes this TorrentStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TorrentStatusModel&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.category, category) || other.category == category)&&(identical(other.stat, stat) || other.stat == stat)&&(identical(other.statString, statString) || other.statString == statString)&&(identical(other.downloadSpeed, downloadSpeed) || other.downloadSpeed == downloadSpeed)&&(identical(other.uploadSpeed, uploadSpeed) || other.uploadSpeed == uploadSpeed)&&(identical(other.activePeers, activePeers) || other.activePeers == activePeers)&&(identical(other.totalPeers, totalPeers) || other.totalPeers == totalPeers)&&(identical(other.connectedSeeders, connectedSeeders) || other.connectedSeeders == connectedSeeders)&&(identical(other.torrentSize, torrentSize) || other.torrentSize == torrentSize)&&(identical(other.preloadedBytes, preloadedBytes) || other.preloadedBytes == preloadedBytes)&&(identical(other.preloadSize, preloadSize) || other.preloadSize == preloadSize)&&const DeepCollectionEquality().equals(other.fileStats, fileStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,name,title,poster,category,stat,statString,downloadSpeed,uploadSpeed,activePeers,totalPeers,connectedSeeders,torrentSize,preloadedBytes,preloadSize,const DeepCollectionEquality().hash(fileStats));

@override
String toString() {
  return 'TorrentStatusModel(hash: $hash, name: $name, title: $title, poster: $poster, category: $category, stat: $stat, statString: $statString, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, activePeers: $activePeers, totalPeers: $totalPeers, connectedSeeders: $connectedSeeders, torrentSize: $torrentSize, preloadedBytes: $preloadedBytes, preloadSize: $preloadSize, fileStats: $fileStats)';
}


}

/// @nodoc
abstract mixin class $TorrentStatusModelCopyWith<$Res>  {
  factory $TorrentStatusModelCopyWith(TorrentStatusModel value, $Res Function(TorrentStatusModel) _then) = _$TorrentStatusModelCopyWithImpl;
@useResult
$Res call({
 String hash, String name, String title, String poster, String category, int stat, String? statString, double? downloadSpeed, double? uploadSpeed, int? activePeers, int? totalPeers, int? connectedSeeders, int? torrentSize, int? preloadedBytes, int? preloadSize, List<TorrentFileStat> fileStats
});




}
/// @nodoc
class _$TorrentStatusModelCopyWithImpl<$Res>
    implements $TorrentStatusModelCopyWith<$Res> {
  _$TorrentStatusModelCopyWithImpl(this._self, this._then);

  final TorrentStatusModel _self;
  final $Res Function(TorrentStatusModel) _then;

/// Create a copy of TorrentStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hash = null,Object? name = null,Object? title = null,Object? poster = null,Object? category = null,Object? stat = null,Object? statString = freezed,Object? downloadSpeed = freezed,Object? uploadSpeed = freezed,Object? activePeers = freezed,Object? totalPeers = freezed,Object? connectedSeeders = freezed,Object? torrentSize = freezed,Object? preloadedBytes = freezed,Object? preloadSize = freezed,Object? fileStats = null,}) {
  return _then(_self.copyWith(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,poster: null == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,stat: null == stat ? _self.stat : stat // ignore: cast_nullable_to_non_nullable
as int,statString: freezed == statString ? _self.statString : statString // ignore: cast_nullable_to_non_nullable
as String?,downloadSpeed: freezed == downloadSpeed ? _self.downloadSpeed : downloadSpeed // ignore: cast_nullable_to_non_nullable
as double?,uploadSpeed: freezed == uploadSpeed ? _self.uploadSpeed : uploadSpeed // ignore: cast_nullable_to_non_nullable
as double?,activePeers: freezed == activePeers ? _self.activePeers : activePeers // ignore: cast_nullable_to_non_nullable
as int?,totalPeers: freezed == totalPeers ? _self.totalPeers : totalPeers // ignore: cast_nullable_to_non_nullable
as int?,connectedSeeders: freezed == connectedSeeders ? _self.connectedSeeders : connectedSeeders // ignore: cast_nullable_to_non_nullable
as int?,torrentSize: freezed == torrentSize ? _self.torrentSize : torrentSize // ignore: cast_nullable_to_non_nullable
as int?,preloadedBytes: freezed == preloadedBytes ? _self.preloadedBytes : preloadedBytes // ignore: cast_nullable_to_non_nullable
as int?,preloadSize: freezed == preloadSize ? _self.preloadSize : preloadSize // ignore: cast_nullable_to_non_nullable
as int?,fileStats: null == fileStats ? _self.fileStats : fileStats // ignore: cast_nullable_to_non_nullable
as List<TorrentFileStat>,
  ));
}

}


/// Adds pattern-matching-related methods to [TorrentStatusModel].
extension TorrentStatusModelPatterns on TorrentStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TorrentStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TorrentStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TorrentStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _TorrentStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TorrentStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _TorrentStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hash,  String name,  String title,  String poster,  String category,  int stat,  String? statString,  double? downloadSpeed,  double? uploadSpeed,  int? activePeers,  int? totalPeers,  int? connectedSeeders,  int? torrentSize,  int? preloadedBytes,  int? preloadSize,  List<TorrentFileStat> fileStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TorrentStatusModel() when $default != null:
return $default(_that.hash,_that.name,_that.title,_that.poster,_that.category,_that.stat,_that.statString,_that.downloadSpeed,_that.uploadSpeed,_that.activePeers,_that.totalPeers,_that.connectedSeeders,_that.torrentSize,_that.preloadedBytes,_that.preloadSize,_that.fileStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hash,  String name,  String title,  String poster,  String category,  int stat,  String? statString,  double? downloadSpeed,  double? uploadSpeed,  int? activePeers,  int? totalPeers,  int? connectedSeeders,  int? torrentSize,  int? preloadedBytes,  int? preloadSize,  List<TorrentFileStat> fileStats)  $default,) {final _that = this;
switch (_that) {
case _TorrentStatusModel():
return $default(_that.hash,_that.name,_that.title,_that.poster,_that.category,_that.stat,_that.statString,_that.downloadSpeed,_that.uploadSpeed,_that.activePeers,_that.totalPeers,_that.connectedSeeders,_that.torrentSize,_that.preloadedBytes,_that.preloadSize,_that.fileStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hash,  String name,  String title,  String poster,  String category,  int stat,  String? statString,  double? downloadSpeed,  double? uploadSpeed,  int? activePeers,  int? totalPeers,  int? connectedSeeders,  int? torrentSize,  int? preloadedBytes,  int? preloadSize,  List<TorrentFileStat> fileStats)?  $default,) {final _that = this;
switch (_that) {
case _TorrentStatusModel() when $default != null:
return $default(_that.hash,_that.name,_that.title,_that.poster,_that.category,_that.stat,_that.statString,_that.downloadSpeed,_that.uploadSpeed,_that.activePeers,_that.totalPeers,_that.connectedSeeders,_that.torrentSize,_that.preloadedBytes,_that.preloadSize,_that.fileStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TorrentStatusModel implements TorrentStatusModel {
  const _TorrentStatusModel({required this.hash, required this.name, required this.title, required this.poster, required this.category, required this.stat, this.statString, this.downloadSpeed, this.uploadSpeed, this.activePeers, this.totalPeers, this.connectedSeeders, this.torrentSize, this.preloadedBytes, this.preloadSize, final  List<TorrentFileStat> fileStats = const <TorrentFileStat>[]}): _fileStats = fileStats;
  factory _TorrentStatusModel.fromJson(Map<String, dynamic> json) => _$TorrentStatusModelFromJson(json);

@override final  String hash;
@override final  String name;
@override final  String title;
@override final  String poster;
@override final  String category;
@override final  int stat;
@override final  String? statString;
@override final  double? downloadSpeed;
@override final  double? uploadSpeed;
@override final  int? activePeers;
@override final  int? totalPeers;
@override final  int? connectedSeeders;
@override final  int? torrentSize;
@override final  int? preloadedBytes;
@override final  int? preloadSize;
 final  List<TorrentFileStat> _fileStats;
@override@JsonKey() List<TorrentFileStat> get fileStats {
  if (_fileStats is EqualUnmodifiableListView) return _fileStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fileStats);
}


/// Create a copy of TorrentStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TorrentStatusModelCopyWith<_TorrentStatusModel> get copyWith => __$TorrentStatusModelCopyWithImpl<_TorrentStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TorrentStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TorrentStatusModel&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.category, category) || other.category == category)&&(identical(other.stat, stat) || other.stat == stat)&&(identical(other.statString, statString) || other.statString == statString)&&(identical(other.downloadSpeed, downloadSpeed) || other.downloadSpeed == downloadSpeed)&&(identical(other.uploadSpeed, uploadSpeed) || other.uploadSpeed == uploadSpeed)&&(identical(other.activePeers, activePeers) || other.activePeers == activePeers)&&(identical(other.totalPeers, totalPeers) || other.totalPeers == totalPeers)&&(identical(other.connectedSeeders, connectedSeeders) || other.connectedSeeders == connectedSeeders)&&(identical(other.torrentSize, torrentSize) || other.torrentSize == torrentSize)&&(identical(other.preloadedBytes, preloadedBytes) || other.preloadedBytes == preloadedBytes)&&(identical(other.preloadSize, preloadSize) || other.preloadSize == preloadSize)&&const DeepCollectionEquality().equals(other._fileStats, _fileStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,name,title,poster,category,stat,statString,downloadSpeed,uploadSpeed,activePeers,totalPeers,connectedSeeders,torrentSize,preloadedBytes,preloadSize,const DeepCollectionEquality().hash(_fileStats));

@override
String toString() {
  return 'TorrentStatusModel(hash: $hash, name: $name, title: $title, poster: $poster, category: $category, stat: $stat, statString: $statString, downloadSpeed: $downloadSpeed, uploadSpeed: $uploadSpeed, activePeers: $activePeers, totalPeers: $totalPeers, connectedSeeders: $connectedSeeders, torrentSize: $torrentSize, preloadedBytes: $preloadedBytes, preloadSize: $preloadSize, fileStats: $fileStats)';
}


}

/// @nodoc
abstract mixin class _$TorrentStatusModelCopyWith<$Res> implements $TorrentStatusModelCopyWith<$Res> {
  factory _$TorrentStatusModelCopyWith(_TorrentStatusModel value, $Res Function(_TorrentStatusModel) _then) = __$TorrentStatusModelCopyWithImpl;
@override @useResult
$Res call({
 String hash, String name, String title, String poster, String category, int stat, String? statString, double? downloadSpeed, double? uploadSpeed, int? activePeers, int? totalPeers, int? connectedSeeders, int? torrentSize, int? preloadedBytes, int? preloadSize, List<TorrentFileStat> fileStats
});




}
/// @nodoc
class __$TorrentStatusModelCopyWithImpl<$Res>
    implements _$TorrentStatusModelCopyWith<$Res> {
  __$TorrentStatusModelCopyWithImpl(this._self, this._then);

  final _TorrentStatusModel _self;
  final $Res Function(_TorrentStatusModel) _then;

/// Create a copy of TorrentStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hash = null,Object? name = null,Object? title = null,Object? poster = null,Object? category = null,Object? stat = null,Object? statString = freezed,Object? downloadSpeed = freezed,Object? uploadSpeed = freezed,Object? activePeers = freezed,Object? totalPeers = freezed,Object? connectedSeeders = freezed,Object? torrentSize = freezed,Object? preloadedBytes = freezed,Object? preloadSize = freezed,Object? fileStats = null,}) {
  return _then(_TorrentStatusModel(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,poster: null == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,stat: null == stat ? _self.stat : stat // ignore: cast_nullable_to_non_nullable
as int,statString: freezed == statString ? _self.statString : statString // ignore: cast_nullable_to_non_nullable
as String?,downloadSpeed: freezed == downloadSpeed ? _self.downloadSpeed : downloadSpeed // ignore: cast_nullable_to_non_nullable
as double?,uploadSpeed: freezed == uploadSpeed ? _self.uploadSpeed : uploadSpeed // ignore: cast_nullable_to_non_nullable
as double?,activePeers: freezed == activePeers ? _self.activePeers : activePeers // ignore: cast_nullable_to_non_nullable
as int?,totalPeers: freezed == totalPeers ? _self.totalPeers : totalPeers // ignore: cast_nullable_to_non_nullable
as int?,connectedSeeders: freezed == connectedSeeders ? _self.connectedSeeders : connectedSeeders // ignore: cast_nullable_to_non_nullable
as int?,torrentSize: freezed == torrentSize ? _self.torrentSize : torrentSize // ignore: cast_nullable_to_non_nullable
as int?,preloadedBytes: freezed == preloadedBytes ? _self.preloadedBytes : preloadedBytes // ignore: cast_nullable_to_non_nullable
as int?,preloadSize: freezed == preloadSize ? _self.preloadSize : preloadSize // ignore: cast_nullable_to_non_nullable
as int?,fileStats: null == fileStats ? _self._fileStats : fileStats // ignore: cast_nullable_to_non_nullable
as List<TorrentFileStat>,
  ));
}


}

// dart format on
