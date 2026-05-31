import 'package:flutter/material.dart';

import '../../../core/enums/race_state.dart';
import '../../../data/models/car_model.dart';

class RaceHud extends StatelessWidget {
  final List<CarModel> cars;
  final List<double> progress; // overallProgress per car, same order as [cars]
  final RaceState state;
  final int? winnerId;         // index into [cars], not carId
  final VoidCallback onStart;
  final VoidCallback onResults;

  const RaceHud({
    super.key,
    required this.cars,
    required this.progress,
    required this.state,
    required this.winnerId,
    required this.onStart,
    required this.onResults,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xD1000080),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFFF00), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RACE PROGRESS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < cars.length; i++) ...[
              _ProgressRow(
                name: cars[i].name,
                color:
                    cars[i].color,
                value: progress.length > i
                    ? progress[i].clamp(0.0, 1.0)
                    : 0.0,
                isWinner: winnerId == i,
              ),
              if (i < cars.length - 1) const SizedBox(height: 7),
            ],
            const SizedBox(height: 10),
            _buildButton(),
          ],
        ),
      );
  }

  Widget _buildButton() {
    switch (state) {
      case RaceState.idle:
      case RaceState.ready:
        return _ActionButton(
          onTap: onStart,
          backgroundColor: const Color(0xFFC33332),
          label: 'START RACE',
          icon: Icons.play_arrow_rounded,
        );

      case RaceState.countdown:
      case RaceState.racing:
        return Container(
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                state == RaceState.countdown ? 'GET READY…' : 'RACING…',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        );

      case RaceState.finished:
        return _ActionButton(
          onTap: onResults,
          backgroundColor: const Color(0xFFC33332),
          label: 'VIEW RESULTS',
          icon: Icons.arrow_forward_rounded,
          iconLeading: false,
        );
    }
  }
}

// ── Action button with press animation ──────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final bool iconLeading;

  const _ActionButton({
    required this.onTap,
    required this.backgroundColor,
    required this.label,
    required this.icon,
    this.iconLeading = true,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFFF00), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconLeading) ...[
                Icon(widget.icon, color: Colors.white, size: 14),
                const SizedBox(width: 5),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              if (!widget.iconLeading) ...[
                const SizedBox(width: 5),
                Icon(widget.icon, color: Colors.white, size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Progress row ─────────────────────────────────────────────────────────────

class _ProgressRow extends StatelessWidget {
  final String name;
  final Color color;
  final double value; // 0..1
  final bool isWinner;

  const _ProgressRow({
    required this.name,
    required this.color,
    required this.value,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).round();
    final done = value >= 1.0;
    final barColor = done ? const Color(0xFFFFD700) : color;
    final thumbBorder =
    done ? const Color(0xFFFFD700) : const Color(0xFF000080);

    return Row(
      children: [
        SizedBox(
          width: 36,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: SizedBox(
            height: 8,
            child: LayoutBuilder(builder: (context, constraints) {
              final trackW = constraints.maxWidth;
              final thumbX = (value * trackW).clamp(0.0, trackW);
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF555555),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    height: 8,
                    width: thumbX,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Positioned(
                    left: thumbX - 9,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: thumbBorder, width: 1.5),
                      ),
                      child: Center(
                        child: done && isWinner
                            ? Icon(Icons.workspace_premium_rounded,
                            size: 10, color: const Color(0xFFFFD700))
                            : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: barColor, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.flag, color: Color(0xFFFFFF00), size: 12),
        const SizedBox(width: 2),
        SizedBox(
          width: 26,
          child: Text(
            '$pct%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}