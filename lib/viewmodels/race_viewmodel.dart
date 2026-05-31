import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/enums/race_state.dart';
import '../data/models/car_model.dart';
import '../data/models/track_model.dart';

/// Drives the race simulation.
///
/// Each car advances along the track at its own speed (slightly randomised
/// each tick so the race feels alive). Progress is a value in [0, 1).
/// The first car to complete [totalLaps] laps wins.
class RaceViewModel extends ChangeNotifier {
  // ── Config ─────────────────────────────────────────────────
  static const int    totalLaps        = 3;
  static const int    countdownSeconds = 3;
  /// Tick interval – ~60 fps.
  static const Duration _tickInterval  = Duration(milliseconds: 16);
  /// Base progress increment per tick (tune for desired race length).
  static const double _baseSpeed       = 0.008;

  // ── Input ──────────────────────────────────────────────────
  late List<CarModel> _cars;
  late TrackModel     _track;

  // ── State ──────────────────────────────────────────────────
  RaceState _state       = RaceState.ready;
  int       _countdown   = countdownSeconds;
  int?      _winnerId;

  /// Progress [0, ∞) — integer part = completed laps, fractional = position.
  final Map<int, double> _progress = {};

  Timer? _countdownTimer;
  Timer? _raceTimer;
  final Random _rng = Random();
  final Map<int, double> _momentum = {};    // đà hiện tại
  final Map<int, int>    _burstCooldown = {}; // cooldown burst

  // ── Getters ────────────────────────────────────────────────
  RaceState          get state      => _state;
  int                get countdown  => _countdown;
  int?               get winnerId   => _winnerId;
  List<CarModel>     get cars       => _cars;
  TrackModel         get track      => _track;

  /// Normalised position on track loop [0, 1) for [carId].
  double trackProgress(int carId) =>
      (_progress[carId] ?? 0) % 1.0;

  /// Completed laps (0-based) for [carId].
  int lapsCompleted(int carId) =>
      (_progress[carId] ?? 0).floor();

  /// Overall race progress [0, 1] for the HUD slider.
  double overallProgress(int carId) =>
      ((_progress[carId] ?? 0) / totalLaps).clamp(0.0, 1.0);

  // ── Lifecycle ──────────────────────────────────────────────

  void init(List<CarModel> cars, TrackModel track) {
    _cars  = cars;
    _track = track;
    for (final c in cars) {
      _progress[c.id] = 0.0;
      _momentum[c.id]      = 1.0;
      _burstCooldown[c.id] = 0;
    }
    _state = RaceState.ready;
    notifyListeners();
  }

  void startRace() {
    if (_state != RaceState.ready) return;
    _state    = RaceState.countdown;
    _countdown = countdownSeconds;
    notifyListeners();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _countdown--;
      if (_countdown <= 0) {
        t.cancel();
        _beginRacing();
      }
      notifyListeners();
    });
  }

  void _beginRacing() {
    _state = RaceState.racing;
    notifyListeners();

    _raceTimer = Timer.periodic(_tickInterval, (_) => _tick());
  }

  void _tick() {
    final maxProgress = _progress.values.reduce(max);

    for (final car in _cars) {
      final myProgress = _progress[car.id]     ?? 0;
      double momentum  = _momentum[car.id]     ?? 1.0;
      int    cooldown  = _burstCooldown[car.id] ?? 0;

      // ── 1. Burst ngẫu nhiên (tăng tốc đột ngột) ──────────
      if (cooldown <= 0 && _rng.nextDouble() < 0.008) {
        momentum = 2.2; // burst mạnh
        _burstCooldown[car.id] = 120; // ~2 giây cooldown
      } else {
        _burstCooldown[car.id] = max(0, cooldown - 1);
      }

      // ── 2. Fatigue (xe nhanh dễ mệt hơn) ─────────────────
      // xe có speed cao → xác suất bị fatigue cao hơn
      final fatigueChance = car.speed * 0.004;
      if (_rng.nextDouble() < fatigueChance) {
        momentum = 0.3; // chậm đột ngột
      }

      // ── 3. Rubber band ────────────────────────────────────
      final gap = maxProgress - myProgress;
      double rubberBand = 1.0;
      if (gap > 0.05) {
        rubberBand = 1.0 + (gap * 1.2).clamp(0.0, 0.5);
      } else if (gap < 0.01 && myProgress >= maxProgress) {
        rubberBand = 0.8;
      }

      // ── 4. Momentum smoothing (không đổi tốc độ quá gấp) ─
      final prevMomentum = _momentum[car.id] ?? 1.0;
      momentum = prevMomentum * 0.85 + momentum * 0.15;
      _momentum[car.id] = momentum;

      // ── 5. Tính progress ──────────────────────────────────
      final noise = 0.7 + _rng.nextDouble() * 0.6; // 0.7 ~ 1.3
      _progress[car.id] = myProgress +
          _baseSpeed * car.speed * noise * momentum * rubberBand;

      if ((_progress[car.id]! >= totalLaps) && _winnerId == null) {
        _winnerId = car.id;
        _raceTimer?.cancel();
        _state = RaceState.finished;
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  void reset() {
    _countdownTimer?.cancel();
    _raceTimer?.cancel();
    _state    = RaceState.ready;
    _countdown = countdownSeconds;
    _winnerId  = null;
    for (final id in _progress.keys) {
      _progress[id] = 0.0;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _raceTimer?.cancel();
    super.dispose();
  }
}