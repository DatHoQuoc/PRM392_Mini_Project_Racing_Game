import 'package:flutter/material.dart';

/// Subtle diagonal "speed line" pattern at 10% white opacity, painted across
/// the whole login background to give an arcade / motion feel.
class SpeedLinesPainter extends CustomPainter {
  const SpeedLinesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 2;

    const spacing = 28.0;
    // Diagonal lines (top-right → bottom-left). Start well off-screen on the
    // left so the slanted lines still cover the right edge.
    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) => false;
}
