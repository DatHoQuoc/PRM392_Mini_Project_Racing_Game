import '../../core/enums/track_type.dart';

/// A selectable track on the Track Selection screen — track shape plus the
/// gameplay metadata shown on its card. Plain Dart (no Flutter dependency);
/// difficulty is a string, mapped to a colour in the UI layer.
/// Seed data lives in assets/data/tracks.json.
class TrackOption {
  final int       id;
  final TrackType type;
  final String    name;
  /// HARD / MEDIUM / EASY / EXPERT.
  final String    difficulty;
  final String    description;
  /// Track length in metres.
  final int       lengthM;
  /// Asset path for the preview thumbnail (e.g. "assets/images/tracks/…").
  final String    previewAsset;

  const TrackOption({
    required this.id,
    required this.type,
    required this.name,
    required this.difficulty,
    required this.description,
    required this.lengthM,
    this.previewAsset = '',
  });

  // ── JSON ──────────────────────────────────────────────────

  factory TrackOption.fromJson(Map<String, dynamic> json) => TrackOption(
    id:          json['id']   as int,
    type:        TrackType.values.firstWhere(
          (e) => e.name == (json['type'] as String),
    ),
    name:         json['name']        as String,
    difficulty:   json['difficulty']  as String? ?? 'MEDIUM',
    description:  json['description']  as String? ?? '',
    lengthM:      (json['lengthM']    as num?)?.toInt() ?? 0,
    previewAsset: json['previewAsset'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id':           id,
    'type':         type.name,
    'name':         name,
    'difficulty':   difficulty,
    'description':  description,
    'lengthM':      lengthM,
    'previewAsset': previewAsset,
  };

  @override
  String toString() => 'TrackOption(id: $id, name: $name)';
}
