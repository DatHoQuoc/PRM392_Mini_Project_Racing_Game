import 'package:flutter/material.dart';

import '../track_select/track_select_screen.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  static const double walletBalance = 100.0;

  void _showVolumePanel(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return Container(
          height: 200,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Volume',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Adjust game audio volume'),
              const SizedBox(height: 16),
              Slider(value: 0.6, onChanged: (_) {}),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'HOME',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => _showVolumePanel(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: const [
                    Icon(Icons.account_balance_wallet, color: Color(0xFF000080), size: 32),
                    SizedBox(width: 16),
                    Text(
                      '\$100.00',
                      style: TextStyle(
                        color: Color(0xFF000080),
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(TrackSelectScreen.route);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC33332),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                    ),
                    child: const Text(
                      'CHOOSE TRACK',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
