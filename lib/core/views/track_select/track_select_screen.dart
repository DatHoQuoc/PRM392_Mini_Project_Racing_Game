import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/track_viewmodel.dart';
import '../../../views/track_select/widgets/random_card.dart';
import '../../../views/track_select/widgets/track_card.dart';
import '../../constants/app_colors.dart';


/// Maps a difficulty label to its badge colour (UI concern — kept out of the
/// plain-Dart [TrackOption] model).
Color difficultyColor(String difficulty) {
  switch (difficulty.toUpperCase()) {
    case 'HARD':
      return AppColors.primaryRed;
    case 'MEDIUM':
      return const Color(0xFFCFA020); // dark yellow
    case 'EASY':
      return const Color(0xFF2E7D32); // green
    case 'EXPERT':
      return const Color(0xFF6A1B9A); // purple
    default:
      return AppColors.navy;
  }
}

/// Track Selection screen (landscape). Track cards in one row plus a random
/// card and a confirm button. Reached via [TrackSelectScreen.route]; on confirm
/// it pops back to the previous screen, returning the chosen [TrackOption].
class TrackSelectScreen extends StatefulWidget {
  /// Player's wallet balance, shown in the app bar.
  final double wallet;

  const TrackSelectScreen({super.key, this.wallet = 100.0});

  /// Named route for the Track Selection screen.
  static const String route = '/track-select';

  @override
  State<TrackSelectScreen> createState() => _TrackSelectScreenState();
}

class _TrackSelectScreenState extends State<TrackSelectScreen> {
  @override
  void initState() {
    super.initState();
    // Defer the load to after the first frame — loadTracks() calls
    // notifyListeners(), which must not run during the build phase.
    final vm = context.read<TrackViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => vm.loadTracks());
  }

  /// Return the chosen track to the previous screen.
  void _confirm() {
    final track = context.read<TrackViewModel>().selectedTrack;
    if (track != null) Navigator.of(context).pop(track);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TrackViewModel>();
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(wallet: widget.wallet),
            const _Subtitle(),
            Expanded(
              child: vm.tracks.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(color: AppColors.navy),
              )
                  : Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    for (var i = 0; i < vm.tracks.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: TrackCard(
                          type: vm.tracks[i].type,
                          name: vm.tracks[i].name.toUpperCase(),
                          difficulty: vm.tracks[i].difficulty,
                          difficultyColor:
                          difficultyColor(vm.tracks[i].difficulty),
                          description: vm.tracks[i].description,
                          lengthM: vm.tracks[i].lengthM,
                          previewAsset: vm.tracks[i].previewAsset,
                          selected: vm.selectedIndex == i,
                          onTap: () => vm.selectTrack(i),
                        ),
                      ),
                    ],
                    // ── Random pick card ───────────────────────────
                    const SizedBox(width: 12),
                    Expanded(child: RandomCard(onTap: vm.pickRandom)),
                  ],
                ),
              ),
            ),
            _ConfirmBar(
              enabled: vm.hasSelection,
              onConfirm: _confirm,
            ),
          ],
        ),
      ),
    );
  }
}

// ── App bar ─────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final double wallet;
  const _AppBar({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Expanded(
            child: Text(
              'SELECT TRACK',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '💰 \$${wallet.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Subtitle ────────────────────────────────────────────────────────────────────

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Choose your racing course',
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Confirm bar ─────────────────────────────────────────────────────────────────

class _ConfirmBar extends StatelessWidget {
  final bool enabled;
  final VoidCallback onConfirm;
  const _ConfirmBar({required this.enabled, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.navy, width: 1)),
      ),
      child: Center(
        child: SizedBox(
          width: 300,
          height: 40,
          child: ElevatedButton(
            onPressed: enabled ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD0D0D0),
              disabledForegroundColor: const Color(0xFF808080),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'CONFIRM TRACK →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}