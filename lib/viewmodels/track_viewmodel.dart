import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/models/track_option_model.dart';
import '../data/repositories/game_repository.dart';

/// Track Selection state.
///
/// Loads the selectable tracks from the repository and tracks which one is
/// currently selected (by tap or random pick). The View just renders [tracks]
/// and reflects [selectedIndex].
class TrackViewModel extends ChangeNotifier {
  TrackViewModel({GameRepository? repository})
      : _repository = repository ?? GameRepository();

  final GameRepository _repository;
  final Random _rng = Random();

  List<TrackOption> _tracks = const [];
  int?  _selectedIndex;
  bool  _loading = false;

  List<TrackOption> get tracks        => _tracks;
  int?              get selectedIndex => _selectedIndex;
  bool              get isLoading     => _loading;
  bool              get hasSelection  => _selectedIndex != null;

  /// The currently selected track, or null if none.
  TrackOption? get selectedTrack =>
      _selectedIndex == null ? null : _tracks[_selectedIndex!];

  /// Load tracks once (no-op if already loaded or in flight).
  Future<void> loadTracks() async {
    if (_tracks.isNotEmpty || _loading) return;
    _loading = true;
    notifyListeners();
    _tracks  = await _repository.loadTrackOptions();
    _loading = false;
    notifyListeners();
  }

  void selectTrack(int index) {
    if (index < 0 || index >= _tracks.length) return;
    _selectedIndex = index;
    notifyListeners();
  }

  /// Pick a random track and select it.
  void pickRandom() {
    if (_tracks.isEmpty) return;
    _selectedIndex = _rng.nextInt(_tracks.length);
    notifyListeners();
  }
}
