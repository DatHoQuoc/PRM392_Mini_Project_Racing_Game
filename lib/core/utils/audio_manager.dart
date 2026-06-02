import 'package:audioplayers/audioplayers.dart';
import '../enums/race_state.dart';
import '../enums/track_type.dart';

/// Singleton that manages all game audio.
///
/// Call [onStateChanged] whenever [RaceState] or [TrackType] changes.
/// The manager figures out which clip to play/loop/stop automatically.
///
/// Usage in RaceScreen:
/// ```dart
/// final _audio = AudioManager();
///
/// // in build, watch vm.state:
/// _audio.onStateChanged(vm.state, widget.track.type);
///
/// // in dispose:
/// _audio.stop();
/// ```
class AudioManager {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final AudioManager _instance = AudioManager._();
  factory AudioManager() => _instance;
  AudioManager._();

  // ── Players ────────────────────────────────────────────────────────────────
  /// Main player — phases (countdown, racing, winner).
  final AudioPlayer _main = AudioPlayer();

  /// Ambient player — track-specific background loop.
  final AudioPlayer _ambient = AudioPlayer();

  // ── Internal state ─────────────────────────────────────────────────────────
  RaceState? _lastState;
  TrackType? _lastTrack;
  bool _muted = false;

  // ── Public API ─────────────────────────────────────────────────────────────

  bool get muted => _muted;

  /// Call this every time RaceState or TrackType changes (e.g. inside build
  /// after `context.watch<RaceViewModel>()`).
  Future<void> onStateChanged(RaceState state, TrackType track) async {
    // Skip if nothing changed
    if (state == _lastState && track == _lastTrack) return;

    final stateChanged = state != _lastState;
    final trackChanged = track != _lastTrack;

    _lastState = state;
    _lastTrack = track;

    if (_muted) return;

    switch (state) {
    // ── Ready: play ambient track loop quietly ─────────────────────────
      case RaceState.idle:
      case RaceState.ready:
        await _main.stop();
        if (trackChanged) {
          await _playAmbient(track);
        }

    // ── Countdown: stop ambient, play begin.mp3 once ──────────────────
      case RaceState.countdown:
        if (stateChanged) {
          await _ambient.stop();
          await _main.setReleaseMode(ReleaseMode.release);
          await _main.setVolume(0.9);
          await _main.play(AssetSource('audio/begin.mp3'));
        }

    // ── Racing: loop racing.mp3, fade ambient back in softly ──────────
      case RaceState.racing:
        if (stateChanged) {
          await _main.setReleaseMode(ReleaseMode.loop);
          await _main.setVolume(0.7);
          await _main.play(AssetSource('audio/racing.mp3'));

          // Soft ambient underneath
          await _ambient.setVolume(0.2);
          await _playAmbient(track);
        }

    // ── Finished: stop racing loop, play winner fanfare ───────────────
      case RaceState.finished:
        if (stateChanged) {
          await _main.stop();
          await _ambient.stop();
          await _main.setReleaseMode(ReleaseMode.release);
          await _main.setVolume(1.0);
          await _main.play(AssetSource('audio/winner.mp3'));
        }
    }
  }

  /// Toggle mute on/off. Pauses or resumes both players.
  Future<void> toggleMute() async {
    _muted = !_muted;
    if (_muted) {
      await _main.pause();
      await _ambient.pause();
    } else {
      await _main.resume();
      await _ambient.resume();
    }
  }

  /// Pause both players (e.g. app goes to background).
  Future<void> pause() async {
    await _main.pause();
    await _ambient.pause();
  }

  /// Resume both players (e.g. app comes to foreground).
  Future<void> resume() async {
    if (_muted) return;
    await _main.resume();
    await _ambient.resume();
  }

  /// Stop everything and reset state (call when leaving race screen).
  Future<void> stop() async {
    await _main.stop();
    await _ambient.stop();
    _lastState = null;
    _lastTrack = null;
  }

  /// Release resources completely (call in app dispose).
  Future<void> dispose() async {
    await _main.dispose();
    await _ambient.dispose();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _playAmbient(TrackType track) async {
    await _ambient.setReleaseMode(ReleaseMode.loop);
    await _ambient.setVolume(0.35);
    await _ambient.play(AssetSource('audio/${_trackAudio(track)}'));
  }

  String _trackAudio(TrackType track) {
    switch (track) {
      case TrackType.oval:    return 'track_circle.mp3';
      case TrackType.figure8: return 'track_figure8.mp3';
      case TrackType.square:  return 'track_square.mp3';
      case TrackType.f1:      return 'track_f1.mp3';
    }
  }
}