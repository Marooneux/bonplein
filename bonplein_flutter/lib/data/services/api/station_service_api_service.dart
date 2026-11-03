import 'package:bonplein_flutter/data/api_models/station_service_api_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'station_service_api_service.g.dart';

@RestApi(baseUrl: 'https://data.economie.gouv.fr/api/explore/v2.1')
// L'analyseur dart déconseille une classe abstraite avec une seule méthode
// mais Retrofit a besoin de cette classe abstraite @RestApi pour fonctionner
// ignore: one_member_abstracts
abstract class StationServiceApi {
  factory StationServiceApi(Dio dio, {String baseUrl}) = _StationServiceApi;

  @GET(
    '/catalog/datasets/prix-des-carburants-en-france-flux-instantane-v2/records',
  )
  Future<ReponseStations> getRecords({
    @Query('select') String? select,
    @Query('where') String? where,
    @Query('order_by') String? orderBy,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
    @Query('refine') String? refine,
    @Query('exclude') String? exclude,
    @Query('timezone') String? timezone,
  });

  /// Tout le jeu de données sans limite de nombre
  @GET(
    '/catalog/datasets/prix-des-carburants-en-france-flux-instantane-v2/exports/json',
  )
  Future<List<StationService>> exportRecords({
    @Query('select') String? select,
    @Query('where') String? where,
  });
}
