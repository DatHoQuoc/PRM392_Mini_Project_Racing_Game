import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/enums/track_type.dart';
import '../../../core/utils/track_geometry.dart';

/// Draws a single track's shape diagram inside a card's top half:
/// light-grey grid background, a sky-blue road band with navy outline,
/// and a white dashed centre-line. Reuses [TrackGeometry] so the shapes
/// match the real race tracks.
class TrackShapePainter extends CustomPainter {
  final TrackType type;

  const TrackShapePainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);

    final pts = TrackGeometry.getTrackPoints(type);
    if (pts.length < 2) return;

    // Fit the absolute-canvas points into this widget with padding.
    const pad = 16.0;
    var minX = double.infinity, minY = double.infinity;
    var maxX = -double.infinity, maxY = -double.infinity;
    for (final p in pts) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }
    final spanX = (maxX - minX).clamp(1.0, double.infinity);
    final spanY = (maxY - minY).clamp(1.0, double.infinity);
    final scale = ((size.width - pad * 2) / spanX)
        .clamp(0.0, (size.height - pad * 2) / spanY);
    // Centre the scaled shape.
    final offX = (size.width - spanX * scale) / 2 - minX * scale;
    final offY = (size.height - spanY * scale) / 2 - minY * scale;

    Offset map(int i) =>
        Offset(pts[i].x * scale + offX, pts[i].y * scale + offY);

    final path = Path()..moveTo(map(0).dx, map(0).dy);
    for (var i = 1; i < pts.length; i++) {
      final o = map(i);
      path.lineTo(o.dx, o.dy);
    }
    path.close();

    // Navy outline (band + 2px outline each side).
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.navy
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
    // Sky-blue road surface.
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.skyBlue
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );

    _drawDashedCenter(canvas, pts, map);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..strokeWidth = 0.6;
    const step = 16.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _drawDashedCenter(
      Canvas canvas, List pts, Offset Function(int) map) {
    final dash = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool drawing = false;
    for (var i = 0; i < pts.length; i++) {
      final o = map(i);
      if (i % 10 < 5) {
        if (!drawing) {
          path.moveTo(o.dx, o.dy);
          drawing = true;
        } else {
          path.lineTo(o.dx, o.dy);
        }
      } else {
        drawing = false;
      }
    }
    canvas.drawPath(path, dash);
  }

  @override
  bool shouldRepaint(covariant TrackShapePainter old) => old.type != type;
}
