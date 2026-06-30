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

  static String get emailJsServiceId => switch (flavor) {
        Flavor.dev => 'service_dev_REPLACE',
        Flavor.prod => 'service_prod_REPLACE',
      };

  static String get emailJsTemplateId => switch (flavor) {
        Flavor.dev => 'template_dev_REPLACE',
        Flavor.prod => 'template_prod_REPLACE',
      };

  static String get emailJsPublicKey => switch (flavor) {
        Flavor.dev => 'public_key_dev_REPLACE',
        Flavor.prod => 'public_key_prod_REPLACE',
      };
}
