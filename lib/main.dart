import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/screen2/screen2_screen.dart'; 
import 'package:provider/provider.dart';
import 'data/repositories/game_repository.dart';
import 'data/models/car_model.dart';
import 'data/models/track_model.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/track_viewmodel.dart';
import 'views/login/login_screen.dart';
import 'views/track_select/track_select_screen.dart';
import 'views/race/race_screen.dart';
import 'views/car_select/car_select_screen.dart';
import 'views/result_screen/result_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Game is designed for landscape (812×375) — lock it.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MiniRacingGameApp());
}

class MiniRacingGameApp extends StatelessWidget {
  const MiniRacingGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    // App-root ViewModels (MVVM state management via provider).
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TrackViewModel()),
      ],
      child: MaterialApp(
        title: 'Race!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF000080)),
        ),
        // Login is the entry point; on success it routes to the game loader.
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          LoginScreen.nextRoute: (_) => const Screen2Screen(), 
          TrackSelectScreen.route: (_) => const TrackSelectScreen(),
          CarSelectScreen.route: (_) => const CarSelectScreen(),
          ResultScreen.route: (_) => const ResultScreen(),
        },
      ),
    );
  }
} 

class GameLoader extends StatefulWidget {
  const GameLoader({super.key});

  @override
  State<GameLoader> createState() => _GameLoaderState();
}

class _GameLoaderState extends State<GameLoader> {
  final _repo = GameRepository();

  late Future<(List<CarModel>, List<TrackModel>)> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([_repo.loadCars(), _repo.loadTracks()]).then(
      (results) =>
          (results[0] as List<CarModel>, results[1] as List<TrackModel>),
    );
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
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        // ── Error ────────────────────────────────────────────
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Failed to load data:\n${snapshot.error}'),
            ),
          );
        }

        // ── Ready ────────────────────────────────────────────
        final (cars, tracks) = snapshot.data!;

        return RaceScreen(
          cars:   cars,
          track:  tracks.last,   // default to first track
          wallet: 100.00,
          betAmount: 0.0,
          selectedCarId: cars.first.id,
        );
      },
    );
  }
}