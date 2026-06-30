import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/config/app_config.dart';
import 'injection_container.dart' as di;
import 'portfolio_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) usePathUrlStrategy();
  AppConfig.flavor = Flavor.dev;
  await di.init();
  runApp(const PortfolioApp());
}
