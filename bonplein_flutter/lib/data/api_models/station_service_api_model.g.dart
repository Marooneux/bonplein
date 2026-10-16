// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_service_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReponseStations _$ReponseStationsFromJson(Map<String, dynamic> json) =>
    _ReponseStations(
      totalCount: (json['total_count'] as num).toInt(),
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => StationService.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ReponseStationsToJson(_ReponseStations instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'results': instance.results,
    };

_PointGeo _$PointGeoFromJson(Map<String, dynamic> json) => _PointGeo(
  lon: (json['lon'] as num).toDouble(),
  lat: (json['lat'] as num).toDouble(),
);

Map<String, dynamic> _$PointGeoToJson(_PointGeo instance) => <String, dynamic>{
  'lon': instance.lon,
  'lat': instance.lat,
};

_StationService _$StationServiceFromJson(
  Map<String, dynamic> json,
) => _StationService(
  id: (json['id'] as num?)?.toInt(),
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  cp: json['cp'] as String?,
  pop: json['pop'] as String?,
  adresse: json['adresse'] as String?,
  ville: json['ville'] as String?,
  geom: json['geom'] == null
      ? null
      : PointGeo.fromJson(json['geom'] as Map<String, dynamic>),
  gazolePrix: (json['gazole_prix'] as num?)?.toDouble(),
  gazoleMaj: json['gazole_maj'] == null
      ? null
      : DateTime.parse(json['gazole_maj'] as String),
  sp95Prix: (json['sp95_prix'] as num?)?.toDouble(),
  sp95Maj: json['sp95_maj'] == null
      ? null
      : DateTime.parse(json['sp95_maj'] as String),
  e85Prix: (json['e85_prix'] as num?)?.toDouble(),
  e85Maj: json['e85_maj'] == null
      ? null
      : DateTime.parse(json['e85_maj'] as String),
  gplcPrix: (json['gplc_prix'] as num?)?.toDouble(),
  gplcMaj: json['gplc_maj'] == null
      ? null
      : DateTime.parse(json['gplc_maj'] as String),
  e10Prix: (json['e10_prix'] as num?)?.toDouble(),
  e10Maj: json['e10_maj'] == null
      ? null
      : DateTime.parse(json['e10_maj'] as String),
  sp98Prix: (json['sp98_prix'] as num?)?.toDouble(),
  sp98Maj: json['sp98_maj'] == null
      ? null
      : DateTime.parse(json['sp98_maj'] as String),
  carburantsDisponibles: (json['carburants_disponibles'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  carburantsIndisponibles: (json['carburants_indisponibles'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  carburantsRuptureTemporaire: json['carburants_rupture_temporaire'] as String?,
  carburantsRuptureDefinitive: json['carburants_rupture_definitive'] as String?,
  horairesAutomate2424: json['horaires_automate_24_24'] as String?,
  servicesService: (json['services_service'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  departement: json['departement'] as String?,
  codeDepartement: json['code_departement'] as String?,
  region: json['region'] as String?,
  codeRegion: json['code_region'] as String?,
);

Map<String, dynamic> _$StationServiceToJson(_StationService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'cp': instance.cp,
      'pop': instance.pop,
      'adresse': instance.adresse,
      'ville': instance.ville,
      'geom': instance.geom,
      'gazole_prix': instance.gazolePrix,
      'gazole_maj': instance.gazoleMaj?.toIso8601String(),
      'sp95_prix': instance.sp95Prix,
      'sp95_maj': instance.sp95Maj?.toIso8601String(),
      'e85_prix': instance.e85Prix,
      'e85_maj': instance.e85Maj?.toIso8601String(),
      'gplc_prix': instance.gplcPrix,
      'gplc_maj': instance.gplcMaj?.toIso8601String(),
      'e10_prix': instance.e10Prix,
      'e10_maj': instance.e10Maj?.toIso8601String(),
      'sp98_prix': instance.sp98Prix,
      'sp98_maj': instance.sp98Maj?.toIso8601String(),
      'carburants_disponibles': instance.carburantsDisponibles,
      'carburants_indisponibles': instance.carburantsIndisponibles,
      'carburants_rupture_temporaire': instance.carburantsRuptureTemporaire,
      'carburants_rupture_definitive': instance.carburantsRuptureDefinitive,
      'horaires_automate_24_24': instance.horairesAutomate2424,
      'services_service': instance.servicesService,
      'departement': instance.departement,
      'code_departement': instance.codeDepartement,
      'region': instance.region,
      'code_region': instance.codeRegion,
    };
