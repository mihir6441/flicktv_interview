import 'package:flutter/material.dart';

import '../features/money/screens/money_screen.dart';
import 'app_route_path.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate() : _configuration = const AppRoutePath();

  AppRoutePath _configuration;

  @override
  AppRoutePath get currentConfiguration => _configuration;

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage<void>(
          key: const ValueKey('money'),
          child: MoneyScreen(onBack: _handleBack),
        ),
      ],
      onDidRemovePage: (_) => notifyListeners(),
    );
  }

  void _handleBack() {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop();
      return;
    }
    _configuration = const AppRoutePath(isMoneyScreen: true);
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _configuration = configuration;
  }
}
