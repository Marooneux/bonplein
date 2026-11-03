import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:bonplein_flutter/utils/format_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chaque bouton du filtre donne son carburant', () {
    expect(TypeCarburant.depuisBouton('SP95'), TypeCarburant.sp95);
    expect(TypeCarburant.depuisBouton('SP95-E10'), TypeCarburant.e10);
    expect(TypeCarburant.depuisBouton('SP98'), TypeCarburant.sp98);
    expect(TypeCarburant.depuisBouton('Gazole'), TypeCarburant.gazole);
    expect(TypeCarburant.depuisBouton('E85'), TypeCarburant.e85);
    expect(TypeCarburant.depuisBouton('GPL-c'), TypeCarburant.gplc);
    expect(TypeCarburant.depuisBouton('Tous'), isNull);
  });

  test('les prix sont écrits avec une virgule', () {
    expect(formaterNombre(2.25, 3), '2,250');
    expect(formaterNombre(1.8, 1), '1,8');
  });
}
