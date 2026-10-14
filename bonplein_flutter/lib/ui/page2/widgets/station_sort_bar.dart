import 'package:bonplein_flutter/domain/models/type_carburant.dart';
import 'package:flutter/material.dart';

class StationSortBar extends StatelessWidget {
  const StationSortBar({
    super.key,
    required this.triParPrix,
    required this.onTriChanged,
    required this.carburant,
    required this.carburants,
    required this.onCarburantChanged,
  });

  final bool triParPrix; // false = distance, true = prix
  final ValueChanged<bool> onTriChanged;
  final TypeCarburant carburant;
  final List<TypeCarburant> carburants;
  final ValueChanged<TypeCarburant> onCarburantChanged;

  @override
  Widget build(BuildContext context) {
    const vert = Color(0xFF22C55E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<bool>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: vert.withValues(alpha: 0.15),
            selectedForegroundColor: vert,
          ),
          segments: const [
            ButtonSegment<bool>(
              value: false,
              icon: Icon(Icons.near_me_outlined),
              label: Text('Distance'),
            ),
            ButtonSegment<bool>(
              value: true,
              icon: Icon(Icons.euro),
              label: Text('Prix'),
            ),
          ],
          selected: {triParPrix},
          onSelectionChanged: (Set<bool> s) => onTriChanged(s.first),
        ),

        if (triParPrix)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              children: carburants.map((c) {
                return ChoiceChip(
                  label: Text(c.name),
                  selected: c == carburant,
                  selectedColor: vert.withValues(alpha: 0.2),
                  onSelected: (_) => onCarburantChanged(c),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}