import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'bet_slider.dart';
import 'bet_size_buttons.dart';

class BettingColumn extends StatelessWidget {
  final double betAmount;
  final double maxBet;
  final int? selectedPresetPct;
  final bool canPlay;
  final ValueChanged<double> onBetChanged;
  final ValueChanged<int> onPresetSelected;
  final VoidCallback? onPlay;

  const BettingColumn({
    super.key,
    required this.betAmount,
    required this.maxBet,
    required this.selectedPresetPct,
    required this.canPlay,
    required this.onBetChanged,
    required this.onPresetSelected,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy, width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'BET AMOUNT',
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Container(
                  key: ValueKey(betAmount.toStringAsFixed(0)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.navy, width: 1),
                  ),
                  child: Text(
                    '\$${betAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          BetSlider(value: betAmount, max: maxBet, onChanged: onBetChanged),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('\$0', style: TextStyle(color: Colors.grey, fontSize: 9)),
              Text('\$100', style: TextStyle(color: Colors.grey, fontSize: 9)),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              height: 1,
              color: AppColors.navy.withValues(alpha: 0.15),
            ),
          ),

          const Text(
            'BET SIZE',
            style: TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          BetSizeButtons(
            maxBet: maxBet,
            selectedPresetPct: selectedPresetPct,
            onSelect: onPresetSelected,
          ),
          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: canPlay
                    ? AppColors.primaryRed
                    : Colors.grey.shade400,
                foregroundColor: canPlay ? Colors.white : Colors.grey.shade600,
                elevation: canPlay ? 3 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: canPlay ? AppColors.yellow : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 20),
                  SizedBox(width: 4),
                  Text(
                    'PLAY',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}