import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/car_model.dart';
import '../../data/models/track_model.dart';
import '../../data/repositories/game_repository.dart';

import 'widgets/car_select_app_bar.dart';
import 'widgets/car_list_column.dart';
import 'widgets/car_info_column.dart';
import 'widgets/betting_column.dart';
import '../race/race_screen.dart';

class CarSelectScreen extends StatefulWidget {
  static const route = '/car-select';

  const CarSelectScreen({super.key});
  @override
  State<CarSelectScreen> createState() => _CarSelectScreenState();
}

class _CarSelectScreenState extends State<CarSelectScreen> {
  final _repo = GameRepository();
  late Future<List<CarModel>> _carsFuture;

  // Nhận track + wallet từ TrackSelectScreen qua arguments
  late final TrackModel _track;
  late final double _walletBalance;

  int _selectedIndex = 0;
  double _betAmount = 0;
  int? _selectedPresetPct;

  bool get _canPlay => _betAmount > 0 && _betAmount <= _walletBalance;

  @override
  void initState() {
    super.initState();
    _carsFuture = _repo.loadCars();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lấy arguments được truyền từ màn trước
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _track = args['track'] as TrackModel;
    _walletBalance = (args['wallet'] as num).toDouble();
  }

  void _onSliderChanged(double v) {
    setState(() {
      _betAmount = v;
      final pct = (_walletBalance > 0 ? v / _walletBalance * 100 : 0).round();
      const presets = [25, 50, 75, 100];
      _selectedPresetPct = presets.contains(pct) ? pct : null;
    });
  }

  void _onPresetSelected(int pct) {
    setState(() {
      _selectedPresetPct = pct;
      _betAmount = (_walletBalance * pct / 100).roundToDouble();
    });
  }

  void _navigateToRace(List<CarModel> allCars, CarModel selectedCar) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final orderedCars = [
      selectedCar,
      ...allCars.where((c) => c.id != selectedCar.id),
    ];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RaceScreen(
          cars: orderedCars,
          track: _track,
          wallet: _walletBalance,
          betAmount: _betAmount,
          selectedCarId: selectedCar.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skyBlue,
      body: Column(
        children: [
          CarSelectAppBar(walletBalance: _walletBalance),
          Expanded(
            child: FutureBuilder<List<CarModel>>(
              future: _carsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.navy),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load cars:\n${snapshot.error}',
                      style: const TextStyle(color: AppColors.navy),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final cars = snapshot.data!;
                final safeIndex = _selectedIndex.clamp(0, cars.length - 1);
                final selectedCar = cars[safeIndex];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // LEFT — car list
                      SizedBox(
                        width: 128,
                        child: CarListColumn(
                          cars: cars,
                          selectedIndex: safeIndex,
                          onSelect: (i) => setState(() => _selectedIndex = i),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // CENTER — car stats & description
                      Expanded(
                        flex: 38,
                        child: CarInfoColumn(car: selectedCar),
                      ),
                      const SizedBox(width: 8),
                      // RIGHT — betting
                      Expanded(
                        flex: 42,
                        child: BettingColumn(
                          betAmount: _betAmount,
                          maxBet: _walletBalance,
                          selectedPresetPct: _selectedPresetPct,
                          canPlay: _canPlay,
                          onBetChanged: _onSliderChanged,
                          onPresetSelected: _onPresetSelected,
                          onPlay: _canPlay
                              ? () => _navigateToRace(cars, selectedCar)
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}