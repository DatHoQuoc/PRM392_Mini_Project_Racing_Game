/// All user-facing string literals in one place.
class AppStrings {
  AppStrings._();

  // ── General ───────────────────────────────────────────────
  static const String appName    = 'Race Game';
  static const String appVersion = 'v1.0.0';

  // ── Login screen ──────────────────────────────────────────
  static const String loginLogo         = 'TURBO RACE';
  static const String loginTagline      = 'Place your bets. Start your engines.';
  static const String loginTitle        = 'LOGIN';
  static const String loginUsernameHint = 'Username';
  static const String loginPasswordHint = 'Password';
  static const String loginButton       = 'START RACING';

  /// Demo credentials (hard-coded auth for the mini-project).
  static const String demoUsername = 'user';
  static const String demoPassword = '1234';
  static const String demoHint     = 'user / 1234';

  // ── Track names ───────────────────────────────────────────
  static const String trackFigure8   = 'Figure 8';
  static const String trackOval      = 'Oval';
  static const String trackSquare    = 'Square';
  static const String trackF1        = 'Grand Prix';

  // ── Track taglines ────────────────────────────────────────
  static const String taglineFigure8 = 'Infinity loop with center crossover';
  static const String taglineOval    = 'Stadium track, biggest grandstand';
  static const String taglineSquare  = 'Rounded rectangle with tire barriers';
  static const String taglineF1      = 'Technical F1 circuit: chicane, sweepers & hairpin';

  // ── Track themes ─────────────────────────────────────────
  static const String themeFigure8   = 'Technical / Urban';
  static const String themeOval      = 'Stadium / Professional';
  static const String themeSquare    = 'Classic / Retro';
  static const String themeF1        = 'Formula / Pro';

  // ── Car names ─────────────────────────────────────────────
  static const String carThunder = 'Thunder';
  static const String carStorm   = 'Storm';
  static const String carBlaze   = 'Blaze';
}