import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/enums/track_type.dart';
import '../../../core/utils/track_geometry.dart'; // TrackGeometry, TrackPoint, PointOnTrack
import '../../../core/constants/app_constants.dart'; // AppConstants.trackCanvasWidth/Height
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

// ── Car palette / names (shared with RaceHud) ─────────────────────────────

const List<Color> kCarColors = [
  Color(0xFFE63946), // red
  Color(0xFF2EC4B6), // teal
  Color(0xFFFFB703), // amber
];

const List<String> kCarNames = ['Bolt', 'Nova', 'Blaze'];

// ── CustomPainter ──────────────────────────────────────────────────────────

/// Renders the race track + animated cars.
///
/// [points] come from [TrackGeometry.getTrackPoints] — they are in absolute
/// canvas coordinates ([AppConstants.trackCanvasWidth] × [trackCanvasHeight]).
/// The painter applies a uniform scale transform so they fill whatever
/// [Size] Flutter hands us, exactly as the Next.js version does with
/// `ctx.setTransform(sx, 0, 0, sy, 0, 0)`.
class RaceTrackPainter extends CustomPainter {
  final TrackType track;
  final List<TrackPoint> points;
  final List<double> progress; // 0..1 per car
  final int? winnerId;
  final double time; // elapsed ms — drives glow animation
  final List<ui.Image?> carImages;

  const RaceTrackPainter({
    required this.track,
    required this.points,
    required this.progress,
    required this.winnerId,
    required this.time,
    required this.carImages
  });

  // ── coordinate transform ─────────────────────────────────────────────────

  /// Scale factors: logical-canvas → widget pixels.
  /// Mirrors `sx = canvas.width / CANVAS.w` in the Next.js render loop.
  (double sx, double sy) _scale(Size size) => (
  size.width  / AppConstants.trackCanvasWidth,
  size.height / AppConstants.trackCanvasHeight,
  );

  /// Convert an absolute [TrackPoint] to widget-pixel [Offset].
  Offset _pt(TrackPoint p, double sx, double sy) =>
      Offset(p.x * sx, p.y * sy);

  // ── paint ────────────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    final (sx, sy) = _scale(size);
    _drawBackground(canvas, size);
    _drawTrackSurface(canvas, size, sx, sy);
    _drawTrackMarkings(canvas, size, sx, sy);
    _drawStartFinishLine(canvas, sx, sy);
    _drawCars(canvas, sx, sy);
  }

  // ── background ───────────────────────────────────────────────────────────

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A2E1A), Color(0xFF0D1F0D)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    final gridPaint = Paint()
      ..color = const Color(0xFF1E341E)
      ..strokeWidth = 0.5;
    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  // ── track surface (3 stroked passes) ────────────────────────────────────

  void _drawTrackSurface(Canvas canvas, Size size, double sx, double sy) {
    if (points.length < 2) return;
    // Scale the stroke width by the smaller of sx/sy so it looks consistent
    final s = min(sx, sy);
    for (final (width, color) in [
      (38.0 * s, Colors.black.withOpacity(0.5)),   // shadow
      (30.0 * s, const Color(0xFF3A3A3A)),           // base asphalt
      (26.0 * s, const Color(0xFF4E4E4E)),           // surface
    ]) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(_trackPath(sx, sy), paint);
    }
  }

  // ── centre dashed line ───────────────────────────────────────────────────

  void _drawTrackMarkings(Canvas canvas, Size size, double sx, double sy) {
    if (points.length < 2) return;
    final s = min(sx, sy);
    final dashPaint = Paint()
      ..color = const Color(0xFFFFFF00).withOpacity(0.35)
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool drawing = false;
    for (int i = 0; i < points.length; i++) {
      final p = _pt(points[i], sx, sy);
      if (i % 8 < 4) {
        if (!drawing) { path.moveTo(p.dx, p.dy); drawing = true; }
        else            { path.lineTo(p.dx, p.dy); }
      } else {
        drawing = false;
      }
    }
    canvas.drawPath(path, dashPaint);
  }

  // ── start / finish line ──────────────────────────────────────────────────

  void _drawStartFinishLine(Canvas canvas, double sx, double sy) {
    if (points.isEmpty) return;
    final s = min(sx, sy);
    final start = _pt(points[0], sx, sy);
    final next  = _pt(points[min(6, points.length - 1)], sx, sy);

    final dir  = next - start;
    final perp = Offset(-dir.dy, dir.dx);
    if (perp.distance == 0) return;
    final norm = perp / perp.distance * 18 * s;

    // White line
    canvas.drawLine(start - norm, start + norm,
        Paint()..color = Colors.white..strokeWidth = 3 * s);

    // Chequered dots
    final dot = Paint()..color = Colors.black;
    for (int i = -2; i <= 2; i++) {
      if (i.isEven) canvas.drawCircle(start + norm * (i / 2.5), 2.5 * s, dot);
    }
  }

  // ── cars ─────────────────────────────────────────────────────────────────

  void _drawCars(Canvas canvas, double sx, double sy) {
    final s = min(sx, sy);
    for (int i = 0; i < min(3, progress.length); i++) {
      final pot = TrackGeometry.pointAt(points, progress[i]);
      final pos = Offset(pot.x * sx, pot.y * sy);
      final img = i < carImages.length ? carImages[i] : null;
      _drawCar(canvas, pos, s, kCarColors[i], winnerId == i && progress[i] >= 1.0, i, img);
    }
  }

  void _drawCar(Canvas canvas, Offset pos, double s,
      Color color, bool isWinner, int idx, ui.Image? image) {
    final r = 7.0 * s;

    if (isWinner) {
      canvas.drawCircle(
        pos, r * 1.5,
        Paint()
          ..color = const Color(0xFFFFD700)
              .withOpacity(0.4 + 0.3 * sin(time * 0.005 + idx))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * s),
      );
    }

    if (image != null) {
      // ── Draw sprite image ──────────────────────────────────
      final size   = r * 2.5;
      final dst    = Rect.fromCenter(center: pos, width: size, height: size);
      final src    = Rect.fromLTWH(0, 0,
          image.width.toDouble(), image.height.toDouble());
      canvas.drawImageRect(image, src, dst, Paint());
    } else {
      // ── Fallback: circle with number ───────────────────────
      canvas.drawCircle(pos + Offset(s, 1.5 * s), r,
          Paint()
            ..color = Colors.black.withOpacity(0.4)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * s));

      canvas.drawCircle(pos, r, Paint()..color = color);

      canvas.drawCircle(pos + Offset(-2 * s, -2 * s), 2.5 * s,
          Paint()..color = Colors.white.withOpacity(0.35));

      canvas.drawCircle(pos, r,
          Paint()
            ..color = Colors.white.withOpacity(0.8)
            ..strokeWidth = 1.2 * s
            ..style = PaintingStyle.stroke);

      final tp = TextPainter(
        text: TextSpan(
          text: '${idx + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 7 * s,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Path _trackPath(double sx, double sy) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final p = _pt(points[i], sx, sy);
      if (i == 0) path.moveTo(p.dx, p.dy);
      else        path.lineTo(p.dx, p.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(RaceTrackPainter old) =>
      progress != old.progress ||
          time != old.time ||
          winnerId != old.winnerId ||
          track != old.track;
}