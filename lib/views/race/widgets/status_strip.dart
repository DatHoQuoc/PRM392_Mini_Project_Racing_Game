import 'package:flutter/material.dart';

import '../../../core/enums/race_state.dart';

class StatusStrip extends StatefulWidget {
  final RaceState state;
  final int countdown;

  const StatusStrip({super.key, required this.state, required this.countdown});

  @override
  State<StatusStrip> createState() => _StatusStripState();
}

class _StatusStripState extends State<StatusStrip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink;

  @override
  void initState() {
    super.initState();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      color: const Color(0xFF000080),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(children: [_buildIcon(), const SizedBox(width: 6), _buildLabel()]),
    );
  }

  Widget _buildIcon() {
    switch (widget.state) {
      case RaceState.idle:
      case RaceState.ready:
        return Icon(Icons.volume_off_rounded,
            size: 14, color: Colors.white.withOpacity(0.8));
      case RaceState.countdown:
        return const Icon(Icons.notifications_active_rounded,
            size: 14, color: Color(0xFFFFFF00));
      case RaceState.racing:
        return Icon(Icons.volume_up_rounded,
            size: 14, color: Colors.white.withOpacity(0.9));
      case RaceState.finished:
        return const Icon(Icons.emoji_events_rounded,
            size: 14, color: Color(0xFFFFFF00));
    }
  }

  Widget _buildLabel() {
    switch (widget.state) {
      case RaceState.idle:
      case RaceState.ready:
        return FadeTransition(
          opacity: _blink,
          child: const Text('READY…',
              style: TextStyle(
                color: Color(0xFFFFFF00),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              )),
        );

      case RaceState.countdown:
        return Text(
          widget.countdown > 0 ? '${widget.countdown}…' : 'GO!',
          style: const TextStyle(
            color: Color(0xFFFFFF00),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        );

      case RaceState.racing:
        return Row(children: [
          _PulsingDot(),
          const SizedBox(width: 6),
          const Text('RACING…',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              )),
        ]);

      case RaceState.finished:
        return const Text('WINNER FOUND!',
            style: TextStyle(
              color: Color(0xFFFFFF00),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ));
    }
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.7, end: 1.3)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 8, height: 8,
        decoration: const BoxDecoration(
            color: Color(0xFFC33332), shape: BoxShape.circle),
      ),
    );
  }
}