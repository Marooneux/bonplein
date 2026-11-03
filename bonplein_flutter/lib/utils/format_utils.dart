/// 1.749 devient "1,749" avec trois décimales
String formaterNombre(double valeur, int decimales) =>
    valeur.toStringAsFixed(decimales).replaceAll('.', ',');
