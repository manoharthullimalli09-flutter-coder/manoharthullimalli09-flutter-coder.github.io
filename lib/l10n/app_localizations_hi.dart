// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मनोहर थुल्लिमल्ली — फ्लटर डेवलपर';

  @override
  String get heroGreeting => 'नमस्ते, मैं मनोहर हूँ';

  @override
  String get heroTitle => 'वरिष्ठ फ्लटर डेवलपर';

  @override
  String get heroBio =>
      'मैं Flutter के साथ उच्च-प्रदर्शन, क्रॉस-प्लेटफ़ॉर्म ऐप्स बनाता हूँ — मोबाइल से वेब और डेस्कटॉप तक।';

  @override
  String get heroCtaProjects => 'मेरा काम देखें';

  @override
  String get heroCtaContact => 'मुझे हायर करें';

  @override
  String statYears(int count) {
    return '$count वर्ष';
  }

  @override
  String statProjects(int count) {
    return '$count+ प्रोजेक्ट';
  }

  @override
  String statPlatforms(int count) {
    return '$count प्लेटफ़ॉर्म';
  }

  @override
  String get navHome => 'होम';

  @override
  String get navProjects => 'प्रोजेक्ट';

  @override
  String get navSkills => 'कौशल';

  @override
  String get navContact => 'संपर्क';

  @override
  String get projectsSectionTitle => 'मेरे प्रोजेक्ट';

  @override
  String get projectsSectionSubtitle =>
      'ई-कॉमर्स, हेल्थकेयर, फिनटेक, लॉजिस्टिक्स पर वास्तविक ऐप्स।';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterAndroid => 'Android';

  @override
  String get filterIos => 'iOS';

  @override
  String get filterWeb => 'Web';

  @override
  String get filterDesktop => 'Desktop';

  @override
  String get skillsSectionTitle => 'कौशल और तकनीक';

  @override
  String get skillsSectionSubtitle =>
      'Flutter ऐप्स बनाने के लिए मैं जो तकनीक उपयोग करता हूँ।';

  @override
  String get contactSectionTitle => 'मिलकर काम करें';

  @override
  String get contactSectionSubtitle =>
      'वरिष्ठ / लीड Flutter भूमिकाओं के लिए उपलब्ध।';

  @override
  String get contactNameLabel => 'आपका नाम';

  @override
  String get contactEmailLabel => 'आपका ईमेल';

  @override
  String get contactSubjectLabel => 'विषय';

  @override
  String get contactMessageLabel => 'संदेश';

  @override
  String get contactSendButton => 'संदेश भेजें';

  @override
  String get contactSending => 'भेज रहे हैं...';

  @override
  String get contactSuccess => 'संदेश भेजा गया! मैं जल्द ही जवाब दूँगा।';

  @override
  String get contactError => 'भेजने में विफल। कृपया पुनः प्रयास करें।';

  @override
  String get downloadResume => 'रेज़्यूमे डाउनलोड करें';

  @override
  String get toggleTheme => 'थीम बदलें';

  @override
  String get errorGeneric => 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get retry => 'पुनः प्रयास';
}
