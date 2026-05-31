import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ToastType { success, error, info, warning }

class ToastService {
  // Private constructor — static-only class
  const ToastService._();

  /// Show a toast. Call from anywhere with a valid BuildContext.
  /// Replaces: toast({ title, description, variant })
  static void show(
      BuildContext context, {
        required String title,
        String? description,
        ToastType type = ToastType.info,
        Duration duration = const Duration(seconds: 3),
      }) {
    final messenger = ScaffoldMessenger.of(context);

    // Dismiss any existing toast first (mirrors TOAST_LIMIT = 1)
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: _backgroundFor(type),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ],
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => messenger.clearSnackBars(),
        ),
      ),
    );
  }

  /// Shorthand helpers — mirrors toast({ variant: 'destructive' }) etc.
  static void success(BuildContext context, String title, {String? description}) =>
      show(context, title: title, description: description, type: ToastType.success);

  static void error(BuildContext context, String title, {String? description}) =>
      show(context, title: title, description: description, type: ToastType.error);

  static void warning(BuildContext context, String title, {String? description}) =>
      show(context, title: title, description: description, type: ToastType.warning);

  static Color _backgroundFor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF2E7D32); // green
      case ToastType.error:
        return AppColors.primaryRed;    // #C33332 from your palette
      case ToastType.warning:
        return const Color(0xFFF57C00); // orange
      case ToastType.info:
        return AppColors.navy;          // #000080 from your palette
    }
  }
}