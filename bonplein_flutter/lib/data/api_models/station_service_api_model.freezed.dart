// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'station_service_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReponseStations {

@JsonKey(name: 'total_count') int get totalCount; List<StationService> get results;
/// Create a copy of ReponseStations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReponseStationsCopyWith<ReponseStations> get copyWith => _$ReponseStationsCopyWithImpl<ReponseStations>(this as ReponseStations, _$identity);

  /// Serializes this ReponseStations to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReponseStations;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReponseStations&&(identical(other.totalCount, _this.totalCount) || other.totalCount == _this.totalCount)&&const DeepCollectionEquality().equals(other.results, _this.results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReponseStations;
  return Object.hash(runtimeType,_this.totalCount,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as ReponseStations;
  return 'ReponseStations(totalCount: ${_this.totalCount}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $ReponseStationsCopyWith<$Res>  {
  factory $ReponseStationsCopyWith(ReponseStations value, $Res Function(ReponseStations) _then) = _$ReponseStationsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_count') int totalCount, List<StationService> results
});




}
/// @nodoc
class _$ReponseStationsCopyWithImpl<$Res>
    implements $ReponseStationsCopyWith<$Res> {
  _$ReponseStationsCopyWithImpl(this._self, this._then);

  final ReponseStations _self;
  final $Res Function(ReponseStations) _then;

/// Create a copy of ReponseStations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? results = null,}) {
  return _then(ReponseStations(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<StationService>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReponseStations].
extension ReponseStationsPatterns on ReponseStations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReponseStations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReponseStations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReponseStations value)  $default,){
final _that = this;
switch (_that) {
case _ReponseStations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReponseStations value)?  $default,){
final _that = this;
switch (_that) {
case _ReponseStations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_count')  int totalCount,  List<StationService> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReponseStations() when $default != null:
return $default(_that.totalCount,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_count')  int totalCount,  List<StationService> results)  $default,) {final _that = this;
switch (_that) {
case _ReponseStations():
return $default(_that.totalCount,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_count')  int totalCount,  List<StationService> results)?  $default,) {final _that = this;
switch (_that) {
case _ReponseStations() when $default != null:
return $default(_that.totalCount,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReponseStations implements ReponseStations {
  const _ReponseStations({@JsonKey(name: 'total_count') required this.totalCount,  List<StationService> results = const []}): _results = results;
  factory _ReponseStations.fromJson(Map<String, dynamic> json) => _$ReponseStationsFromJson(json);

@override@JsonKey(name: 'total_count') final  int totalCount;
 final  List<StationService> _results;
@override@JsonKey() List<StationService> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ReponseStations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReponseStationsCopyWith<_ReponseStations> get copyWith => __$ReponseStationsCopyWithImpl<_ReponseStations>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReponseStationsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReponseStations&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalCount,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'ReponseStations(totalCount: $totalCount, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ReponseStationsCopyWith<$Res> implements $ReponseStationsCopyWith<$Res> {
  factory _$ReponseStationsCopyWith(_ReponseStations value, $Res Function(_ReponseStations) _then) = __$ReponseStationsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_count') int totalCount, List<StationService> results
});




}
/// @nodoc
class __$ReponseStationsCopyWithImpl<$Res>
    implements _$ReponseStationsCopyWith<$Res> {
  __$ReponseStationsCopyWithImpl(this._self, this._then);

  final _ReponseStations _self;
  final $Res Function(_ReponseStations) _then;

/// Create a copy of ReponseStations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? results = null,}) {
  return _then(_ReponseStations(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<StationService>,
  ));
}


}


/// @nodoc
mixin _$PointGeo {

 double get lon; double get lat;
/// Create a copy of PointGeo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointGeoCopyWith<PointGeo> get copyWith => _$PointGeoCopyWithImpl<PointGeo>(this as PointGeo, _$identity);

  /// Serializes this PointGeo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PointGeo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointGeo&&(identical(other.lon, _this.lon) || other.lon == _this.lon)&&(identical(other.lat, _this.lat) || other.lat == _this.lat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PointGeo;
  return Object.hash(runtimeType,_this.lon,_this.lat);
}

@override
String toString() {
  final _this = this as PointGeo;
  return 'PointGeo(lon: ${_this.lon}, lat: ${_this.lat})';
}


}

/// @nodoc
abstract mixin class $PointGeoCopyWith<$Res>  {
  factory $PointGeoCopyWith(PointGeo value, $Res Function(PointGeo) _then) = _$PointGeoCopyWithImpl;
@useResult
$Res call({
 double lon, double lat
});




}
/// @nodoc
class _$PointGeoCopyWithImpl<$Res>
    implements $PointGeoCopyWith<$Res> {
  _$PointGeoCopyWithImpl(this._self, this._then);

  final PointGeo _self;
  final $Res Function(PointGeo) _then;

/// Create a copy of PointGeo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lon = null,Object? lat = null,}) {
  return _then(PointGeo(
lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PointGeo].
extension PointGeoPatterns on PointGeo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointGeo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointGeo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointGeo value)  $default,){
final _that = this;
switch (_that) {
case _PointGeo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointGeo value)?  $default,){
final _that = this;
switch (_that) {
case _PointGeo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lon,  double lat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointGeo() when $default != null:
return $default(_that.lon,_that.lat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lon,  double lat)  $default,) {final _that = this;
switch (_that) {
case _PointGeo():
return $default(_that.lon,_that.lat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lon,  double lat)?  $default,) {final _that = this;
switch (_that) {
case _PointGeo() when $default != null:
return $default(_that.lon,_that.lat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointGeo implements PointGeo {
  const _PointGeo({required this.lon, required this.lat});
  factory _PointGeo.fromJson(Map<String, dynamic> json) => _$PointGeoFromJson(json);

@override final  double lon;
@override final  double lat;

/// Create a copy of PointGeo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointGeoCopyWith<_PointGeo> get copyWith => __$PointGeoCopyWithImpl<_PointGeo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointGeoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointGeo&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.lat, lat) || other.lat == lat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,lon,lat);
}

@override
String toString() {
    return 'PointGeo(lon: $lon, lat: $lat)';
}


}

/// @nodoc
abstract mixin class _$PointGeoCopyWith<$Res> implements $PointGeoCopyWith<$Res> {
  factory _$PointGeoCopyWith(_PointGeo value, $Res Function(_PointGeo) _then) = __$PointGeoCopyWithImpl;
@override @useResult
$Res call({
 double lon, double lat
});




}
/// @nodoc
class __$PointGeoCopyWithImpl<$Res>
    implements _$PointGeoCopyWith<$Res> {
  __$PointGeoCopyWithImpl(this._self, this._then);

  final _PointGeo _self;
  final $Res Function(_PointGeo) _then;

/// Create a copy of PointGeo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lon = null,Object? lat = null,}) {
  return _then(_PointGeo(
lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$StationService {

 int? get id; String? get latitude; String? get longitude; String? get cp; String? get pop; String? get adresse; String? get ville; PointGeo? get geom;@JsonKey(name: 'gazole_prix') double? get gazolePrix;@JsonKey(name: 'gazole_maj') DateTime? get gazoleMaj;@JsonKey(name: 'sp95_prix') double? get sp95Prix;@JsonKey(name: 'sp95_maj') DateTime? get sp95Maj;@JsonKey(name: 'e85_prix') double? get e85Prix;@JsonKey(name: 'e85_maj') DateTime? get e85Maj;@JsonKey(name: 'gplc_prix') double? get gplcPrix;@JsonKey(name: 'gplc_maj') DateTime? get gplcMaj;@JsonKey(name: 'e10_prix') double? get e10Prix;@JsonKey(name: 'e10_maj') DateTime? get e10Maj;@JsonKey(name: 'sp98_prix') double? get sp98Prix;@JsonKey(name: 'sp98_maj') DateTime? get sp98Maj;@JsonKey(name: 'carburants_disponibles') List<String>? get carburantsDisponibles;@JsonKey(name: 'carburants_indisponibles') List<String>? get carburantsIndisponibles;@JsonKey(name: 'carburants_rupture_temporaire') String? get carburantsRuptureTemporaire;@JsonKey(name: 'carburants_rupture_definitive') String? get carburantsRuptureDefinitive;@JsonKey(name: 'horaires_automate_24_24') String? get horairesAutomate2424;@JsonKey(name: 'services_service') List<String>? get servicesService; String? get departement;@JsonKey(name: 'code_departement') String? get codeDepartement; String? get region;@JsonKey(name: 'code_region') String? get codeRegion;
/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationServiceCopyWith<StationService> get copyWith => _$StationServiceCopyWithImpl<StationService>(this as StationService, _$identity);

  /// Serializes this StationService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StationService;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StationService&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.cp, _this.cp) || other.cp == _this.cp)&&(identical(other.pop, _this.pop) || other.pop == _this.pop)&&(identical(other.adresse, _this.adresse) || other.adresse == _this.adresse)&&(identical(other.ville, _this.ville) || other.ville == _this.ville)&&(identical(other.geom, _this.geom) || other.geom == _this.geom)&&(identical(other.gazolePrix, _this.gazolePrix) || other.gazolePrix == _this.gazolePrix)&&(identical(other.gazoleMaj, _this.gazoleMaj) || other.gazoleMaj == _this.gazoleMaj)&&(identical(other.sp95Prix, _this.sp95Prix) || other.sp95Prix == _this.sp95Prix)&&(identical(other.sp95Maj, _this.sp95Maj) || other.sp95Maj == _this.sp95Maj)&&(identical(other.e85Prix, _this.e85Prix) || other.e85Prix == _this.e85Prix)&&(identical(other.e85Maj, _this.e85Maj) || other.e85Maj == _this.e85Maj)&&(identical(other.gplcPrix, _this.gplcPrix) || other.gplcPrix == _this.gplcPrix)&&(identical(other.gplcMaj, _this.gplcMaj) || other.gplcMaj == _this.gplcMaj)&&(identical(other.e10Prix, _this.e10Prix) || other.e10Prix == _this.e10Prix)&&(identical(other.e10Maj, _this.e10Maj) || other.e10Maj == _this.e10Maj)&&(identical(other.sp98Prix, _this.sp98Prix) || other.sp98Prix == _this.sp98Prix)&&(identical(other.sp98Maj, _this.sp98Maj) || other.sp98Maj == _this.sp98Maj)&&const DeepCollectionEquality().equals(other.carburantsDisponibles, _this.carburantsDisponibles)&&const DeepCollectionEquality().equals(other.carburantsIndisponibles, _this.carburantsIndisponibles)&&(identical(other.carburantsRuptureTemporaire, _this.carburantsRuptureTemporaire) || other.carburantsRuptureTemporaire == _this.carburantsRuptureTemporaire)&&(identical(other.carburantsRuptureDefinitive, _this.carburantsRuptureDefinitive) || other.carburantsRuptureDefinitive == _this.carburantsRuptureDefinitive)&&(identical(other.horairesAutomate2424, _this.horairesAutomate2424) || other.horairesAutomate2424 == _this.horairesAutomate2424)&&const DeepCollectionEquality().equals(other.servicesService, _this.servicesService)&&(identical(other.departement, _this.departement) || other.departement == _this.departement)&&(identical(other.codeDepartement, _this.codeDepartement) || other.codeDepartement == _this.codeDepartement)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.codeRegion, _this.codeRegion) || other.codeRegion == _this.codeRegion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StationService;
  return Object.hashAll([runtimeType,_this.id,_this.latitude,_this.longitude,_this.cp,_this.pop,_this.adresse,_this.ville,_this.geom,_this.gazolePrix,_this.gazoleMaj,_this.sp95Prix,_this.sp95Maj,_this.e85Prix,_this.e85Maj,_this.gplcPrix,_this.gplcMaj,_this.e10Prix,_this.e10Maj,_this.sp98Prix,_this.sp98Maj,const DeepCollectionEquality().hash(_this.carburantsDisponibles),const DeepCollectionEquality().hash(_this.carburantsIndisponibles),_this.carburantsRuptureTemporaire,_this.carburantsRuptureDefinitive,_this.horairesAutomate2424,const DeepCollectionEquality().hash(_this.servicesService),_this.departement,_this.codeDepartement,_this.region,_this.codeRegion]);
}

@override
String toString() {
  final _this = this as StationService;
  return 'StationService(id: ${_this.id}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, cp: ${_this.cp}, pop: ${_this.pop}, adresse: ${_this.adresse}, ville: ${_this.ville}, geom: ${_this.geom}, gazolePrix: ${_this.gazolePrix}, gazoleMaj: ${_this.gazoleMaj}, sp95Prix: ${_this.sp95Prix}, sp95Maj: ${_this.sp95Maj}, e85Prix: ${_this.e85Prix}, e85Maj: ${_this.e85Maj}, gplcPrix: ${_this.gplcPrix}, gplcMaj: ${_this.gplcMaj}, e10Prix: ${_this.e10Prix}, e10Maj: ${_this.e10Maj}, sp98Prix: ${_this.sp98Prix}, sp98Maj: ${_this.sp98Maj}, carburantsDisponibles: ${_this.carburantsDisponibles}, carburantsIndisponibles: ${_this.carburantsIndisponibles}, carburantsRuptureTemporaire: ${_this.carburantsRuptureTemporaire}, carburantsRuptureDefinitive: ${_this.carburantsRuptureDefinitive}, horairesAutomate2424: ${_this.horairesAutomate2424}, servicesService: ${_this.servicesService}, departement: ${_this.departement}, codeDepartement: ${_this.codeDepartement}, region: ${_this.region}, codeRegion: ${_this.codeRegion})';
}


}

/// @nodoc
abstract mixin class $StationServiceCopyWith<$Res>  {
  factory $StationServiceCopyWith(StationService value, $Res Function(StationService) _then) = _$StationServiceCopyWithImpl;
@useResult
$Res call({
 int? id, String? latitude, String? longitude, String? cp, String? pop, String? adresse, String? ville, PointGeo? geom,@JsonKey(name: 'gazole_prix') double? gazolePrix,@JsonKey(name: 'gazole_maj') DateTime? gazoleMaj,@JsonKey(name: 'sp95_prix') double? sp95Prix,@JsonKey(name: 'sp95_maj') DateTime? sp95Maj,@JsonKey(name: 'e85_prix') double? e85Prix,@JsonKey(name: 'e85_maj') DateTime? e85Maj,@JsonKey(name: 'gplc_prix') double? gplcPrix,@JsonKey(name: 'gplc_maj') DateTime? gplcMaj,@JsonKey(name: 'e10_prix') double? e10Prix,@JsonKey(name: 'e10_maj') DateTime? e10Maj,@JsonKey(name: 'sp98_prix') double? sp98Prix,@JsonKey(name: 'sp98_maj') DateTime? sp98Maj,@JsonKey(name: 'carburants_disponibles') List<String>? carburantsDisponibles,@JsonKey(name: 'carburants_indisponibles') List<String>? carburantsIndisponibles,@JsonKey(name: 'carburants_rupture_temporaire') String? carburantsRuptureTemporaire,@JsonKey(name: 'carburants_rupture_definitive') String? carburantsRuptureDefinitive,@JsonKey(name: 'horaires_automate_24_24') String? horairesAutomate2424,@JsonKey(name: 'services_service') List<String>? servicesService, String? departement,@JsonKey(name: 'code_departement') String? codeDepartement, String? region,@JsonKey(name: 'code_region') String? codeRegion
});


$PointGeoCopyWith<$Res>? get geom;

}
/// @nodoc
class _$StationServiceCopyWithImpl<$Res>
    implements $StationServiceCopyWith<$Res> {
  _$StationServiceCopyWithImpl(this._self, this._then);

  final StationService _self;
  final $Res Function(StationService) _then;

/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? cp = freezed,Object? pop = freezed,Object? adresse = freezed,Object? ville = freezed,Object? geom = freezed,Object? gazolePrix = freezed,Object? gazoleMaj = freezed,Object? sp95Prix = freezed,Object? sp95Maj = freezed,Object? e85Prix = freezed,Object? e85Maj = freezed,Object? gplcPrix = freezed,Object? gplcMaj = freezed,Object? e10Prix = freezed,Object? e10Maj = freezed,Object? sp98Prix = freezed,Object? sp98Maj = freezed,Object? carburantsDisponibles = freezed,Object? carburantsIndisponibles = freezed,Object? carburantsRuptureTemporaire = freezed,Object? carburantsRuptureDefinitive = freezed,Object? horairesAutomate2424 = freezed,Object? servicesService = freezed,Object? departement = freezed,Object? codeDepartement = freezed,Object? region = freezed,Object? codeRegion = freezed,}) {
  return _then(StationService(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as String?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as String?,cp: freezed == cp ? _self.cp : cp // ignore: cast_nullable_to_non_nullable
as String?,pop: freezed == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as String?,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,ville: freezed == ville ? _self.ville : ville // ignore: cast_nullable_to_non_nullable
as String?,geom: freezed == geom ? _self.geom : geom // ignore: cast_nullable_to_non_nullable
as PointGeo?,gazolePrix: freezed == gazolePrix ? _self.gazolePrix : gazolePrix // ignore: cast_nullable_to_non_nullable
as double?,gazoleMaj: freezed == gazoleMaj ? _self.gazoleMaj : gazoleMaj // ignore: cast_nullable_to_non_nullable
as DateTime?,sp95Prix: freezed == sp95Prix ? _self.sp95Prix : sp95Prix // ignore: cast_nullable_to_non_nullable
as double?,sp95Maj: freezed == sp95Maj ? _self.sp95Maj : sp95Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,e85Prix: freezed == e85Prix ? _self.e85Prix : e85Prix // ignore: cast_nullable_to_non_nullable
as double?,e85Maj: freezed == e85Maj ? _self.e85Maj : e85Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,gplcPrix: freezed == gplcPrix ? _self.gplcPrix : gplcPrix // ignore: cast_nullable_to_non_nullable
as double?,gplcMaj: freezed == gplcMaj ? _self.gplcMaj : gplcMaj // ignore: cast_nullable_to_non_nullable
as DateTime?,e10Prix: freezed == e10Prix ? _self.e10Prix : e10Prix // ignore: cast_nullable_to_non_nullable
as double?,e10Maj: freezed == e10Maj ? _self.e10Maj : e10Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,sp98Prix: freezed == sp98Prix ? _self.sp98Prix : sp98Prix // ignore: cast_nullable_to_non_nullable
as double?,sp98Maj: freezed == sp98Maj ? _self.sp98Maj : sp98Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,carburantsDisponibles: freezed == carburantsDisponibles ? _self.carburantsDisponibles : carburantsDisponibles // ignore: cast_nullable_to_non_nullable
as List<String>?,carburantsIndisponibles: freezed == carburantsIndisponibles ? _self.carburantsIndisponibles : carburantsIndisponibles // ignore: cast_nullable_to_non_nullable
as List<String>?,carburantsRuptureTemporaire: freezed == carburantsRuptureTemporaire ? _self.carburantsRuptureTemporaire : carburantsRuptureTemporaire // ignore: cast_nullable_to_non_nullable
as String?,carburantsRuptureDefinitive: freezed == carburantsRuptureDefinitive ? _self.carburantsRuptureDefinitive : carburantsRuptureDefinitive // ignore: cast_nullable_to_non_nullable
as String?,horairesAutomate2424: freezed == horairesAutomate2424 ? _self.horairesAutomate2424 : horairesAutomate2424 // ignore: cast_nullable_to_non_nullable
as String?,servicesService: freezed == servicesService ? _self.servicesService : servicesService // ignore: cast_nullable_to_non_nullable
as List<String>?,departement: freezed == departement ? _self.departement : departement // ignore: cast_nullable_to_non_nullable
as String?,codeDepartement: freezed == codeDepartement ? _self.codeDepartement : codeDepartement // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,codeRegion: freezed == codeRegion ? _self.codeRegion : codeRegion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointGeoCopyWith<$Res>? get geom {
    if (_self.geom == null) {
    return null;
  }

  return $PointGeoCopyWith<$Res>(_self.geom!, (value) {
    return _then(_self.copyWith(geom: value));
  });
}
}


/// Adds pattern-matching-related methods to [StationService].
extension StationServicePatterns on StationService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StationService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StationService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StationService value)  $default,){
final _that = this;
switch (_that) {
case _StationService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StationService value)?  $default,){
final _that = this;
switch (_that) {
case _StationService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? latitude,  String? longitude,  String? cp,  String? pop,  String? adresse,  String? ville,  PointGeo? geom, @JsonKey(name: 'gazole_prix')  double? gazolePrix, @JsonKey(name: 'gazole_maj')  DateTime? gazoleMaj, @JsonKey(name: 'sp95_prix')  double? sp95Prix, @JsonKey(name: 'sp95_maj')  DateTime? sp95Maj, @JsonKey(name: 'e85_prix')  double? e85Prix, @JsonKey(name: 'e85_maj')  DateTime? e85Maj, @JsonKey(name: 'gplc_prix')  double? gplcPrix, @JsonKey(name: 'gplc_maj')  DateTime? gplcMaj, @JsonKey(name: 'e10_prix')  double? e10Prix, @JsonKey(name: 'e10_maj')  DateTime? e10Maj, @JsonKey(name: 'sp98_prix')  double? sp98Prix, @JsonKey(name: 'sp98_maj')  DateTime? sp98Maj, @JsonKey(name: 'carburants_disponibles')  List<String>? carburantsDisponibles, @JsonKey(name: 'carburants_indisponibles')  List<String>? carburantsIndisponibles, @JsonKey(name: 'carburants_rupture_temporaire')  String? carburantsRuptureTemporaire, @JsonKey(name: 'carburants_rupture_definitive')  String? carburantsRuptureDefinitive, @JsonKey(name: 'horaires_automate_24_24')  String? horairesAutomate2424, @JsonKey(name: 'services_service')  List<String>? servicesService,  String? departement, @JsonKey(name: 'code_departement')  String? codeDepartement,  String? region, @JsonKey(name: 'code_region')  String? codeRegion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StationService() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.cp,_that.pop,_that.adresse,_that.ville,_that.geom,_that.gazolePrix,_that.gazoleMaj,_that.sp95Prix,_that.sp95Maj,_that.e85Prix,_that.e85Maj,_that.gplcPrix,_that.gplcMaj,_that.e10Prix,_that.e10Maj,_that.sp98Prix,_that.sp98Maj,_that.carburantsDisponibles,_that.carburantsIndisponibles,_that.carburantsRuptureTemporaire,_that.carburantsRuptureDefinitive,_that.horairesAutomate2424,_that.servicesService,_that.departement,_that.codeDepartement,_that.region,_that.codeRegion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? latitude,  String? longitude,  String? cp,  String? pop,  String? adresse,  String? ville,  PointGeo? geom, @JsonKey(name: 'gazole_prix')  double? gazolePrix, @JsonKey(name: 'gazole_maj')  DateTime? gazoleMaj, @JsonKey(name: 'sp95_prix')  double? sp95Prix, @JsonKey(name: 'sp95_maj')  DateTime? sp95Maj, @JsonKey(name: 'e85_prix')  double? e85Prix, @JsonKey(name: 'e85_maj')  DateTime? e85Maj, @JsonKey(name: 'gplc_prix')  double? gplcPrix, @JsonKey(name: 'gplc_maj')  DateTime? gplcMaj, @JsonKey(name: 'e10_prix')  double? e10Prix, @JsonKey(name: 'e10_maj')  DateTime? e10Maj, @JsonKey(name: 'sp98_prix')  double? sp98Prix, @JsonKey(name: 'sp98_maj')  DateTime? sp98Maj, @JsonKey(name: 'carburants_disponibles')  List<String>? carburantsDisponibles, @JsonKey(name: 'carburants_indisponibles')  List<String>? carburantsIndisponibles, @JsonKey(name: 'carburants_rupture_temporaire')  String? carburantsRuptureTemporaire, @JsonKey(name: 'carburants_rupture_definitive')  String? carburantsRuptureDefinitive, @JsonKey(name: 'horaires_automate_24_24')  String? horairesAutomate2424, @JsonKey(name: 'services_service')  List<String>? servicesService,  String? departement, @JsonKey(name: 'code_departement')  String? codeDepartement,  String? region, @JsonKey(name: 'code_region')  String? codeRegion)  $default,) {final _that = this;
switch (_that) {
case _StationService():
return $default(_that.id,_that.latitude,_that.longitude,_that.cp,_that.pop,_that.adresse,_that.ville,_that.geom,_that.gazolePrix,_that.gazoleMaj,_that.sp95Prix,_that.sp95Maj,_that.e85Prix,_that.e85Maj,_that.gplcPrix,_that.gplcMaj,_that.e10Prix,_that.e10Maj,_that.sp98Prix,_that.sp98Maj,_that.carburantsDisponibles,_that.carburantsIndisponibles,_that.carburantsRuptureTemporaire,_that.carburantsRuptureDefinitive,_that.horairesAutomate2424,_that.servicesService,_that.departement,_that.codeDepartement,_that.region,_that.codeRegion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? latitude,  String? longitude,  String? cp,  String? pop,  String? adresse,  String? ville,  PointGeo? geom, @JsonKey(name: 'gazole_prix')  double? gazolePrix, @JsonKey(name: 'gazole_maj')  DateTime? gazoleMaj, @JsonKey(name: 'sp95_prix')  double? sp95Prix, @JsonKey(name: 'sp95_maj')  DateTime? sp95Maj, @JsonKey(name: 'e85_prix')  double? e85Prix, @JsonKey(name: 'e85_maj')  DateTime? e85Maj, @JsonKey(name: 'gplc_prix')  double? gplcPrix, @JsonKey(name: 'gplc_maj')  DateTime? gplcMaj, @JsonKey(name: 'e10_prix')  double? e10Prix, @JsonKey(name: 'e10_maj')  DateTime? e10Maj, @JsonKey(name: 'sp98_prix')  double? sp98Prix, @JsonKey(name: 'sp98_maj')  DateTime? sp98Maj, @JsonKey(name: 'carburants_disponibles')  List<String>? carburantsDisponibles, @JsonKey(name: 'carburants_indisponibles')  List<String>? carburantsIndisponibles, @JsonKey(name: 'carburants_rupture_temporaire')  String? carburantsRuptureTemporaire, @JsonKey(name: 'carburants_rupture_definitive')  String? carburantsRuptureDefinitive, @JsonKey(name: 'horaires_automate_24_24')  String? horairesAutomate2424, @JsonKey(name: 'services_service')  List<String>? servicesService,  String? departement, @JsonKey(name: 'code_departement')  String? codeDepartement,  String? region, @JsonKey(name: 'code_region')  String? codeRegion)?  $default,) {final _that = this;
switch (_that) {
case _StationService() when $default != null:
return $default(_that.id,_that.latitude,_that.longitude,_that.cp,_that.pop,_that.adresse,_that.ville,_that.geom,_that.gazolePrix,_that.gazoleMaj,_that.sp95Prix,_that.sp95Maj,_that.e85Prix,_that.e85Maj,_that.gplcPrix,_that.gplcMaj,_that.e10Prix,_that.e10Maj,_that.sp98Prix,_that.sp98Maj,_that.carburantsDisponibles,_that.carburantsIndisponibles,_that.carburantsRuptureTemporaire,_that.carburantsRuptureDefinitive,_that.horairesAutomate2424,_that.servicesService,_that.departement,_that.codeDepartement,_that.region,_that.codeRegion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StationService implements StationService {
  const _StationService({this.id, this.latitude, this.longitude, this.cp, this.pop, this.adresse, this.ville, this.geom, @JsonKey(name: 'gazole_prix') this.gazolePrix, @JsonKey(name: 'gazole_maj') this.gazoleMaj, @JsonKey(name: 'sp95_prix') this.sp95Prix, @JsonKey(name: 'sp95_maj') this.sp95Maj, @JsonKey(name: 'e85_prix') this.e85Prix, @JsonKey(name: 'e85_maj') this.e85Maj, @JsonKey(name: 'gplc_prix') this.gplcPrix, @JsonKey(name: 'gplc_maj') this.gplcMaj, @JsonKey(name: 'e10_prix') this.e10Prix, @JsonKey(name: 'e10_maj') this.e10Maj, @JsonKey(name: 'sp98_prix') this.sp98Prix, @JsonKey(name: 'sp98_maj') this.sp98Maj, @JsonKey(name: 'carburants_disponibles')  List<String>? carburantsDisponibles, @JsonKey(name: 'carburants_indisponibles')  List<String>? carburantsIndisponibles, @JsonKey(name: 'carburants_rupture_temporaire') this.carburantsRuptureTemporaire, @JsonKey(name: 'carburants_rupture_definitive') this.carburantsRuptureDefinitive, @JsonKey(name: 'horaires_automate_24_24') this.horairesAutomate2424, @JsonKey(name: 'services_service')  List<String>? servicesService, this.departement, @JsonKey(name: 'code_departement') this.codeDepartement, this.region, @JsonKey(name: 'code_region') this.codeRegion}): _carburantsDisponibles = carburantsDisponibles,_carburantsIndisponibles = carburantsIndisponibles,_servicesService = servicesService;
  factory _StationService.fromJson(Map<String, dynamic> json) => _$StationServiceFromJson(json);

@override final  int? id;
@override final  String? latitude;
@override final  String? longitude;
@override final  String? cp;
@override final  String? pop;
@override final  String? adresse;
@override final  String? ville;
@override final  PointGeo? geom;
@override@JsonKey(name: 'gazole_prix') final  double? gazolePrix;
@override@JsonKey(name: 'gazole_maj') final  DateTime? gazoleMaj;
@override@JsonKey(name: 'sp95_prix') final  double? sp95Prix;
@override@JsonKey(name: 'sp95_maj') final  DateTime? sp95Maj;
@override@JsonKey(name: 'e85_prix') final  double? e85Prix;
@override@JsonKey(name: 'e85_maj') final  DateTime? e85Maj;
@override@JsonKey(name: 'gplc_prix') final  double? gplcPrix;
@override@JsonKey(name: 'gplc_maj') final  DateTime? gplcMaj;
@override@JsonKey(name: 'e10_prix') final  double? e10Prix;
@override@JsonKey(name: 'e10_maj') final  DateTime? e10Maj;
@override@JsonKey(name: 'sp98_prix') final  double? sp98Prix;
@override@JsonKey(name: 'sp98_maj') final  DateTime? sp98Maj;
 final  List<String>? _carburantsDisponibles;
@override@JsonKey(name: 'carburants_disponibles') List<String>? get carburantsDisponibles {
  final value = _carburantsDisponibles;
  if (value == null) return null;
  if (_carburantsDisponibles is EqualUnmodifiableListView) return _carburantsDisponibles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _carburantsIndisponibles;
@override@JsonKey(name: 'carburants_indisponibles') List<String>? get carburantsIndisponibles {
  final value = _carburantsIndisponibles;
  if (value == null) return null;
  if (_carburantsIndisponibles is EqualUnmodifiableListView) return _carburantsIndisponibles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'carburants_rupture_temporaire') final  String? carburantsRuptureTemporaire;
@override@JsonKey(name: 'carburants_rupture_definitive') final  String? carburantsRuptureDefinitive;
@override@JsonKey(name: 'horaires_automate_24_24') final  String? horairesAutomate2424;
 final  List<String>? _servicesService;
@override@JsonKey(name: 'services_service') List<String>? get servicesService {
  final value = _servicesService;
  if (value == null) return null;
  if (_servicesService is EqualUnmodifiableListView) return _servicesService;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? departement;
@override@JsonKey(name: 'code_departement') final  String? codeDepartement;
@override final  String? region;
@override@JsonKey(name: 'code_region') final  String? codeRegion;

/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationServiceCopyWith<_StationService> get copyWith => __$StationServiceCopyWithImpl<_StationService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationServiceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StationService&&(identical(other.id, id) || other.id == id)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.cp, cp) || other.cp == cp)&&(identical(other.pop, pop) || other.pop == pop)&&(identical(other.adresse, adresse) || other.adresse == adresse)&&(identical(other.ville, ville) || other.ville == ville)&&(identical(other.geom, geom) || other.geom == geom)&&(identical(other.gazolePrix, gazolePrix) || other.gazolePrix == gazolePrix)&&(identical(other.gazoleMaj, gazoleMaj) || other.gazoleMaj == gazoleMaj)&&(identical(other.sp95Prix, sp95Prix) || other.sp95Prix == sp95Prix)&&(identical(other.sp95Maj, sp95Maj) || other.sp95Maj == sp95Maj)&&(identical(other.e85Prix, e85Prix) || other.e85Prix == e85Prix)&&(identical(other.e85Maj, e85Maj) || other.e85Maj == e85Maj)&&(identical(other.gplcPrix, gplcPrix) || other.gplcPrix == gplcPrix)&&(identical(other.gplcMaj, gplcMaj) || other.gplcMaj == gplcMaj)&&(identical(other.e10Prix, e10Prix) || other.e10Prix == e10Prix)&&(identical(other.e10Maj, e10Maj) || other.e10Maj == e10Maj)&&(identical(other.sp98Prix, sp98Prix) || other.sp98Prix == sp98Prix)&&(identical(other.sp98Maj, sp98Maj) || other.sp98Maj == sp98Maj)&&const DeepCollectionEquality().equals(other.carburantsDisponibles, _carburantsDisponibles)&&const DeepCollectionEquality().equals(other.carburantsIndisponibles, _carburantsIndisponibles)&&(identical(other.carburantsRuptureTemporaire, carburantsRuptureTemporaire) || other.carburantsRuptureTemporaire == carburantsRuptureTemporaire)&&(identical(other.carburantsRuptureDefinitive, carburantsRuptureDefinitive) || other.carburantsRuptureDefinitive == carburantsRuptureDefinitive)&&(identical(other.horairesAutomate2424, horairesAutomate2424) || other.horairesAutomate2424 == horairesAutomate2424)&&const DeepCollectionEquality().equals(other.servicesService, _servicesService)&&(identical(other.departement, departement) || other.departement == departement)&&(identical(other.codeDepartement, codeDepartement) || other.codeDepartement == codeDepartement)&&(identical(other.region, region) || other.region == region)&&(identical(other.codeRegion, codeRegion) || other.codeRegion == codeRegion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,latitude,longitude,cp,pop,adresse,ville,geom,gazolePrix,gazoleMaj,sp95Prix,sp95Maj,e85Prix,e85Maj,gplcPrix,gplcMaj,e10Prix,e10Maj,sp98Prix,sp98Maj,const DeepCollectionEquality().hash(_carburantsDisponibles),const DeepCollectionEquality().hash(_carburantsIndisponibles),carburantsRuptureTemporaire,carburantsRuptureDefinitive,horairesAutomate2424,const DeepCollectionEquality().hash(_servicesService),departement,codeDepartement,region,codeRegion]);
}

@override
String toString() {
    return 'StationService(id: $id, latitude: $latitude, longitude: $longitude, cp: $cp, pop: $pop, adresse: $adresse, ville: $ville, geom: $geom, gazolePrix: $gazolePrix, gazoleMaj: $gazoleMaj, sp95Prix: $sp95Prix, sp95Maj: $sp95Maj, e85Prix: $e85Prix, e85Maj: $e85Maj, gplcPrix: $gplcPrix, gplcMaj: $gplcMaj, e10Prix: $e10Prix, e10Maj: $e10Maj, sp98Prix: $sp98Prix, sp98Maj: $sp98Maj, carburantsDisponibles: $carburantsDisponibles, carburantsIndisponibles: $carburantsIndisponibles, carburantsRuptureTemporaire: $carburantsRuptureTemporaire, carburantsRuptureDefinitive: $carburantsRuptureDefinitive, horairesAutomate2424: $horairesAutomate2424, servicesService: $servicesService, departement: $departement, codeDepartement: $codeDepartement, region: $region, codeRegion: $codeRegion)';
}


}

/// @nodoc
abstract mixin class _$StationServiceCopyWith<$Res> implements $StationServiceCopyWith<$Res> {
  factory _$StationServiceCopyWith(_StationService value, $Res Function(_StationService) _then) = __$StationServiceCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? latitude, String? longitude, String? cp, String? pop, String? adresse, String? ville, PointGeo? geom,@JsonKey(name: 'gazole_prix') double? gazolePrix,@JsonKey(name: 'gazole_maj') DateTime? gazoleMaj,@JsonKey(name: 'sp95_prix') double? sp95Prix,@JsonKey(name: 'sp95_maj') DateTime? sp95Maj,@JsonKey(name: 'e85_prix') double? e85Prix,@JsonKey(name: 'e85_maj') DateTime? e85Maj,@JsonKey(name: 'gplc_prix') double? gplcPrix,@JsonKey(name: 'gplc_maj') DateTime? gplcMaj,@JsonKey(name: 'e10_prix') double? e10Prix,@JsonKey(name: 'e10_maj') DateTime? e10Maj,@JsonKey(name: 'sp98_prix') double? sp98Prix,@JsonKey(name: 'sp98_maj') DateTime? sp98Maj,@JsonKey(name: 'carburants_disponibles') List<String>? carburantsDisponibles,@JsonKey(name: 'carburants_indisponibles') List<String>? carburantsIndisponibles,@JsonKey(name: 'carburants_rupture_temporaire') String? carburantsRuptureTemporaire,@JsonKey(name: 'carburants_rupture_definitive') String? carburantsRuptureDefinitive,@JsonKey(name: 'horaires_automate_24_24') String? horairesAutomate2424,@JsonKey(name: 'services_service') List<String>? servicesService, String? departement,@JsonKey(name: 'code_departement') String? codeDepartement, String? region,@JsonKey(name: 'code_region') String? codeRegion
});


@override $PointGeoCopyWith<$Res>? get geom;

}
/// @nodoc
class __$StationServiceCopyWithImpl<$Res>
    implements _$StationServiceCopyWith<$Res> {
  __$StationServiceCopyWithImpl(this._self, this._then);

  final _StationService _self;
  final $Res Function(_StationService) _then;

/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? cp = freezed,Object? pop = freezed,Object? adresse = freezed,Object? ville = freezed,Object? geom = freezed,Object? gazolePrix = freezed,Object? gazoleMaj = freezed,Object? sp95Prix = freezed,Object? sp95Maj = freezed,Object? e85Prix = freezed,Object? e85Maj = freezed,Object? gplcPrix = freezed,Object? gplcMaj = freezed,Object? e10Prix = freezed,Object? e10Maj = freezed,Object? sp98Prix = freezed,Object? sp98Maj = freezed,Object? carburantsDisponibles = freezed,Object? carburantsIndisponibles = freezed,Object? carburantsRuptureTemporaire = freezed,Object? carburantsRuptureDefinitive = freezed,Object? horairesAutomate2424 = freezed,Object? servicesService = freezed,Object? departement = freezed,Object? codeDepartement = freezed,Object? region = freezed,Object? codeRegion = freezed,}) {
  return _then(_StationService(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as String?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as String?,cp: freezed == cp ? _self.cp : cp // ignore: cast_nullable_to_non_nullable
as String?,pop: freezed == pop ? _self.pop : pop // ignore: cast_nullable_to_non_nullable
as String?,adresse: freezed == adresse ? _self.adresse : adresse // ignore: cast_nullable_to_non_nullable
as String?,ville: freezed == ville ? _self.ville : ville // ignore: cast_nullable_to_non_nullable
as String?,geom: freezed == geom ? _self.geom : geom // ignore: cast_nullable_to_non_nullable
as PointGeo?,gazolePrix: freezed == gazolePrix ? _self.gazolePrix : gazolePrix // ignore: cast_nullable_to_non_nullable
as double?,gazoleMaj: freezed == gazoleMaj ? _self.gazoleMaj : gazoleMaj // ignore: cast_nullable_to_non_nullable
as DateTime?,sp95Prix: freezed == sp95Prix ? _self.sp95Prix : sp95Prix // ignore: cast_nullable_to_non_nullable
as double?,sp95Maj: freezed == sp95Maj ? _self.sp95Maj : sp95Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,e85Prix: freezed == e85Prix ? _self.e85Prix : e85Prix // ignore: cast_nullable_to_non_nullable
as double?,e85Maj: freezed == e85Maj ? _self.e85Maj : e85Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,gplcPrix: freezed == gplcPrix ? _self.gplcPrix : gplcPrix // ignore: cast_nullable_to_non_nullable
as double?,gplcMaj: freezed == gplcMaj ? _self.gplcMaj : gplcMaj // ignore: cast_nullable_to_non_nullable
as DateTime?,e10Prix: freezed == e10Prix ? _self.e10Prix : e10Prix // ignore: cast_nullable_to_non_nullable
as double?,e10Maj: freezed == e10Maj ? _self.e10Maj : e10Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,sp98Prix: freezed == sp98Prix ? _self.sp98Prix : sp98Prix // ignore: cast_nullable_to_non_nullable
as double?,sp98Maj: freezed == sp98Maj ? _self.sp98Maj : sp98Maj // ignore: cast_nullable_to_non_nullable
as DateTime?,carburantsDisponibles: freezed == carburantsDisponibles ? _self._carburantsDisponibles : carburantsDisponibles // ignore: cast_nullable_to_non_nullable
as List<String>?,carburantsIndisponibles: freezed == carburantsIndisponibles ? _self._carburantsIndisponibles : carburantsIndisponibles // ignore: cast_nullable_to_non_nullable
as List<String>?,carburantsRuptureTemporaire: freezed == carburantsRuptureTemporaire ? _self.carburantsRuptureTemporaire : carburantsRuptureTemporaire // ignore: cast_nullable_to_non_nullable
as String?,carburantsRuptureDefinitive: freezed == carburantsRuptureDefinitive ? _self.carburantsRuptureDefinitive : carburantsRuptureDefinitive // ignore: cast_nullable_to_non_nullable
as String?,horairesAutomate2424: freezed == horairesAutomate2424 ? _self.horairesAutomate2424 : horairesAutomate2424 // ignore: cast_nullable_to_non_nullable
as String?,servicesService: freezed == servicesService ? _self._servicesService : servicesService // ignore: cast_nullable_to_non_nullable
as List<String>?,departement: freezed == departement ? _self.departement : departement // ignore: cast_nullable_to_non_nullable
as String?,codeDepartement: freezed == codeDepartement ? _self.codeDepartement : codeDepartement // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,codeRegion: freezed == codeRegion ? _self.codeRegion : codeRegion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StationService
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PointGeoCopyWith<$Res>? get geom {
    if (_self.geom == null) {
    return null;
  }

  return $PointGeoCopyWith<$Res>(_self.geom!, (value) {
    return _then(_self.copyWith(geom: value));
  });
}
}

// dart format on
