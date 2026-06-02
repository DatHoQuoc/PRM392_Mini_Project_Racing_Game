import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BetSizeButtons extends StatelessWidget {
  final double maxBet;
  final int? selectedPresetPct;
  final ValueChanged<int> onSelect;

  const BetSizeButtons({
    super.key,
    required this.maxBet,
    required this.selectedPresetPct,
    required this.onSelect,
  });

  static const _presets = [
    (label: '1/4', pct: 25),
    (label: '1/2', pct: 50),
    (label: '3/4', pct: 75),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: _presets.map((p) {
            final isActive = selectedPresetPct == p.pct;
            final amount = (maxBet * p.pct / 100).round();
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: p.pct == 75 ? 0 : 6),
                child: PresetButton(
                  label: p.label,
                  sublabel: '\$$amount',
                  isActive: isActive,
                  isAllIn: false,
                  onTap: () => onSelect(p.pct),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        PresetButton(
          label: 'All In',
          sublabel: '\$${maxBet.toStringAsFixed(0)}',
          isActive: selectedPresetPct == 100,
          isAllIn: true,
          onTap: () => onSelect(100),
        ),
      ],
    );
  }
}

class PresetButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool isActive;
  final bool isAllIn;
  final VoidCallback onTap;

  const PresetButton({
    super.key,
    required this.label,
    required this.sublabel,
    required this.isActive,
    required this.isAllIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color labelColor;
    final Color subColor;
    final Color borderColor;

    if (isAllIn) {
      bg = isActive ? AppColors.primaryRed : AppColors.navy;
      labelColor = isActive ? Colors.white : AppColors.yellow;
      subColor = isActive
          ? Colors.white.withValues(alpha: 0.85)
          : AppColors.yellow.withValues(alpha: 0.7);
      borderColor = AppColors.yellow;
    } else {
      bg = isActive ? AppColors.navy : Colors.white;
      labelColor = isActive ? AppColors.yellow : AppColors.navy;
      subColor = isActive
          ? AppColors.yellow.withValues(alpha: 0.7)
          : Colors.grey.shade500;
      borderColor = isActive ? AppColors.yellow : Colors.grey.shade400;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isAllIn ? 9 : 7),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: (isAllIn ? AppColors.primaryRed : AppColors.navy)
                  .withValues(alpha: 0.35),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontWeight: FontWeight.w900,
                fontSize: isAllIn ? 14 : 12,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                color: subColor,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}