import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class WinnerCard extends StatelessWidget {
  final int winnerId;

  const WinnerCard({
    super.key,
    required this.winnerId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.yellow,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'WINNER',
            style: TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'CAR #$winnerId',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}