enum Flavor { dev, prod }

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

  static String get emailJsServiceId => 'service_6i6dshm';

  static String get emailJsTemplateId => 'template_18ixu8l';

  static String get emailJsPublicKey => '0iFV81kJcmqT7fgXU';
}
