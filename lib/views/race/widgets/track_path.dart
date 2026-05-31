import 'dart:math';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  Equivalent of tracks.ts
// ─────────────────────────────────────────────

/// Track variants (matches Variant in tracks.ts)
enum TrackVariant { figure8, oval, square, f1 }

/// Palette (matches PALETTE in tracks.ts)
class RacePalette {
  static const Color red       = Color(0xFFC33332);
  static const Color sky       = Color(0xFF87CEEB);
  static const Color navy      = Color(0xFF000080);
  static const Color yellow    = Color(0xFFFFFF00);
  static const Color grass     = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color beige     = Color(0xFFF5DEB3);
  static const Color road      = Color(0xFF5a6472);
  static const Color roadEdge  = Color(0xFF000080);
}

/// Point on the track (matches Pt)
class Pt {
  final double x, y;
  const Pt(this.x, this.y);
}

/// Car definition (matches CarDef)
class CarDef {
  final int id;
  final String name;
  final Color color;
  final Color accent;
  const CarDef({required this.id, required this.name, required this.color, required this.accent});
}

/// Cars list (matches CARS in tracks.ts)
const List<CarDef> kCars = [
  CarDef(id: 0, name: 'Thunder', color: RacePalette.red,   accent: Color(0xFF7d1f1e)),
  CarDef(id: 1, name: 'Storm',   color: RacePalette.navy,  accent: Color(0xFF000044)),
  CarDef(id: 2, name: 'Blaze',   color: RacePalette.sky,   accent: Color(0xFF3a7fa3)),
];

/// Track metadata (matches TRACK_META)
class TrackMeta {
  final String name, tagline, theme;
  const TrackMeta({required this.name, required this.tagline, required this.theme});
}

const Map<TrackVariant, TrackMeta> kTrackMeta = {
  TrackVariant.figure8: TrackMeta(name: 'Figure 8',    tagline: 'Infinity loop with center crossover', theme: 'Technical / Urban'),
  TrackVariant.oval:    TrackMeta(name: 'Oval',         tagline: 'Stadium track, biggest grandstand',   theme: 'Stadium / Professional'),
  TrackVariant.square:  TrackMeta(name: 'Square',       tagline: 'Rounded rectangle with tire barriers',theme: 'Classic / Retro'),
  TrackVariant.f1:      TrackMeta(name: 'Grand Prix',   tagline: 'Technical F1 circuit: chicane, sweepers & hairpin', theme: 'Formula / Pro'),
};

/// Canvas logical size (matches CANVAS)
const double kCanvasW = 812;
const double kCanvasH = 303;

const int _kSamples = 720;

// ── Point generators ─────────────────────────────────────────

List<Pt> _ovalPoints() {
  const cx = kCanvasW / 2;
  const cy = kCanvasH / 2 + 18;
  const rx = 318.0, ry = 112.0;
  const start = pi / 2;
  return List.generate(_kSamples, (i) {
    final t = start + (i / _kSamples) * pi * 2;
    return Pt(cx + rx * cos(t), cy + ry * sin(t));
  });
}

List<Pt> _figure8Points() {
  const cx = kCanvasW / 2;
  const cy = kCanvasH / 2 + 14;
  const ax = 300.0, ay = 104.0;
  const start = pi / 4;
  return List.generate(_kSamples, (i) {
    final t = start + (i / _kSamples) * pi * 2;
    return Pt(cx + ax * sin(t), cy + ay * sin(2 * t));
  });
}

List<Pt> _squarePoints() {
  const cx = kCanvasW / 2;
  const cy = kCanvasH / 2 + 18;
  const halfW = 290.0, halfH = 105.0, r = 70.0;
  final left   = cx - halfW;
  final right  = cx + halfW;
  final top    = cy - halfH;
  final bottom = cy + halfH;

  // Segment types
  final segs = <_Seg>[];
  Pt lp(double x, double y) => Pt(x, y);

  segs.add(_LineSeg(lp(cx, bottom), lp(right - r, bottom)));
  segs.add(_ArcSeg(right - r, bottom - r, r, pi / 2, 0));
  segs.add(_LineSeg(lp(right, bottom - r), lp(right, top + r)));
  segs.add(_ArcSeg(right - r, top + r, r, 0, -pi / 2));
  segs.add(_LineSeg(lp(right - r, top), lp(left + r, top)));
  segs.add(_ArcSeg(left + r, top + r, r, -pi / 2, -pi));
  segs.add(_LineSeg(lp(left, top + r), lp(left, bottom - r)));
  segs.add(_ArcSeg(left + r, bottom - r, r, pi, pi / 2));
  segs.add(_LineSeg(lp(left + r, bottom), lp(cx, bottom)));

  final total = segs.fold(0.0, (s, seg) => s + seg.len);
  final pts = <Pt>[];

  for (int i = 0; i < _kSamples; i++) {
    double dist = (i / _kSamples) * total;
    for (int si = 0; si < segs.length; si++) {
      final seg = segs[si];
      if (dist <= seg.len || si == segs.length - 1) {
        final u = seg.len == 0 ? 0.0 : dist / seg.len;
        pts.add(seg.pointAt(u));
        break;
      }
      dist -= seg.len;
    }
  }
  return pts;
}

List<Pt> _catmullRomClosed(List<Pt> cps, int perSeg) {
  final n = cps.length;
  final out = <Pt>[];
  for (int i = 0; i < n; i++) {
    final p0 = cps[(i - 1 + n) % n];
    final p1 = cps[i];
    final p2 = cps[(i + 1) % n];
    final p3 = cps[(i + 2) % n];
    for (int j = 0; j < perSeg; j++) {
      final t = j / perSeg;
      final t2 = t * t, t3 = t2 * t;
      final x = 0.5 * (2 * p1.x + (-p0.x + p2.x) * t + (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x) * t2 + (-p0.x + 3 * p1.x - 3 * p2.x + p3.x) * t3);
      final y = 0.5 * (2 * p1.y + (-p0.y + p2.y) * t + (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y) * t2 + (-p0.y + 3 * p1.y - 3 * p2.y + p3.y) * t3);
      out.add(Pt(x, y));
    }
  }
  return out;
}

List<Pt> _resampleByLength(List<Pt> pts, int count) {
  final n = pts.length;
  final cum = List<double>.filled(n + 1, 0);
  for (int i = 1; i <= n; i++) {
    final a = pts[i - 1], b = pts[i % n];
    cum[i] = cum[i - 1] + sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
  }
  final total = cum[n];
  final out = <Pt>[];
  int seg = 0;
  for (int i = 0; i < count; i++) {
    final target = (i / count) * total;
    while (seg < n && cum[seg + 1] < target) seg++;
    final segLen = (cum[seg + 1] - cum[seg]).abs();
    final u = segLen == 0 ? 0.0 : (target - cum[seg]) / segLen;
    final a = pts[seg % n], b = pts[(seg + 1) % n];
    out.add(Pt(a.x + (b.x - a.x) * u, a.y + (b.y - a.y) * u));
  }
  return out;
}

List<Pt> _f1Points() {
  final cps = <Pt>[
    Pt(110, 252), Pt(330, 264), Pt(545, 256), Pt(675, 232),
    Pt(728, 182), Pt(678, 150), Pt(590, 168), Pt(512, 142),
    Pt(556, 96),  Pt(652, 86),  Pt(718, 64),  Pt(648, 42),
    Pt(520, 58),  Pt(392, 44),  Pt(250, 60),  Pt(142, 96),
    Pt(96, 150),  Pt(168, 182), Pt(248, 174), Pt(196, 224),
  ];
  final dense = _catmullRomClosed(cps, 36);
  return _resampleByLength(dense, _kSamples);
}

/// Returns the 720-point closed loop for the given variant (matches getTrackPoints)
List<Pt> getTrackPoints(TrackVariant variant) {
  switch (variant) {
    case TrackVariant.oval:    return _ovalPoints();
    case TrackVariant.figure8: return _figure8Points();
    case TrackVariant.square:  return _squarePoints();
    case TrackVariant.f1:      return _f1Points();
  }
}

/// Result of pointAt — position + heading angle in radians (matches pointAt)
class PointOnTrack {
  final double x, y, angle;
  const PointOnTrack({required this.x, required this.y, required this.angle});
}

/// Position + heading angle at progress p ∈ [0, 1) (matches pointAt)
PointOnTrack pointAt(List<Pt> pts, double p) {
  final n = pts.length;
  final f = ((p % 1) + 1) % 1;
  final idx = f * n;
  final i0 = idx.floor() % n;
  final i1 = (i0 + 1) % n;
  final frac = idx - idx.floor();
  final a = pts[i0], b = pts[i1];
  final x = a.x + (b.x - a.x) * frac;
  final y = a.y + (b.y - a.y) * frac;
  final ahead = pts[(i0 + 6) % n];
  final angle = atan2(ahead.y - a.y, ahead.x - a.x);
  return PointOnTrack(x: x, y: y, angle: angle);
}

// ── Internal segment helpers for squarePoints ────────────────

abstract class _Seg {
  double get len;
  Pt pointAt(double u);
}

class _LineSeg extends _Seg {
  final Pt a, b;
  _LineSeg(this.a, this.b);
  @override double get len => sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2));
  @override Pt pointAt(double u) => Pt(a.x + (b.x - a.x) * u, a.y + (b.y - a.y) * u);
}

class _ArcSeg extends _Seg {
  final double cx, cy, r, a0, a1;
  _ArcSeg(this.cx, this.cy, this.r, this.a0, this.a1);
  @override double get len => (a1 - a0).abs() * r;
  @override Pt pointAt(double u) {
    final a = a0 + (a1 - a0) * u;
    return Pt(cx + r * cos(a), cy + r * sin(a));
  }
}