import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'animated_slide_fade.dart';

/// "blinkit" + "MONEY" branding — exact copy from the reference recording.
class BrandText extends StatelessWidget {
  const BrandText({
    super.key,
    required this.brandAnimation,
    required this.moneyAnimation,
  });

  final Animation<double> brandAnimation;
  final Animation<double> moneyAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSlideFade(
          animation: brandAnimation,
          slideOffset: const Offset(0, 0.08),
          scaleFrom: 0.96,
          child: const Text(
            'blinkit',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              height: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSlideFade(
          animation: moneyAnimation,
          slideOffset: const Offset(0, 0.14),
          scaleFrom: 0.88,
          child: const Text(
            'MONEY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 44,
              fontWeight: FontWeight.w900,
              letterSpacing: 7,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
