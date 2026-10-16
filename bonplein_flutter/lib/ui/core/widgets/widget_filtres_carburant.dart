import 'package:flutter/material.dart';

class FuelFilterWidget extends StatefulWidget {
  final ValueChanged<String?>? onFuelSelected;
  final String carburantInitial;
  final bool afficherTous;

  const FuelFilterWidget({
    super.key,
    this.onFuelSelected,
    this.carburantInitial = 'Tous',
    this.afficherTous = true,
  });

  @override
  State<FuelFilterWidget> createState() => _FuelFilterWidgetState();
  }

  class _FuelFilterWidgetState extends State<FuelFilterWidget> {
  late final List<String> carburants = [
    if (widget.afficherTous) 'Tous',
    'SP95',
    'SP95-E10',
    'SP98',
    'Gazole',
    'E85',
    'GPL-c',
  ];

  late String carburantSelectionne = widget.carburantInitial;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: carburants.length + 1,
          separatorBuilder: (context, index) =>
            const SizedBox(width: 8),
            itemBuilder: (context, index) {

              if (index == carburants.length) {
                return OutlinedButton(
                  onPressed: () {
                    // TODO : ouvrir les filtres avancés
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white,),
                );
              }
              final carburant = carburants[index];
              final estSelectionne = carburant == carburantSelectionne;

              return OutlinedButton(
                onPressed: () {
                  setState(() {
                    carburantSelectionne = carburant;
                  });

                  widget.onFuelSelected?.call(
                    carburant == 'Tous' ? null : carburant,
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: estSelectionne
                      ? Colors.green
                      : Colors.white,
                  foregroundColor: estSelectionne
                      ? Colors.white
                      : Colors.black,
                  side: BorderSide(
                    color: estSelectionne
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: Text(carburant),
              );
              },
      ),
    );
  }
}

