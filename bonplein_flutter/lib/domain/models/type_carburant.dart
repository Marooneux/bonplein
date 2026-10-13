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
}
