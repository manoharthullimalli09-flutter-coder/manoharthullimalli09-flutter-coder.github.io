import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/portfolio_page.dart';

class AppRoutes {
  static const home = '/';
  static const projects = '/projects';
  static const skills = '/skills';
  static const contact = '/contact';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(path: AppRoutes.home, builder: (_, __) => const PortfolioPage()),
    GoRoute(
      path: AppRoutes.projects,
      builder: (_, __) => const PortfolioPage(),
    ),
    GoRoute(path: AppRoutes.skills, builder: (_, __) => const PortfolioPage()),
    GoRoute(path: AppRoutes.contact, builder: (_, __) => const PortfolioPage()),
  ],
);
