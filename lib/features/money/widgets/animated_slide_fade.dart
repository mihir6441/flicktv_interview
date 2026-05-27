import 'package:flutter/material.dart';

class AnimatedSlideFade extends StatelessWidget {
  const AnimatedSlideFade({
    super.key,
    required this.animation,
    required this.child,
    this.slideOffset = const Offset(0, 0.18),
    this.scaleFrom = 0.92,
  });

  final Animation<double> animation;
  final Widget child;
  final Offset slideOffset;
  final double scaleFrom;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        if (t <= 0) {
          return const SizedBox.shrink();
        }
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(
              slideOffset.dx * (1 - t) * 36,
              slideOffset.dy * (1 - t) * 36,
            ),
            child: Transform.scale(
              scale: scaleFrom + ((1 - scaleFrom) * t),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
