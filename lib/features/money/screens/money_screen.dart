import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../animation/money_intro_animation.dart';
import '../models/feature_item.dart';
import '../widgets/animated_slide_fade.dart';
import '../widgets/brand_text.dart';
import '../widgets/circular_icon_button.dart';
import '../widgets/dotted_header_background.dart';
import '../widgets/feature_card.dart';
import '../widgets/money_confetti_field.dart';
import '../widgets/wallet_illustration.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen>
    with TickerProviderStateMixin {
  static const int _confettiEmitterCount = 2;
  static const _confettiBurstDuration = Duration(seconds: 2);

  late final MoneyIntroAnimation _intro;
  late final List<ConfettiController> _confettiControllers;

  bool _confettiFired = false;

  @override
  void initState() {
    super.initState();
    _intro = MoneyIntroAnimation(vsync: this);
    _confettiControllers = List.generate(
      _confettiEmitterCount,
      (_) => ConfettiController(duration: _confettiBurstDuration),
    );
    _intro.controller.addListener(_syncConfettiToIntro);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cold starts can jank the first frame; begin intro after a tiny buffer
      // so confetti is emitted only once the scene is laid out.
      Future.delayed(const Duration(milliseconds: 120), () {
        if (!mounted) return;
        _intro.play();
      });
    });
  }

  /// Single burst when wallet appears; arc up to top then down within 2s.
  void _syncConfettiToIntro() {
    // Trigger slightly later in the intro to avoid missing the burst
    // during app cold-start frame stabilization.
    if (_confettiFired || _intro.controller.value < 0.08) return;

    _confettiFired = true;
    for (final c in _confettiControllers) {
      c.play();
    }

    // Stop spawning immediately — one throw only.
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      for (final c in _confettiControllers) {
        c.stop(clearAllParticles: false);
      }
    });

    // Clear everything after 2 seconds (full up + down cycle).
    Future.delayed(_confettiBurstDuration, () {
      if (!mounted) return;
      for (final c in _confettiControllers) {
        c.stop(clearAllParticles: true);
      }
    });
  }

  @override
  void dispose() {
    _intro.controller.removeListener(_syncConfettiToIntro);
    for (final c in _confettiControllers) {
      c.dispose();
    }
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: _intro.controller,
          builder: (context, _) {
            return Stack(
              children: [
                const DottedHeaderBackground(),
                // Confetti behind wallet / text — arcs up to top-center then falls.
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return MoneyConfettiField(
                        controllers: _confettiControllers,
                        canvasSize: Size(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      _TopBar(
                        settingsOpacity: _intro.settings.value,
                        onBack: widget.onBack,
                      ),
                      Expanded(child: _BodyStack(intro: _intro)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.settingsOpacity, required this.onBack});

  final double settingsOpacity;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: onBack,
          ),
          Opacity(
            opacity: settingsOpacity,
            child: IgnorePointer(
              ignoring: settingsOpacity < 0.5,
              child: CircularIconButton(
                icon: Icons.settings_outlined,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Body layout: the hero (wallet + brand) starts at vertical centre, then
/// glides up to make room for the cards/buttons which slide in from below.
class _BodyStack extends StatelessWidget {
  const _BodyStack({required this.intro});

  final MoneyIntroAnimation intro;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        // Approximate hero height (wallet + spacing + blinkit + MONEY).
        const heroHeight = 220.0;

        // Centered hero Y position (top-left aligned).
        final centeredTop = (height - heroHeight) / 2;
        // Final settled position near the top.
        const settledTop = 0.0;

        final t = intro.heroLift.value;
        final heroTop = centeredTop + (settledTop - centeredTop) * t;

        // Cards container slides up from the bottom edge.
        final cardsT = intro.card0.value;
        final cardsOffset = (1 - cardsT) * 0.35 * height;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Cards / buttons / footer — painted behind the hero so the hero
            // floats above as it settles.
            Positioned(
              left: 0,
              right: 0,
              top: heroHeight + 12,
              bottom: 0,
              child: Transform.translate(
                offset: Offset(0, cardsOffset),
                child: Opacity(
                  opacity: cardsT.clamp(0.0, 1.0),
                  child: _ContentColumn(intro: intro),
                ),
              ),
            ),

            // Hero block — animates from screen-center to settled top.
            Positioned(
              left: 0,
              right: 0,
              top: heroTop,
              height: heroHeight,
              child: _HeroBlock(intro: intro),
            ),
          ],
        );
      },
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.intro});

  final MoneyIntroAnimation intro;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _WalletWithEntrance(animation: intro.walletAppear),
        const SizedBox(height: 18),
        BrandText(
          brandAnimation: intro.brandFade,
          moneyAnimation: intro.moneyFade,
        ),
      ],
    );
  }
}

class _WalletWithEntrance extends StatelessWidget {
  const _WalletWithEntrance({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value.clamp(0.0, 1.0);
        if (t <= 0) {
          return const SizedBox(width: 152, height: 128);
        }
        return Opacity(
          opacity: t,
          // Slight pop: starts a bit larger so it "lands" gently.
          child: Transform.scale(scale: 1.15 - (0.15 * t), child: child),
        );
      },
      child: const WalletIllustration(),
    );
  }
}

class _ContentColumn extends StatelessWidget {
  const _ContentColumn({required this.intro});

  final MoneyIntroAnimation intro;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < kFeatureItems.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnimatedSlideFade(
                animation: intro.cardAnimations[i],
                slideOffset: const Offset(0, 0.18),
                child: FeatureCard(item: kFeatureItems[i]),
              ),
            ),
          const SizedBox(height: 4),
          AnimatedSlideFade(
            animation: intro.addMoney,
            slideOffset: const Offset(0, 0.18),
            child: const _AddMoneyButton(),
          ),
          const SizedBox(height: 10),
          AnimatedSlideFade(
            animation: intro.giftCard,
            slideOffset: const Offset(0, 0.18),
            child: const _ClaimGiftCardTile(),
          ),
          const SizedBox(height: 14),
          AnimatedSlideFade(
            animation: intro.footerText,
            slideOffset: const Offset(0, 0.10),
            child: const _FooterWatermark(),
          ),
        ],
      ),
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Add Money',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _ClaimGiftCardTile extends StatelessWidget {
  const _ClaimGiftCardTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.walletGold,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Claim Gift Card',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enter gift card details to claim your gift card',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _FooterWatermark extends StatelessWidget {
  const _FooterWatermark();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Enjoy seamless\none tap payments',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.30),
        fontSize: 30,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.5,
      ),
    );
  }
}
