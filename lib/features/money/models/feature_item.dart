enum FeatureIconType { tap, nfc, refund }

class FeatureItem {
  const FeatureItem({
    required this.title,
    required this.description,
    required this.iconType,
  });

  final String title;
  final String description;
  final FeatureIconType iconType;
}

const kFeatureItems = [
  FeatureItem(
    title: 'Single tap payments',
    description: 'Enjoy seamless payments without the wait for OTPs',
    iconType: FeatureIconType.tap,
  ),
  FeatureItem(
    title: 'Zero failures',
    description: 'Zero payment failures ensure you never miss an order',
    iconType: FeatureIconType.nfc,
  ),
  FeatureItem(
    title: 'Real-time refunds',
    description:
        'No need to wait for refunds. blinkit Money refunds are instant!',
    iconType: FeatureIconType.refund,
  ),
];
