import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ResultActions extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onReplay;

  const ResultActions({
    super.key,
    required this.onHome,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onHome,
            icon: const Icon(Icons.home),
            label: const Text('HOME'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(55),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReplay,
            icon: const Icon(Icons.refresh),
            label: const Text('PLAY AGAIN'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(55),
            ),
          ),
        ),
      ],
    );
  }
}