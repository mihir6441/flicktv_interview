import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Full-screen background: strong **top-to-bottom** vertical gradient (warm
/// olive / bronze → deep black) plus a halftone dot band at the top.
class DottedHeaderBackground extends StatelessWidget {
  const DottedHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: CustomPaint(
        painter: _MoneyScreenBackgroundPainter(),
      ),
    );
  }
}

class _MoneyScreenBackgroundPainter extends CustomPainter {
  const _MoneyScreenBackgroundPainter();

  /// Halftone band (top fraction of screen).
  static const _dotBandFraction = 0.20;
  static const _dotSpacing = 7.0;
  static const _dotRadius = 1.15;
  static const _dotCore = Color(0xFFE8C76A);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // --- Primary vertical gradient: visible wash across full height ---
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [
          0.0,
          0.06,
          0.14,
          0.28,
          0.45,
          0.62,
          0.80,
          1.0,
        ],
        colors: [
          Color(0xFF343018), // warm olive-bronze (status bar area)
          Color(0xFF2A2614),
          Color(0xFF1F1C10),
          Color(0xFF15130C),
          Color(0xFF0E0C08),
          Color(0xFF080705),
          Color(0xFF030302),
          Color(0xFF000000), // deep black at bottom
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    // --- Subtle second pass: slightly warmer under the dot band only ---
    final warmBandH = size.height * 0.28;
    final warm = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: const [0.0, 0.55, 1.0],
        colors: [
          const Color(0xFF3D3518).withValues(alpha: 0.22),
          const Color(0xFF2A2410).withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, warmBandH));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, warmBandH), warm);

    // --- Halftone dots (top band) ---
    final bandH = size.height * _dotBandFraction;
    final dotPaint = Paint()..isAntiAlias = true;

    for (var y = 0.0; y < bandH; y += _dotSpacing) {
      final t = (y / bandH).clamp(0.0, 1.0);
      final rowOpacity = math.pow(1.0 - t, 1.65).toDouble();
      final row = (y / _dotSpacing).round();
      final xOffset = row.isOdd ? _dotSpacing * 0.5 : 0.0;

      for (var x = -_dotSpacing; x < size.width + _dotSpacing; x += _dotSpacing) {
        final cx = x + xOffset;
        final alpha = (rowOpacity * 0.58 * (1.0 - t * 0.35)).clamp(0.0, 1.0);
        if (alpha < 0.02) continue;
        dotPaint.color = _dotCore.withValues(alpha: alpha);
        canvas.drawCircle(Offset(cx, y), _dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
