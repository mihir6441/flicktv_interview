import 'package:flutter/animation.dart';

/// Phases observed in the reference recording (total: ~8.5s):
///   0.0–0.3s  Dark screen — only back button visible.
///   0.3–0.6s  Wallet pops in at the vertical center of the screen.
///   0.4–5.5s  Confetti rains down from the top of the screen.
///   2.7–3.2s  "blinkit" fades in just below the wallet.
///   3.2–3.7s  "MONEY" slides up below "blinkit".
///   4.3–5.0s  Hero block (wallet + text) glides up toward the top.
///   5.0–5.9s  Three feature cards stagger up from below.
///   6.2–6.8s  Settings gear fades in (top-right).
///   6.5–7.1s  "Add Money" button rises in.
///   6.9–7.5s  "Claim Gift Card" tile rises in.
///   7.2–8.0s  Footer watermark fades in.
class MoneyIntroAnimation {
  MoneyIntroAnimation({required TickerProvider vsync})
    : controller = AnimationController(vsync: vsync, duration: totalDuration);

  static const totalDuration = Duration(milliseconds: 8500);

  final AnimationController controller;

  // Pre-built curves — created lazily to avoid per-frame allocations.
  late final Animation<double> walletAppear = _interval(0.035, 0.085,
      curve: Curves.easeOutBack);

  /// Confetti falls continuously through this window.
  late final Animation<double> confetti = _interval(0.04, 0.66,
      curve: Curves.linear);

  late final Animation<double> brandFade = _interval(0.31, 0.38,
      curve: Curves.easeOutCubic);

  late final Animation<double> moneyFade = _interval(0.37, 0.45,
      curve: Curves.easeOutCubic);

  /// 0 = hero is centered vertically; 1 = hero settled near the top.
  late final Animation<double> heroLift = _interval(0.50, 0.60,
      curve: Curves.easeInOutCubic);

  late final Animation<double> card0 = _interval(0.58, 0.66,
      curve: Curves.easeOutCubic);
  late final Animation<double> card1 = _interval(0.62, 0.70,
      curve: Curves.easeOutCubic);
  late final Animation<double> card2 = _interval(0.66, 0.74,
      curve: Curves.easeOutCubic);

  late final Animation<double> settings = _interval(0.72, 0.80,
      curve: Curves.easeOut);

  late final Animation<double> addMoney = _interval(0.76, 0.84,
      curve: Curves.easeOutCubic);

  late final Animation<double> giftCard = _interval(0.81, 0.88,
      curve: Curves.easeOutCubic);

  late final Animation<double> footerText = _interval(0.84, 0.94,
      curve: Curves.easeOut);

  List<Animation<double>> get cardAnimations => [card0, card1, card2];

  Animation<double> _interval(double begin, double end, {required Curve curve}) {
    return CurvedAnimation(
      parent: controller,
      curve: Interval(begin, end, curve: curve),
    );
  }

  void play() => controller.forward(from: 0);

  void dispose() => controller.dispose();
}
