import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/car_model.dart';
import 'car_image.dart';

class CarInfoColumn extends StatelessWidget {
  final CarModel car;
  const CarInfoColumn({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey(car.id),
        decoration: BoxDecoration(
          color: AppColors.skyBlue.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.navy.withValues(alpha: 0.35),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        color: car.accent,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.navy, width: 2.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        // 3. Ép ảnh bên trong căng ra bằng với khung
                        child: SizedBox.expand(
                          child: FittedBox(
                            // Dùng BoxFit.cover để ảnh phóng to lấp đầy mọi ngóc ngách của khung
                            // Nếu sợ mất đầu/đuôi xe, bạn có thể đổi thành BoxFit.contain
                            fit: BoxFit.cover,
                            child: CarImage(
                              assetPath: car.assetPath,
                              color: car.color,
                              tintWhite: false,
                              size: 100, // Gán size to lên một chút, FittedBox sẽ lo việc scale
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      car.name.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StatRow(
                      icon: '',
                      label: 'Speed',
                      value: car.speed,
                      barColor: car.color,
                    ),
                    const SizedBox(height: 5),
                    StatRow(
                      icon: '',
                      label: 'Handling',
                      value: (car.speed * 0.75).clamp(0.0, 1.0),
                      barColor: car.color,
                    ),
                    const SizedBox(height: 5),
                    StatRow(
                      icon: '',
                      label: 'Stamina',
                      value: (1.1 - car.speed).clamp(0.0, 1.0),
                      barColor: car.color,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.white.withValues(alpha: 0.7),
                      //   borderRadius: BorderRadius.circular(8),
                      //   border: Border.all(
                      //     color: AppColors.navy.withValues(alpha: 0.15),
                      //     width: 1,
                      //   ),
                      // ),
                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     const Row(
                      //       children: [
                      //         Icon(
                      //           Icons.info_outline_rounded,
                      //           size: 12,
                      //           color: AppColors.navy,
                      //         ),
                      //         SizedBox(width: 4),
                      //         Text(
                      //           'DESCRIPTION',
                      //           style: TextStyle(
                      //             color: AppColors.navy,
                      //             fontWeight: FontWeight.w800,
                      //             fontSize: 10,
                      //             letterSpacing: 0.5,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     const SizedBox(height: 4),
                      //     Text(
                      //       car.description.isNotEmpty
                      //           ? car.description
                      //           : 'No description available for this vehicle.',
                      //       style: TextStyle(
                      //         color: AppColors.navy.withValues(alpha: 0.8),
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 10.5,
                      //         height: 1.3,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final double value;
  final Color barColor;

  const StatRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 5),
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(barColor),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 26,
          child: Text(
            '${(value * 100).toInt()}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}