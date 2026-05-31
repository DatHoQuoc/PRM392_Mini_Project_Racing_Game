import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/track_option_model.dart';
import '../track_select/track_select_screen.dart';
import '../car_select/car_select_screen.dart';

/// ⚠️ TEMPORARY PLACEHOLDER — NOT a real screen.
///
/// Screen 2 is owned by another team member. This stub only exists so the
/// login flow has somewhere to land. It opens the Track Selection screen and
/// remembers the chosen track. Delete this file and point
/// [LoginScreen.nextRoute] at the real Screen 2 once it's ready.
class Screen2Placeholder extends StatefulWidget {
  const Screen2Placeholder({super.key});

  @override
  State<Screen2Placeholder> createState() => _Screen2PlaceholderState();
}

class _Screen2PlaceholderState extends State<Screen2Placeholder> {
  /// Track chosen on the selection screen, kept here so it survives across
  /// navigation. null until the user confirms a track.
  TrackOption? _selectedTrack;

  Future<void> _openTrackSelect() async {
    final result = await Navigator.of(context).pushNamed(
      TrackSelectScreen.route,
    );
    if (result is TrackOption) {
      setState(() => _selectedTrack = result);
    }
  }

  /// Confirm, then log out back to the Login screen (clearing the nav stack so
  /// the user can't "back" into the game). Login replaced itself when entering,
  /// so a plain pop wouldn't reach it.
  Future<void> _backToLogin() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will return to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final track = _selectedTrack;
    return Scaffold(
     
     //Play button is added here for testing navigation to car select screen, can be removed when screen 2 is implemented and linked to car select screen.
      backgroundColor: AppColors.navy,
       floatingActionButton: FloatingActionButton.extended(
    onPressed: () {
      Navigator.of(context).pushNamed(CarSelectScreen.route);
    },
    backgroundColor: AppColors.primaryRed,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: const BorderSide(color: AppColors.yellow, width: 2),
    ),
    icon: const Icon(Icons.play_arrow_rounded, size: 28),
    label: const Text(
      'PLAY',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        fontSize: 15,
      ),
    ),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, color: AppColors.yellow, size: 48),
            const SizedBox(height: 12),
            const Text(
              'SCREEN 2',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Placeholder — login succeeded ✅',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // ── Chosen track summary ─────────────────────────────────
            if (track == null)
              const Text(
                'No track selected yet',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.yellow, width: 1),
                ),
                child: Text(
                  'Selected: ${track.name} · ${track.lengthM}m · ${track.difficulty}',
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _openTrackSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                  side: const BorderSide(color: AppColors.yellow, width: 2),
                ),
              ),
              child: Text(
                track == null ? 'Select Track' : 'Change Track',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _backToLogin,
              child: const Text(
                'Back to Login',
                style: TextStyle(color: AppColors.yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
