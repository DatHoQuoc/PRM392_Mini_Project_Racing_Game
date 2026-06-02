import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class RewardCard extends StatelessWidget {
  final bool won;
  final double reward;

  const RewardCard({
    super.key,
    required this.won,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: won
            ? Colors.green.withOpacity(.15)
            : Colors.red.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            won ? 'YOU WON!' : 'YOU LOST!',
            style: TextStyle(
              color: won ? Colors.greenAccent : Colors.redAccent,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${reward.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}