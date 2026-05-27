import 'package:flutter/material.dart';

/// 3D bifold wallet with **bright gold front**, **olive-green interior / depth**,
/// and a clean white **₹** — aligned with the reference splash art.
class WalletIllustration extends StatelessWidget {
  const WalletIllustration({super.key, this.size = const Size(152, 128)});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.20,
      child: CustomPaint(size: size, painter: _WalletPainter()),
    );
  }
}

class _WalletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ----- Soft ground shadow -----
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.42)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.62, w * 0.84, h * 0.28),
        const Radius.circular(22),
      ),
      shadowPaint,
    );

    // ----- Back / thickness panel (olive — visible left & behind) -----
    final backRect = Rect.fromLTWH(w * 0.04, h * 0.26, w * 0.52, h * 0.62);
    final backRr = RRect.fromRectAndRadius(backRect, const Radius.circular(18));
    final backPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4A5F24),
          Color(0xFF2D3A16),
          Color(0xFF1E2610),
        ],
      ).createShader(backRect);
    canvas.drawRRect(backRr, backPaint);

    // ----- Main front face: gold with green shading (top-left) for 3D -----
    final bodyRect = Rect.fromLTWH(w * 0.10, h * 0.32, w * 0.82, h * 0.58);
    final body = RRect.fromRectAndRadius(bodyRect, const Radius.circular(20));
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 0.35, 0.72, 1.0],
        colors: [
          Color(0xFF6A7A30), // green wash (depth)
          Color(0xFFFFE566), // bright lemon gold
          Color(0xFFFFD02E), // rich gold
          Color(0xFFD4A018), // deeper gold corner
        ],
      ).createShader(bodyRect);
    canvas.drawRRect(body, bodyPaint);

    // Right-edge thickness shadow (wallet depth).
    final edgeRect = Rect.fromLTWH(w * 0.74, h * 0.34, w * 0.20, h * 0.54);
    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFB8860B).withValues(alpha: 0),
          const Color(0xFF5C4810).withValues(alpha: 0.45),
        ],
      ).createShader(edgeRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(edgeRect, const Radius.circular(18)),
      edgePaint,
    );

    // ----- Inner pocket / fold (dark forest green, top of wallet) -----
    final pocketRect = Rect.fromLTWH(w * 0.14, h * 0.10, w * 0.72, h * 0.34);
    final pocket = RRect.fromRectAndRadius(pocketRect, const Radius.circular(14));
    final pocketPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3D4F1F),
          Color(0xFF253214),
          Color(0xFF1A2410),
        ],
      ).createShader(pocketRect);
    canvas.drawRRect(pocket, pocketPaint);

    // Pocket opening shadow (separates flap from body).
    final seamPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.38, w * 0.78, h * 0.06),
        const Radius.circular(8),
      ),
      seamPaint,
    );

    // ----- Specular highlight (soft plastic / puffy look) -----
    final hiRect = Rect.fromLTWH(w * 0.16, h * 0.38, w * 0.42, h * 0.22);
    final hiPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.28),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(hiRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(hiRect, const Radius.circular(14)),
      hiPaint,
    );

    // Bottom rim light.
    final rimRect = Rect.fromLTWH(w * 0.14, h * 0.78, w * 0.74, h * 0.10);
    final rimPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFFFF8DC).withValues(alpha: 0),
          const Color(0xFFFFF8DC).withValues(alpha: 0.22),
        ],
      ).createShader(rimRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rimRect, const Radius.circular(12)),
      rimPaint,
    );

    // ----- ₹ symbol (clean white, slight emboss) -----
    final rupee = TextPainter(
      text: TextSpan(
        text: '₹',
        style: TextStyle(
          color: Colors.white,
          fontSize: h * 0.48,
          fontWeight: FontWeight.w800,
          height: 1,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 5,
              offset: const Offset(0, 1.5),
            ),
            Shadow(
              color: Colors.white.withValues(alpha: 0.15),
              blurRadius: 0,
              offset: const Offset(0, -0.8),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    rupee.paint(
      canvas,
      Offset((w - rupee.width) / 2, h * 0.44),
    );

    // Thin stroke for crisp silhouette.
    final outline = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(body, outline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
