import 'package:flutter/material.dart';

import '../../../data/models/car_model.dart';
import '../../../data/repositories/game_repository.dart';

/// Three racing cars side-by-side for the login branding panel.
/// Images come from `assets/data/cars.json` (loaded via [GameRepository]),
/// so it stays in sync with the real game roster.
class CarTrio extends StatefulWidget {
  final double width;
  const CarTrio({super.key, this.width = 120});

  @override
  State<CarTrio> createState() => _CarTrioState();
}

class _CarTrioState extends State<CarTrio> {
  late final Future<List<CarModel>> _cars = GameRepository().loadCars();

  @override
  Widget build(BuildContext context) {
    // Height-only constraint so the Row can grow with the enlarged 3rd car
    // instead of overflowing a fixed width.
    return SizedBox(
      height: widget.width * 0.6,
      child: FutureBuilder<List<CarModel>>(
        future: _cars,
        builder: (context, snapshot) {
          final cars = snapshot.data;
          if (cars == null || cars.isEmpty) {
            return const SizedBox.shrink();
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final car in cars.take(3))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Image.asset(
                    car.assetPath,
                    width: widget.width / 3.2,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (context, error, stack) =>
                        const SizedBox.shrink(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
