enum TypeCarburant {
  gazole('Gazole', 'gazole_prix'),
  sp95('SP95', 'sp95_prix'),
  sp98('SP98', 'sp98_prix'),
  e10('E10', 'e10_prix'),
  e85('E85', 'e85_prix'),
  gplc('GPLc', 'gplc_prix');

  const TypeCarburant(this.nom, this.champApi);

  final String nom;
  final String champApi;

  /// Carburant d'un bouton du filtre comme SP95-E10 ou GPL-c
  static TypeCarburant? depuisBouton(String bouton) {
    return switch (bouton) {
      'SP95' => TypeCarburant.sp95,
      'SP95-E10' || 'E10' => TypeCarburant.e10,
      'SP98' => TypeCarburant.sp98,
      'Gazole' => TypeCarburant.gazole,
      'E85' => TypeCarburant.e85,
      'GPL' || 'GPL-c' => TypeCarburant.gplc,
      _ => null,
    };
  }
}
