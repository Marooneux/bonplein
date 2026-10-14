/// Représente UNE requête que le repository a envoyée à l'API.
///
/// Le faux service en crée une à chaque appel de `getRecords`, afin que le test
/// puisse vérifier ensuite « qu'est-ce qui a été envoyé ? » (where, orderBy,
/// limit, offset...).
///
/// C'est juste une boîte de données : elle ne contient aucune logique.
class RecordedCall {
  const RecordedCall({
    this.select,
    this.where,
    this.orderBy,
    this.limit,
    this.offset,
    this.refine,
    this.exclude,
    this.timezone,
  });

  final String? select;
  final String? where;
  final String? orderBy;
  final int? limit;
  final int? offset;
  final String? refine;
  final String? exclude;
  final String? timezone;
}