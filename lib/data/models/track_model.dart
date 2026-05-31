import '../../core/enums/track_type.dart';

/// Immutable data class for a track.
/// Merges [TrackMeta] from tracks.dart with the existing track_model fields.
/// Seed data lives in assets/data/tracks.json.
class TrackModel {
  final int       id;
  final String    name;
  final String    tagline;
  final String    theme;
  final TrackType type;
  /// Asset path for the preview thumbnail (e.g. "assets/images/tracks/…").
  final String    previewAsset;
  /// Audio key used by AudioManager (maps to a file in assets/audio/).
  final String    audioKey;

  const TrackModel({
    required this.id,
    required this.name,
    required this.tagline,
    required this.theme,
    required this.type,
    this.previewAsset = '',
    this.audioKey     = '',
  });

  // ── JSON ──────────────────────────────────────────────────

  factory TrackModel.fromJson(Map<String, dynamic> json) => TrackModel(
    id:           json['id']           as int,
    name:         json['name']         as String,
    tagline:      json['tagline']      as String,
    theme:        json['theme']        as String,
    type:         TrackType.values.firstWhere(
          (e) => e.name == (json['type'] as String),
    ),
    previewAsset: json['previewAsset'] as String? ?? '',
    audioKey:     json['audioKey']     as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id':           id,
    'name':         name,
    'tagline':      tagline,
    'theme':        theme,
    'type':         type.name,
    'previewAsset': previewAsset,
    'audioKey':     audioKey,
  };

  @override
  String toString() => 'TrackModel(id: $id, name: $name, type: ${type.name})';
}