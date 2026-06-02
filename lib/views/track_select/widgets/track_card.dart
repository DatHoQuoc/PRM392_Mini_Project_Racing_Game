import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/enums/track_type.dart';
import 'track_shape_painter.dart';

/// A single selectable track card (shape diagram on top, info below).
/// Shows a red border + yellow checkmark badge when [selected].
class TrackCard extends StatelessWidget {
  final TrackType type;
  final String name;
  final String difficulty;
  final Color difficultyColor;
  final String description;
  final int lengthM;
  final String previewAsset;
  final bool selected;
  final VoidCallback onTap;

  const TrackCard({
    super.key,
    required this.type,
    required this.name,
    required this.difficulty,
    required this.difficultyColor,
    required this.description,
    required this.lengthM,
    required this.selected,
    required this.onTap,
    this.previewAsset = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColors.primaryRed : AppColors.navy,
                width: selected ? 3 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryRed.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            // No clipBehavior here — clipping the child to the *outer* radius
            // makes the image bleed over the border at the corners. Instead we
            // clip the content to the inner radius (outer 16 − border width).
            child: ClipRRect(
              borderRadius: BorderRadius.circular(selected ? 13.0 : 15.0),
              child: Column(
                children: [
                  // ── Top half — track preview image (fallback: painted) ──
                  Expanded(
                    child: SizedBox.expand(
                      child: previewAsset.isEmpty
                          ? CustomPaint(painter: TrackShapePainter(type: type))
                          : Image.asset(
                              previewAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  CustomPaint(
                                    painter: TrackShapePainter(type: type),
                                  ),
                            ),
                    ),
                  ),
                  // ── Bottom half — info ───────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _DifficultyPill(
                            label: difficulty,
                            color: difficultyColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🛣️ ${lengthM}m',
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Selection checkmark badge ────────────────────────────────
          if (selected)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.navy, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  final String label;
  final Color color;
  const _DifficultyPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
