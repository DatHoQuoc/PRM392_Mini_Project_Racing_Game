import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/car_model.dart';
import '../../data/models/track_model.dart';
import '../car_select/car_select_screen.dart';

import 'widgets/result_header.dart';
import 'widgets/reward_card.dart';
import 'widgets/result_actions.dart';

class ResultScreen extends StatelessWidget {
  static const route = '/results';

  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final TrackModel track = args['track'];

    final int winnerId = args['winner'];

    final double wallet = (args['wallet'] as num).toDouble();

    final double betAmount = (args['betAmount'] as num).toDouble();

    final int selectedCarId = args['selectedCarId'];

    final List<CarModel> cars =
    ((args['cars'] as List?) ?? []).cast<CarModel>();

    final CarModel? winnerCar = cars.isNotEmpty
        ? cars.firstWhere(
          (c) => c.id == winnerId,
      orElse: () => cars.first,
    )
        : null;

    final bool won = winnerId == selectedCarId;

    final double reward = won ? betAmount * 2 : 0;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ResultHeader(),

                  const SizedBox(height: 20),

                  Text(
                    'WINNER',
                    style: TextStyle(
                      color: Colors.amber.shade300,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (winnerCar != null)
                    Image.asset(
                      winnerCar.assetPath,
                      width: 180,
                      height: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.directions_car,
                          size: 100,
                          color: Colors.white,
                        );
                      },
                    )
                  else
                    const Icon(
                      Icons.directions_car,
                      size: 100,
                      color: Colors.white,
                    ),

                  const SizedBox(height: 12),

                  Text(
                    winnerCar?.name ?? 'Unknown Car',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    color:
                    won ? Colors.green.shade700 : Colors.red.shade700,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            won ? 'YOU WON!' : 'YOU LOST!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            won
                                ? '+\$${reward.toStringAsFixed(2)}'
                                : '-\$${betAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  RewardCard(
                    won: won,
                    reward: reward,
                  ),

                  const SizedBox(height: 30),

                  ResultActions(
                    onHome: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/game',
                            (route) => false,
                      );
                    },
                    onReplay: () {
                      Navigator.of(context).pushReplacementNamed(
                        CarSelectScreen.route,
                        arguments: {
                          'track': track,
                          'wallet': wallet + reward,
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}