import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/car_model.dart';

class CarListColumn extends StatelessWidget {
  final List<CarModel> cars;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const CarListColumn({
    super.key,
    required this.cars,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy, width: 2),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Text(
              'CARS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: List.generate(cars.length, (i) {
                  final isSelected = i == selectedIndex;
                  final car = cars[i];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 7),
                      child: GestureDetector(
                        onTap: () => onSelect(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isSelected ? car.color : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border(
                              left: BorderSide(
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.grey.shade300,
                                width: isSelected ? 5 : 1,
                              ),
                              top: BorderSide(
                                color: isSelected
                                    ? car.color
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: isSelected
                                    ? car.color
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: isSelected
                                    ? car.color
                                    : Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: car.color.withValues(alpha: 0.45),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                                : null,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : car.color,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : car.color.withValues(alpha: 0.5),
                                    width: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  car.name,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.navy,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}