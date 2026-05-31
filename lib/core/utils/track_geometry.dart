import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../core/enums/track_type.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Value types
// ─────────────────────────────────────────────────────────────────────────────

/// A 2-D point on the canvas. Matches [Pt] in the original tracks.dart.
class TrackPoint {
  final double x, y;
  const TrackPoint(this.x, this.y);
}

/// Position + heading returned by [TrackGeometry.pointAt].
/// Matches [PointOnTrack] in the original tracks.dart.
class PointOnTrack {
  final double x, y, angle;
  const PointOnTrack({required this.x, required this.y, required this.angle});
}

// ─────────────────────────────────────────────────────────────────────────────
//  Public API
// ─────────────────────────────────────────────────────────────────────────────

/// Pure geometry helpers — no Flutter widgets, no state.
///
/// Usage:
/// ```dart
/// final pts = TrackGeometry.getTrackPoints(TrackType.oval);
/// final pos = TrackGeometry.pointAt(pts, 0.25); // 25 % around the loop
/// ```
class TrackGeometry {
  TrackGeometry._();

  /// Returns the [AppConstants.trackSamples]-point closed loop for [type].
  /// Matches `getTrackPoints()` in tracks.dart.
  static List<TrackPoint> getTrackPoints(TrackType type) {
    switch (type) {
      case TrackType.oval:    return _ovalPoints();
      case TrackType.figure8: return _figure8Points();
      case TrackType.square:  return _squarePoints();
      case TrackType.f1:      return _f1Points();
    }
  }

  /// Position + heading angle at normalised progress [p] ∈ [0, 1).
  /// Matches `pointAt()` in tracks.dart.
  static PointOnTrack pointAt(List<TrackPoint> pts, double p) {
    final n   = pts.length;
    final f   = ((p % 1) + 1) % 1;
    final idx = f * n;
    final i0  = idx.floor() % n;
    final i1  = (i0 + 1) % n;
    final frac = idx - idx.floor();

    final a = pts[i0], b = pts[i1];
    final x = a.x + (b.x - a.x) * frac;
    final y = a.y + (b.y - a.y) * frac;

    final ahead = pts[(i0 + 6) % n];
    final angle = atan2(ahead.y - a.y, ahead.x - a.x);
    return PointOnTrack(x: x, y: y, angle: angle);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Private point generators
// ─────────────────────────────────────────────────────────────────────────────

const int    _s  = AppConstants.trackSamples;
const double _cw = AppConstants.trackCanvasWidth;
const double _ch = AppConstants.trackCanvasHeight;

List<TrackPoint> _ovalPoints() {
  const cx = _cw / 2;
  const cy = _ch / 2 + 18;
  const rx = 318.0, ry = 112.0;
  const start = pi / 2;
  return List.generate(_s, (i) {
    final t = start + (i / _s) * pi * 2;
    return TrackPoint(cx + rx * cos(t), cy + ry * sin(t));
  });
}

List<TrackPoint> _figure8Points() {
  const cx = _cw / 2;
  const cy = _ch / 2 + 14;
  const ax = 300.0, ay = 104.0;
  const start = pi / 4;
  return List.generate(_s, (i) {
    final t = start + (i / _s) * pi * 2;
    return TrackPoint(cx + ax * sin(t), cy + ay * sin(2 * t));
  });
}

List<TrackPoint> _squarePoints() {
  const cx     = _cw / 2;
  const cy     = _ch / 2 + 18;
  const halfW  = 290.0, halfH = 105.0, r = 70.0;
  final left   = cx - halfW;
  final right  = cx + halfW;
  final top    = cy - halfH;
  final bottom = cy + halfH;

  final segs = <_Seg>[
    _LineSeg(TrackPoint(cx,        bottom),    TrackPoint(right - r, bottom)),
    _ArcSeg(right - r, bottom - r, r,  pi / 2,  0),
    _LineSeg(TrackPoint(right,     bottom - r), TrackPoint(right,    top + r)),
    _ArcSeg(right - r, top + r,    r,  0,       -pi / 2),
    _LineSeg(TrackPoint(right - r, top),        TrackPoint(left + r, top)),
    _ArcSeg(left + r,  top + r,    r, -pi / 2, -pi),
    _LineSeg(TrackPoint(left,      top + r),    TrackPoint(left,     bottom - r)),
    _ArcSeg(left + r,  bottom - r, r,  pi,      pi / 2),
    _LineSeg(TrackPoint(left + r,  bottom),     TrackPoint(cx,       bottom)),
  ];

  final total = segs.fold(0.0, (s, seg) => s + seg.len);
  final pts   = <TrackPoint>[];

  for (int i = 0; i < _s; i++) {
    double dist = (i / _s) * total;
    for (int si = 0; si < segs.length; si++) {
      final seg = segs[si];
      if (dist <= seg.len || si == segs.length - 1) {
        pts.add(seg.pointAt(seg.len == 0 ? 0.0 : dist / seg.len));
        break;
      }
      dist -= seg.len;
    }
  }
  return pts;
}

List<TrackPoint> _f1Points() {
  final cps = <TrackPoint>[
    TrackPoint(110, 252), TrackPoint(330, 264), TrackPoint(545, 256), TrackPoint(675, 232),
    TrackPoint(728, 182), TrackPoint(678, 150), TrackPoint(590, 168), TrackPoint(512, 142),
    TrackPoint(556, 96),  TrackPoint(652, 86),  TrackPoint(718, 64),  TrackPoint(648, 42),
    TrackPoint(520, 58),  TrackPoint(392, 44),  TrackPoint(250, 60),  TrackPoint(142, 96),
    TrackPoint(96, 150),  TrackPoint(168, 182), TrackPoint(248, 174), TrackPoint(196, 224),
  ];
  final dense = _catmullRomClosed(cps, 36);
  return _resampleByLength(dense, _s);
}

// ── Curve helpers ─────────────────────────────────────────────────────────────

List<TrackPoint> _catmullRomClosed(List<TrackPoint> cps, int perSeg) {
  final n   = cps.length;
  final out = <TrackPoint>[];
  for (int i = 0; i < n; i++) {
    final p0 = cps[(i - 1 + n) % n];
    final p1 = cps[i];
    final p2 = cps[(i + 1) % n];
    final p3 = cps[(i + 2) % n];
    for (int j = 0; j < perSeg; j++) {
      final t  = j / perSeg;
      final t2 = t * t, t3 = t2 * t;
      final x = 0.5 * (2 * p1.x + (-p0.x + p2.x) * t +
          (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 +
          (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3);
      final y = 0.5 * (2 * p1.y + (-p0.y + p2.y) * t +
          (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 +
          (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3);
      out.add(TrackPoint(x, y));
    }
  }
  return out;
}

List<TrackPoint> _resampleByLength(List<TrackPoint> pts, int count) {
  final n   = pts.length;
  final cum = List<double>.filled(n + 1, 0);
  for (int i = 1; i <= n; i++) {
    final a = pts[i - 1], b = pts[i % n];
    cum[i] = cum[i - 1] + sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
  }
  final total = cum[n];
  final out   = <TrackPoint>[];
  int seg = 0;
  for (int i = 0; i < count; i++) {
    final target = (i / count) * total;
    while (seg < n && cum[seg + 1] < target) seg++;
    final segLen = (cum[seg + 1] - cum[seg]).abs();
    final u      = segLen == 0 ? 0.0 : (target - cum[seg]) / segLen;
    final a = pts[seg % n], b = pts[(seg + 1) % n];
    out.add(TrackPoint(a.x + (b.x - a.x) * u, a.y + (b.y - a.y) * u));
  }
  return out;
}

// ── Segment helpers (square track) ───────────────────────────────────────────

abstract class _Seg {
  double get len;
  TrackPoint pointAt(double u);
}

class _LineSeg extends _Seg {
  final TrackPoint a, b;
  _LineSeg(this.a, this.b);
  @override double get len => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
  @override TrackPoint pointAt(double u) =>
      TrackPoint(a.x + (b.x - a.x) * u, a.y + (b.y - a.y) * u);
}

class _ArcSeg extends _Seg {
  final double cx, cy, r, a0, a1;
  _ArcSeg(this.cx, this.cy, this.r, this.a0, this.a1);
  @override double get len => (a1 - a0).abs() * r;
  @override TrackPoint pointAt(double u) {
    final a = a0 + (a1 - a0) * u;
    return TrackPoint(cx + r * cos(a), cy + r * sin(a));
  }
}