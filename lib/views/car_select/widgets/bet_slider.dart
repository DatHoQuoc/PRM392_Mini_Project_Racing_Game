import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class BetSlider extends StatelessWidget {
  final double value;
  final double max;
  final ValueChanged<double> onChanged;

  const BetSlider({
    super.key,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 10,
        activeTrackColor: AppColors.primaryRed,
        inactiveTrackColor: Colors.grey.shade300,
        thumbColor: AppColors.primaryRed,
        overlayColor: AppColors.primaryRed.withValues(alpha: 0.18),
        thumbShape: DollarThumbShape(),
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: value.clamp(0, max),
        min: 0,
        max: max,
        divisions: max.toInt(),
        onChanged: onChanged,
      ),
    );
  }
}

class DollarThumbShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(28, 28);

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final canvas = context.canvas;
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = AppColors.yellow
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      center,
      11,
      Paint()
        ..color = AppColors.primaryRed
        ..style = PaintingStyle.fill,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }
}