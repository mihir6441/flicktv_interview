import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'navigation/app_route_information_parser.dart';
import 'navigation/app_router_delegate.dart';

class MihirBhojaniApp extends StatefulWidget {
  const MihirBhojaniApp({super.key});

  @override
  State<MihirBhojaniApp> createState() => _MihirBhojaniAppState();
}

class _MihirBhojaniAppState extends State<MihirBhojaniApp> {
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteInformationParser _routeParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = AppRouterDelegate();
    _routeParser = AppRouteInformationParser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mihir Bhojani',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeParser,
    );
  }
}
