import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/car_model.dart';
import '../models/track_model.dart';
import '../../core/constants/app_assets.dart';

/// Loads static game data (cars, tracks) from bundled JSON assets.
class GameRepository {
  // ── Cars ──────────────────────────────────────────────────

  Future<List<CarModel>> loadCars() async {
    final raw  = await rootBundle.loadString(AppAssets.dataCars);
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => CarModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Tracks ────────────────────────────────────────────────

  Future<List<TrackModel>> loadTracks() async {
    final raw  = await rootBundle.loadString(AppAssets.dataTracks);
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => TrackModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}