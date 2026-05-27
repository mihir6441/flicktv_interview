import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/feature_item.dart';

class FeatureIcon extends StatelessWidget {
  const FeatureIcon({super.key, required this.type});

  final FeatureIconType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(painter: _FeatureIconPainter(type)),
    );
  }
}

class _FeatureIconPainter extends CustomPainter {
  _FeatureIconPainter(this.type);

  final FeatureIconType type;

  @override
  void paint(Canvas canvas, Size size) {
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.55, size.height * 0.5),
        width: 22,
        height: 34,
      ),
      const Radius.circular(4),
    );
    final phonePaint = Paint()..color = AppColors.walletGold;
    canvas.drawRRect(phoneRect, phonePaint);

    final handPaint = Paint()..color = const Color(0xFFF5F0E6);
    final handPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.72)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.55,
        size.width * 0.42,
        size.height * 0.62,
      )
      ..lineTo(size.width * 0.48, size.height * 0.78)
      ..close();
    canvas.drawPath(handPath, handPaint);

    final accentFill = Paint()..color = Colors.white.withValues(alpha: 0.9);
    final accentStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    switch (type) {
      case FeatureIconType.tap:
        canvas.drawCircle(
          Offset(size.width * 0.55, size.height * 0.42),
          3,
          accentFill,
        );
      case FeatureIconType.nfc:
        for (var i = 0; i < 3; i++) {
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(size.width * 0.55, size.height * 0.38),
              width: 8 + i * 5.0,
              height: 8 + i * 5.0,
            ),
            -2.4,
            1.6,
            false,
            accentStroke,
          );
        }
      case FeatureIconType.refund:
        canvas.drawCircle(
          Offset(size.width * 0.55, size.height * 0.4),
          7,
          accentStroke,
        );
        canvas.drawLine(
          Offset(size.width * 0.55, size.height * 0.33),
          Offset(size.width * 0.55, size.height * 0.47),
          accentStroke,
        );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
