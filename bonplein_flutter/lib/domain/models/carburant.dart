import 'type_carburant.dart';

class Carburant {
  final TypeCarburant type;
  final double prix;
  final DateTime? maj;

  const Carburant({required this.type, required this.prix, this.maj});
}
