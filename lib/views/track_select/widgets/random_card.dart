import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// An action card shaped like a [TrackCard] but, instead of a track, it picks
/// a random track when tapped. Uses a dashed-feel yellow border to stand out.
class RandomCard extends StatelessWidget {
  final VoidCallback onTap;
  const RandomCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B1B5A), AppColors.navy],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.yellow, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('🎲', style: TextStyle(fontSize: 40)),
            SizedBox(height: 10),
            Text(
              'RANDOM',
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Surprise me with a track',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
