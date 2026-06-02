import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/track_model.dart';
import '../car_select/car_select_screen.dart';

import 'widgets/result_header.dart';
import 'widgets/winner_card.dart';
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

    final bool won = winnerId == selectedCarId;

    final double reward = won ? betAmount * 2 : 0;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ResultHeader(),

                  const SizedBox(height: 24),

                  WinnerCard(
                    winnerId: winnerId,
                  ),

                  const SizedBox(height: 20),

                  RewardCard(
                    won: won,
                    reward: reward,
                  ),

                  const SizedBox(height: 32),

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