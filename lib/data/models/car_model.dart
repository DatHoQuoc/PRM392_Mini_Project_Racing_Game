import 'package:flutter/material.dart';

/// Immutable data class for a single car.
/// Replaces [CarDef] from tracks.dart; seed data lives in assets/data/cars.json.
class CarModel {
  final int    id;
  final String name;
  final Color  color;
  final Color  accent;
  /// Relative top speed used by the race engine (0.0 – 1.0).
  final double speed;
  /// Asset path for the car sprite (e.g. "assets/images/car_1.png").
  final String assetPath;

  const CarModel({
    required this.id,
    required this.name,
    required this.color,
    required this.accent,
    this.speed    = 1.0,
    this.assetPath = '',
  });

  // ── JSON ──────────────────────────────────────────────────

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    id:        json['id']        as int,
    name:      json['name']      as String,
    color:     Color(int.parse((json['color'] as String).replaceFirst('#', '0xFF'))),
    accent:    Color(int.parse((json['accent'] as String).replaceFirst('#', '0xFF'))),
    speed:     (json['speed']    as num?)?.toDouble() ?? 1.0,
    assetPath: json['assetPath'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id':        id,
    'name':      name,
    'color':     '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
    'accent':    '#${accent.value.toRadixString(16).substring(2).toUpperCase()}',
    'speed':     speed,
    'assetPath': assetPath,
  };

  @override
  String toString() => 'CarModel(id: $id, name: $name)';
}