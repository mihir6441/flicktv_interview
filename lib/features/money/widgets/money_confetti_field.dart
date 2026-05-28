import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// One-shot celebration: left & right center → **top of screen**, then fall
/// within ~2s (parent controls timing).
class MoneyConfettiField extends StatelessWidget {
  const MoneyConfettiField({
    super.key,
    required this.controllers,
    required this.canvasSize,
  });

  final List<ConfettiController> controllers;
  final Size canvasSize;

  static const _colors = <Color>[
    Color(0xFF00E5FF),
    Color(0xFFFF4081),
    Color(0xFFFFEB3B),
    Color(0xFF76FF03),
    Color(0xFFE040FB),
    Color(0xFFFFA726),
  ];

  /// Inward + more vertical lift so bursts reach the top.
  static const double _blastFromLeft = -math.pi / 2 + 0.42;
  static const double _blastFromRight = -math.pi / 2 - 0.42;

  @override
  Widget build(BuildContext context) {
    if (controllers.length < 2) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: ShaderMask(
        // Keep particles fully visible in the upper area, then fade them out
        // around mid-screen while they fall down.
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.44, 0.62],
          colors: [Colors.white, Colors.white, Colors.transparent],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _emitter(
                controller: controllers[0],
                blastDirection: _blastFromLeft,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _emitter(
                controller: controllers[1],
                blastDirection: _blastFromRight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emitter({
    required ConfettiController controller,
    required double blastDirection,
  }) {
    return ConfettiWidget(
      confettiController: controller,
      canvas: canvasSize,
      blastDirectionality: BlastDirectionality.directional,
      blastDirection: blastDirection,
      emissionFrequency: 1,
      numberOfParticles: 18,
      minBlastForce: 130,
      maxBlastForce: 210,
      gravity: 0.4,
      particleDrag: 0.09,
      shouldLoop: false,
      displayTarget: false,
      pauseEmissionOnLowFrameRate: false,
      colors: _colors,
      minimumSize: const Size(4, 6),
      maximumSize: const Size(9, 14),
    );
  }
}
