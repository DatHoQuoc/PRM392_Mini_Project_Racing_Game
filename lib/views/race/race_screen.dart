import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import '../../core/enums/race_state.dart';
import '../../core/utils/audio_manager.dart';
import '../../core/utils/track_geometry.dart';
import '../../data/models/car_model.dart';
import '../../data/models/track_model.dart';
import '../../viewmodels/race_viewmodel.dart';
import 'widgets/race_track_painter.dart';
import 'widgets/race_hud.dart';
import 'widgets/app_bar.dart';
import 'widgets/status_strip.dart';

// ── Screen arguments ─────────────────────────────────────────────────────────

class RaceScreenArgs {
  final List<CarModel> cars;
  final TrackModel track;
  final double wallet;
  final double betAmount;
  final int selectedCarId;
  const RaceScreenArgs({
    required this.cars,
    required this.track,
    required this.wallet,
    required this.betAmount,
    required this.selectedCarId,
  });
}

// ── Image loader helper ───────────────────────────────────────────────────────

Future<ui.Image> loadUiImage(String assetPath) async {
  final data  = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}

// ── Screen ────────────────────────────────────────────────────────────────────

class RaceScreen extends StatefulWidget {
  final List<CarModel> cars;
  final TrackModel track;
  final double wallet;
  final double betAmount;
  final int selectedCarId;

  const RaceScreen({
    super.key,
    required this.cars,
    required this.track,
    required this.wallet,
    required this.betAmount,
    required this.selectedCarId,
  });

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen>
    with SingleTickerProviderStateMixin {

  // ── Animation ──────────────────────────────────────────────
  late final Ticker _ticker;
  double _time = 0;

  // ── Track ──────────────────────────────────────────────────
  late final List<TrackPoint> _points;

  // ── Audio ──────────────────────────────────────────────────
  final AudioManager _audio = AudioManager();
  bool _muted = false;

  // ── Car images ─────────────────────────────────────────────
  List<ui.Image?> _carImages = [];

  // ── ViewModel (created once, not inside build) ─────────────
  late final RaceViewModel _vm;

  @override
  void initState() {
    super.initState();

    // 1. Create VM once and init immediately
    _vm = RaceViewModel()..init(widget.cars, widget.track);

    // 2. Listen for state changes → trigger audio (NOT in build)
    _vm.addListener(_onVmChanged);

    // 3. Track geometry
    _points = TrackGeometry.getTrackPoints(widget.track.type);

    // 4. Ticker for 60fps canvas repaints
    _ticker = createTicker(
          (elapsed) => setState(() => _time = elapsed.inMilliseconds.toDouble()),
    );
    _ticker.start();

    // 5. Load car images
    _loadCarImages();

    // 6. Start ready-state audio immediately
    _audio.onStateChanged(_vm.state, widget.track.type);
  }

  /// Called by VM's notifyListeners — safe place to trigger audio
  /// because it's outside the build cycle.
  void _onVmChanged() {
    _audio.onStateChanged(_vm.state, widget.track.type);
  }

  Future<void> _loadCarImages() async {
    final images = await Future.wait(
      widget.cars.map((car) async {
        if (car.assetPath.isEmpty) return null;
        try {
          return await loadUiImage(car.assetPath);
        } catch (e) {
          debugPrint('❌ failed to load ${car.assetPath}: $e');
          return null;
        }
      }),
    );
    if (mounted) setState(() => _carImages = images);
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmChanged); // clean up listener
    _vm.dispose();
    _audio.stop();
    _ticker.dispose();
    super.dispose();
  }

  void _handleResults() {
    final order = widget.cars
        .map((c) => (id: c.id, p: _vm.overallProgress(c.id)))
        .toList()
      ..sort((a, b) => b.p.compareTo(a.p));

    Navigator.of(context).pushReplacementNamed(
      '/results',
      arguments: {
        'track': widget.track,
        'winner': _vm.winnerId ?? order.first.id,
        'order': order.map((e) => e.id).toList(),
        'wallet': widget.wallet,
        'betAmount': widget.betAmount,
        'selectedCarId': widget.selectedCarId,

        'cars': widget.cars,
      },
    );
  }

  Future<void> _toggleMute() async {
    await _audio.toggleMute();
    setState(() => _muted = !_muted);
  }

  int? get _winnerIndex {
    if (_vm.winnerId == null) return null;
    return widget.cars.indexWhere((c) => c.id == _vm.winnerId);
  }

  @override
  Widget build(BuildContext context) {
    // Use ListenableBuilder so only the parts that need vm data rebuild,
    // and the ticker-driven setState only repaints the canvas.
    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        final progressList = widget.cars
            .map((c) => _vm.overallProgress(c.id))
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A1A),
          body: SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF404040), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      // ── App bar — mute button is now wired ──────────
                      RaceAppBar(
                        wallet: widget.wallet,
                        muted: _muted,
                        onMuteToggle: _toggleMute,
                      ),

                      // ── Race canvas ──────────────────────────────────
                      Expanded(
                        child: Row(
                          children: [
                            // Track canvas
                            Expanded(
                              flex: 3,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: RaceTrackPainter(
                                        track: widget.track.type,
                                        points: _points,
                                        progress: progressList,
                                        winnerId: _winnerIndex,
                                        time: _time,
                                        carImages: _carImages,
                                      ),
                                    ),
                                  ),
                                  if (_vm.state == RaceState.countdown)
                                    _CountdownOverlay(countdown: _vm.countdown),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: _TrackTag(
                                        trackName: widget.track.name.toUpperCase()),
                                  ),
                                ],
                              ),
                            ),

                            // HUD panel
                            SizedBox(
                              width: 160,
                              child: RaceHud(
                                cars: widget.cars,
                                progress: progressList,
                                state: _vm.state,
                                winnerId: _winnerIndex,
                                onStart: _vm.startRace,
                                onResults: _handleResults,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Status strip ─────────────────────────────────
                      StatusStrip(
                        state: _vm.state,
                        countdown: _vm.countdown,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _CountdownOverlay extends StatelessWidget {
  final int countdown;
  const _CountdownOverlay({required this.countdown});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => ScaleTransition(
            scale: Tween<double>(begin: 0.6, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.elasticOut),
            ),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Text(
            countdown > 0 ? '$countdown' : 'GO!',
            key: ValueKey(countdown),
            style: const TextStyle(
              color: Color(0xFFFFFF00),
              fontSize: 72,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 12, offset: Offset(0, 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackTag extends StatelessWidget {
  final String trackName;
  const _TrackTag({required this.trackName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xB3000080),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        trackName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}