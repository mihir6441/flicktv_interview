import 'package:flutter/material.dart';

import '../models/feature_item.dart';

class FeatureIcon extends StatelessWidget {
  const FeatureIcon({super.key, required this.type});

  final FeatureIconType type;

  String get _assetPath {
    switch (type) {
      case FeatureIconType.tap:
        return 'assets/icons/feature_tap.png';
      case FeatureIconType.nfc:
        return 'assets/icons/feature_nfc.png';
      case FeatureIconType.refund:
        return 'assets/icons/feature_refund.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
