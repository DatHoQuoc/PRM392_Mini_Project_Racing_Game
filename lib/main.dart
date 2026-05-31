import 'package:flutter/material.dart';

import 'data/repositories/game_repository.dart';
import 'data/models/car_model.dart';
import 'data/models/track_model.dart';
import 'views/race/race_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Race!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF000080)),
      ),
      home: const _GameLoader(),
    );
  }
}

class _GameLoader extends StatefulWidget {
  const _GameLoader();

  @override
  State<_GameLoader> createState() => _GameLoaderState();
}

class _GameLoaderState extends State<_GameLoader> {
  final _repo = GameRepository();

  late Future<(List<CarModel>, List<TrackModel>)> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      _repo.loadCars(),
      _repo.loadTracks(),
    ]).then((results) => (
    results[0] as List<CarModel>,
    results[1] as List<TrackModel>,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(List<CarModel>, List<TrackModel>)>(
      future: _future,
      builder: (context, snapshot) {
        // ── Loading ──────────────────────────────────────────
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF000080),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        // ── Error ────────────────────────────────────────────
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Failed to load data:\n${snapshot.error}')),
          );
        }

        // ── Ready ────────────────────────────────────────────
        final (cars, tracks) = snapshot.data!;

        return RaceScreen(
          cars:   cars,
          track:  tracks.last,   // default to first track
          wallet: 100.00,
        );
      },
    );
  }
}