import 'package:freezed_annotation/freezed_annotation.dart';

part 'carburant_api_model.freezed.dart';
part 'carburant_api_model.g.dart';

@freezed
abstract class ReponseStations with _$ReponseStations {
  const factory ReponseStations({
    @JsonKey(name: 'total_count') required int totalCount,
    @Default([]) List<StationService> results,
  }) = _ReponseStations;

  factory ReponseStations.fromJson(Map<String, dynamic> json) =>
      _$ReponseStationsFromJson(json);
}

@freezed
abstract class PointGeo with _$PointGeo {
  const factory PointGeo({required double lon, required double lat}) =
      _PointGeo;

  factory PointGeo.fromJson(Map<String, dynamic> json) =>
      _$PointGeoFromJson(json);
}

@freezed
abstract class StationService with _$StationService {
  const factory StationService({
    int? id,
    String? latitude,
    String? longitude,
    String? cp,
    String? pop,
    String? adresse,
    String? ville,
    PointGeo? geom,
    @JsonKey(name: 'gazole_prix') double? gazolePrix,
    @JsonKey(name: 'gazole_maj') DateTime? gazoleMaj,
    @JsonKey(name: 'sp95_prix') double? sp95Prix,
    @JsonKey(name: 'sp95_maj') DateTime? sp95Maj,
    @JsonKey(name: 'e85_prix') double? e85Prix,
    @JsonKey(name: 'e85_maj') DateTime? e85Maj,
    @JsonKey(name: 'gplc_prix') double? gplcPrix,
    @JsonKey(name: 'gplc_maj') DateTime? gplcMaj,
    @JsonKey(name: 'e10_prix') double? e10Prix,
    @JsonKey(name: 'e10_maj') DateTime? e10Maj,
    @JsonKey(name: 'sp98_prix') double? sp98Prix,
    @JsonKey(name: 'sp98_maj') DateTime? sp98Maj,
    @JsonKey(name: 'carburants_disponibles')
    List<String>? carburantsDisponibles,
    @JsonKey(name: 'carburants_indisponibles')
    List<String>? carburantsIndisponibles,
    @JsonKey(name: 'carburants_rupture_temporaire')
    String? carburantsRuptureTemporaire,
    @JsonKey(name: 'carburants_rupture_definitive')
    String? carburantsRuptureDefinitive,
    @JsonKey(name: 'horaires_automate_24_24') String? horairesAutomate2424,
    @JsonKey(name: 'services_service') List<String>? servicesService,
    String? departement,
    @JsonKey(name: 'code_departement') String? codeDepartement,
    String? region,
    @JsonKey(name: 'code_region') String? codeRegion,
  }) = _StationService;

  factory StationService.fromJson(Map<String, dynamic> json) =>
      _$StationServiceFromJson(json);
}
