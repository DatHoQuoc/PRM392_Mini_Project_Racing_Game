/// Shared numeric and layout constants.
class AppConstants {
  AppConstants._();

  // ── Race track canvas ─────────────────────────────────────
  /// Logical width of the track canvas (matches kCanvasW).
  static const double trackCanvasWidth  = 812.0;

  /// Logical height of the track canvas (matches kCanvasH).
  static const double trackCanvasHeight = 303.0;

  /// Number of evenly-spaced samples used to represent a closed track loop.
  static const int trackSamples = 720;
}