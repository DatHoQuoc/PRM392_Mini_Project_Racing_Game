import 'package:flutter/material.dart';

class CarImage extends StatelessWidget {
  final String assetPath;
  final Color color;
  final bool tintWhite;
  final double size;

  const CarImage({
    super.key,
    required this.assetPath,
    required this.color,
    required this.tintWhite,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.isNotEmpty) {
      return ColorFiltered(
        colorFilter: tintWhite
            ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
            : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
        child: Image.asset(
          assetPath,
          width: size,
          height: size * 1.6,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              FallbackCar(color: tintWhite ? Colors.white : color, size: size),
        ),
      );
    }
    return FallbackCar(color: tintWhite ? Colors.white : color, size: size);
  }
}

class FallbackCar extends StatelessWidget {
  final Color color;
  final double size;
  const FallbackCar({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.6,
      child: CustomPaint(painter: CarPainter(color: color)),
    );
  }
}

class CarPainter extends CustomPainter {
  final Color color;
  const CarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = color;
    final windowPaint = Paint()
      ..color = Colors.lightBlue.shade100.withValues(alpha: 0.85);
    final wheelPaint = Paint()..color = Colors.black87;
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1;
    final spoilerPaint = Paint()..color = color.withValues(alpha: 0.7);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.08, w * 0.70, h * 0.84),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.56, h * 0.22),
        Radius.circular(w * 0.10),
      ),
      windowPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.24, h * 0.62, w * 0.52, h * 0.16),
        Radius.circular(w * 0.08),
      ),
      windowPaint,
    );

    canvas.drawLine(
      Offset(w * 0.50, h * 0.10),
      Offset(w * 0.50, h * 0.90),
      linePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.04, w * 0.84, h * 0.08),
        const Radius.circular(3),
      ),
      spoilerPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.10, h * 0.88, w * 0.80, h * 0.06),
        const Radius.circular(3),
      ),
      spoilerPaint,
    );

    final wheelW = w * 0.18;
    final wheelH = h * 0.18;
    final wheelRadius = Radius.circular(wheelW * 0.35);
    for (final rect in [
      Rect.fromLTWH(0, h * 0.12, wheelW, wheelH),
      Rect.fromLTWH(w - wheelW, h * 0.12, wheelW, wheelH),
      Rect.fromLTWH(0, h * 0.70, wheelW, wheelH),
      Rect.fromLTWH(w - wheelW, h * 0.70, wheelW, wheelH),
    ]) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, wheelRadius), wheelPaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(2), wheelRadius),
        Paint()..color = Colors.grey.shade700,
      );
    }
  }

  @override
  bool shouldRepaint(CarPainter old) => old.color != color;
}