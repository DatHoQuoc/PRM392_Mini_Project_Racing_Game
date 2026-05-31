/// Asset path constants — single source of truth for all asset strings.
class AppAssets {
  AppAssets._();

  // ── Audio ─────────────────────────────────────────────────
  static const String audioBegin        = 'assets/audio/begin.mp3';
  static const String audioRacing       = 'assets/audio/racing.mp3';
  static const String audioWinner       = 'assets/audio/winner.mp3';
  static const String audioTrackFigure8 = 'assets/audio/track_figure8.mp3';
  static const String audioTrackCircle  = 'assets/audio/track_circle.mp3';
  static const String audioTrackSquare  = 'assets/audio/track_square.mp3';

  // ── Car images ────────────────────────────────────────────
  static const String car1 = 'assets/images/car_1.png';
  static const String car2 = 'assets/images/car_2.png';
  static const String car3 = 'assets/images/car_3.png';

  // ── Track preview images ──────────────────────────────────
  static const String trackPreviewFigure8 = 'assets/images/tracks/figure8_preview.png';
  static const String trackPreviewCircle  = 'assets/images/tracks/circle_preview.png';
  static const String trackPreviewSquare  = 'assets/images/tracks/square_preview.png';

  // ── Data JSON ─────────────────────────────────────────────
  static const String dataCars   = 'assets/data/cars.json';
  static const String dataTracks = 'assets/data/tracks.json';
}