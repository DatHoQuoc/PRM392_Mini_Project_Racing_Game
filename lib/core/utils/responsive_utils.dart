import 'package:flutter/material.dart';

const double kMobileBreakpoint = 768;

/// Drop-in equivalent of useIsMobile()
/// Usage: ResponsiveUtils.isMobile(context)
class ResponsiveUtils {
  const ResponsiveUtils._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < kMobileBreakpoint;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}