import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class CarSelectAppBar extends StatelessWidget {
  final double walletBalance;
  const CarSelectAppBar({super.key, required this.walletBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
          ),
          const Expanded(
            child: Text(
              'PLACE YOUR BET',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💰 ', style: TextStyle(fontSize: 13)),
                Text(
                  '\$${walletBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}