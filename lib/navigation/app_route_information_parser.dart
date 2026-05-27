import 'package:flutter/material.dart';

import 'app_route_path.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.uri.path;
    if (location == '/money' || location == '/') {
      return const AppRoutePath(isMoneyScreen: true);
    }
    return const AppRoutePath(isMoneyScreen: true);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    return RouteInformation(
      uri: Uri(path: configuration.isMoneyScreen ? '/money' : '/money'),
    );
  }
}
