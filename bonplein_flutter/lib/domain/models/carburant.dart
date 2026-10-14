import 'package:bonplein_flutter/domain/models/type_carburant.dart';

class Carburant {
  const Carburant({required this.type, required this.prix, this.maj});
  final TypeCarburant type;
  final double prix;
  final DateTime? maj;
}
