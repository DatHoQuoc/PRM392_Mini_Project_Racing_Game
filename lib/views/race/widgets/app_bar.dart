import 'package:flutter/material.dart';

class RaceAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double wallet;
  final bool muted;
  final VoidCallback? onMuteToggle;
  final VoidCallback? onBack;

  const RaceAppBar({
    super.key,
    required this.wallet,
    this.muted = false,
    this.onMuteToggle,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: const Color(0xFF000080),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: onBack ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 18),
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Race!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Mute button — wired to real AudioManager via onMuteToggle
          GestureDetector(
            onTap: onMuteToggle,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                color: muted
                    ? Colors.white.withOpacity(0.4)
                    : const Color(0xFFFFFF00),
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Wallet badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFF00),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet_rounded,
                    color: Color(0xFF000080), size: 14),
                const SizedBox(width: 4),
                Text(
                  '\$${wallet.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF000080),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}