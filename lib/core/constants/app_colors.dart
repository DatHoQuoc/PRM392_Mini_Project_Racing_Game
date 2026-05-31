import 'package:flutter/material.dart';

/// Converted from globals.css CSS custom properties (oklch → hex approximations)
/// Light mode = default, Dark mode variants provided as separate constants.
abstract class AppColors {
  // ── Light Mode ────────────────────────────────────────────────
  static const Color background         = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color foreground         = Color(0xFF0A0A0A); // oklch(0.145 0 0)

  static const Color card               = Color(0xFFFFFFFF); // oklch(1 0 0)
  static const Color cardForeground     = Color(0xFF0A0A0A);

  static const Color popover            = Color(0xFFFFFFFF);
  static const Color popoverForeground  = Color(0xFF0A0A0A);

  static const Color primary            = Color(0xFF1A1A1A); // oklch(0.205 0 0)
  static const Color primaryForeground  = Color(0xFFFAFAFA); // oklch(0.985 0 0)

  static const Color secondary          = Color(0xFFF5F5F5); // oklch(0.97 0 0)
  static const Color secondaryForeground= Color(0xFF1A1A1A);

  static const Color muted              = Color(0xFFF5F5F5);
  static const Color mutedForeground    = Color(0xFF737373); // oklch(0.556 0 0)

  static const Color accent             = Color(0xFFF5F5F5);
  static const Color accentForeground   = Color(0xFF1A1A1A);

  static const Color destructive        = Color(0xFFE53935); // oklch(0.577 0.245 27.325) ≈ red
  static const Color destructiveForeground = Color(0xFFE53935);

  static const Color border             = Color(0xFFE5E5E5); // oklch(0.922 0 0)
  static const Color input              = Color(0xFFE5E5E5);
  static const Color ring               = Color(0xFFB3B3B3); // oklch(0.708 0 0)

  // Charts
  static const Color chart1             = Color(0xFFE07B39); // oklch(0.646 0.222 41.116) ≈ orange
  static const Color chart2             = Color(0xFF3AAFA9); // oklch(0.6 0.118 184.704) ≈ teal
  static const Color chart3             = Color(0xFF3A5F8A); // oklch(0.398 0.07 227.392) ≈ slate blue
  static const Color chart4             = Color(0xFFD4B800); // oklch(0.828 0.189 84.429) ≈ yellow-green
  static const Color chart5             = Color(0xFFCFA020); // oklch(0.769 0.188 70.08)  ≈ amber

  // Sidebar
  static const Color sidebar            = Color(0xFFFAFAFA); // oklch(0.985 0 0)
  static const Color sidebarForeground  = Color(0xFF0A0A0A);
  static const Color sidebarPrimary     = Color(0xFF1A1A1A);
  static const Color sidebarPrimaryForeground = Color(0xFFFAFAFA);
  static const Color sidebarAccent      = Color(0xFFF5F5F5);
  static const Color sidebarAccentForeground  = Color(0xFF1A1A1A);
  static const Color sidebarBorder      = Color(0xFFE5E5E5);
  static const Color sidebarRing        = Color(0xFFB3B3B3);

  // Border radius (use in widget code as needed)
  static const double radius            = 10.0; // 0.625rem ≈ 10px
  static const double radiusSm         = 6.0;  // radius - 4px
  static const double radiusMd         = 8.0;  // radius - 2px
  static const double radiusLg         = 10.0;
  static const double radiusXl         = 14.0; // radius + 4px

  // ── Dark Mode ─────────────────────────────────────────────────
  static const Color darkBackground         = Color(0xFF0A0A0A); // oklch(0.145 0 0)
  static const Color darkForeground         = Color(0xFFFAFAFA); // oklch(0.985 0 0)

  static const Color darkCard               = Color(0xFF0A0A0A);
  static const Color darkCardForeground     = Color(0xFFFAFAFA);

  static const Color darkPopover            = Color(0xFF0A0A0A);
  static const Color darkPopoverForeground  = Color(0xFFFAFAFA);

  static const Color darkPrimary            = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground  = Color(0xFF1A1A1A);

  static const Color darkSecondary          = Color(0xFF2E2E2E); // oklch(0.269 0 0)
  static const Color darkSecondaryForeground= Color(0xFFFAFAFA);

  static const Color darkMuted              = Color(0xFF2E2E2E);
  static const Color darkMutedForeground    = Color(0xFFB3B3B3); // oklch(0.708 0 0)

  static const Color darkAccent             = Color(0xFF2E2E2E);
  static const Color darkAccentForeground   = Color(0xFFFAFAFA);

  static const Color darkDestructive        = Color(0xFF7A2020); // oklch(0.396 0.141 25.723) ≈ dark red
  static const Color darkDestructiveForeground = Color(0xFFD94F3D); // oklch(0.637 0.237 25.331)

  static const Color darkBorder             = Color(0xFF2E2E2E);
  static const Color darkInput              = Color(0xFF2E2E2E);
  static const Color darkRing               = Color(0xFF6B6B6B); // oklch(0.439 0 0)

  // Dark charts
  static const Color darkChart1             = Color(0xFF5B7FE8); // oklch(0.488 0.243 264.376) ≈ blue-violet
  static const Color darkChart2             = Color(0xFF4DBF8A); // oklch(0.696 0.17 162.48)  ≈ green
  static const Color darkChart3             = Color(0xFFCFA020); // oklch(0.769 0.188 70.08)  ≈ amber
  static const Color darkChart4             = Color(0xFFB84FD4); // oklch(0.627 0.265 303.9)  ≈ purple
  static const Color darkChart5             = Color(0xFFD94F3D); // oklch(0.645 0.246 16.439) ≈ red-orange

  // Dark sidebar
  static const Color darkSidebar            = Color(0xFF1A1A1A); // oklch(0.205 0 0)
  static const Color darkSidebarForeground  = Color(0xFFFAFAFA);
  static const Color darkSidebarPrimary     = Color(0xFF5B7FE8);
  static const Color darkSidebarPrimaryForeground = Color(0xFFFAFAFA);
  static const Color darkSidebarAccent      = Color(0xFF2E2E2E);
  static const Color darkSidebarAccentForeground  = Color(0xFFFAFAFA);
  static const Color darkSidebarBorder      = Color(0xFF2E2E2E);
  static const Color darkSidebarRing        = Color(0xFF6B6B6B);

  // ── Game-specific palette (from ARCHITECTURE.md) ──────────────
  static const Color primaryRed   = Color(0xFFC33332);
  static const Color skyBlue      = Color(0xFF87CEEB);
  static const Color navy         = Color(0xFF000080);
  static const Color yellow       = Color(0xFFFFFF00);
}