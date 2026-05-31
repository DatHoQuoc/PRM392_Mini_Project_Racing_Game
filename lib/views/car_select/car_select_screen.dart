import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/car_model.dart';
import '../../data/repositories/game_repository.dart';

import 'widgets/car_select_app_bar.dart';
import 'widgets/car_list_column.dart';
import 'widgets/car_info_column.dart';
import 'widgets/betting_column.dart';

class CarSelectScreen extends StatefulWidget {
  static const route = '/car-select';

  const CarSelectScreen({super.key});
  @override
  State<CarSelectScreen> createState() => _CarSelectScreenState();
}

class _CarSelectScreenState extends State<CarSelectScreen> {
  final _repo = GameRepository();
  late Future<List<CarModel>> _carsFuture;

  int _selectedIndex = 0;
  double _betAmount = 0;
  int? _selectedPresetPct;
  final double _walletBalance = 100.0;

  bool get _canPlay => _betAmount > 0 && _betAmount <= _walletBalance;

  @override
  void initState() {
    super.initState();
    _carsFuture = _repo.loadCars();
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
                              ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Racing ${selectedCar.name} · '
                                      '\$${_betAmount.toStringAsFixed(0)}',
                                ),
                                backgroundColor: AppColors.primaryRed,
                              ),
                            );
                          }
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