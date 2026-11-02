import 'package:bonplein_flutter/domain/models/station_service.dart';

class InfoStationViewModel {

  InfoStationViewModel({
    required this.station,
  });
  final Station station;

  String get nom => station.nom;

  String get adresseComplete =>
      '${station.adresse}, ${station.codePostal} ${station.ville}';

  List get carburants => station.carburants;

  List<String> get services => station.services;
}