enum Flavor { dev, prod }

/// EmailJS credentials are injected at build time via `--dart-define` and are
/// **not** committed. See `.github/workflows/deploy_web.yml`.
///
/// This keeps them out of the repository and out of git history. It does **not**
/// hide them from a visitor: the browser must send them to EmailJS, so they are
/// always readable in the Network tab. Nothing compiled into a web client can
/// be secret. The control that actually limits abuse is the allowed-origins
/// list in the EmailJS dashboard, which is enforced on their server.
class AppConfig {
  static late Flavor flavor;

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;
  static bool get enableLogging => isDev;

  static String get appName => switch (flavor) {
    Flavor.dev => 'Portfolio DEV',
    Flavor.prod => 'Manohar Thullimalli',
  };

  static String get emailJsBaseUrl => 'https://api.emailjs.com';

  static const emailJsServiceId =
      String.fromEnvironment('EMAILJS_SERVICE_ID');
  static const emailJsTemplateId =
      String.fromEnvironment('EMAILJS_TEMPLATE_ID');
  static const emailJsPublicKey =
      String.fromEnvironment('EMAILJS_PUBLIC_KEY');

  /// False on a build with no credentials injected — a local `flutter run`, or
  /// a fork without the secrets. The contact form says so instead of posting
  /// a request that would fail with an opaque server error.
  static bool get isEmailConfigured =>
      emailJsServiceId.isNotEmpty &&
      emailJsTemplateId.isNotEmpty &&
      emailJsPublicKey.isNotEmpty;
}
