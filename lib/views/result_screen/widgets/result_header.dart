import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.emoji_events,
          size: 70,
          color: AppColors.yellow,
        ),
        SizedBox(height: 12),
        Text(
          'RACE FINISHED',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}