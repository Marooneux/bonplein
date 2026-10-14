import 'package:bonplein_flutter/data/api_models/carburant_api_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'carburant_api_service.g.dart';

@RestApi(baseUrl: 'https://data.economie.gouv.fr/api/explore/v2.1')
// L'analyseur dart recommande de ne pas avoir de classe abstraite avec une
// seule méthode et d'utiliser plutôt une fonction. Cependant, Retrofit ne
// fonctionne pas sans cette déclaration de classe abstraite @RestApi.
// ignore: one_member_abstracts
abstract class CarburantsApi {
  factory CarburantsApi(Dio dio, {String baseUrl}) = _CarburantsApi;

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
}
