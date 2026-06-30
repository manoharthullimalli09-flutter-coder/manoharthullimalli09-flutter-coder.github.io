// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Manohar Thullimalli — Flutter Developer';

  @override
  String get heroGreeting => 'Hi, I\'m Manohar';

  @override
  String get heroTitle => 'Senior Flutter Developer';

  @override
  String get heroBio =>
      'I build high-performance, cross-platform apps with Flutter — from pixel-perfect mobile UIs to full-featured web and desktop products.';

  @override
  String get heroCtaProjects => 'View My Work';

  @override
  String get heroCtaContact => 'Hire Me';

  @override
  String statYears(int count) {
    return '$count Years';
  }

  @override
  String statProjects(int count) {
    return '$count+ Projects';
  }

  @override
  String statPlatforms(int count) {
    return '$count Platforms';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navProjects => 'Projects';

  @override
  String get navSkills => 'Skills';

  @override
  String get navContact => 'Contact';

  @override
  String get projectsSectionTitle => 'My Projects';

  @override
  String get projectsSectionSubtitle =>
      'Real-world apps shipped across e-commerce, healthcare, fintech, logistics, and social platforms.';

  @override
  String get filterAll => 'All';

  @override
  String get filterAndroid => 'Android';

  @override
  String get filterIos => 'iOS';

  @override
  String get filterWeb => 'Web';

  @override
  String get filterDesktop => 'Desktop';

  @override
  String get skillsSectionTitle => 'Skills & Tech Stack';

  @override
  String get skillsSectionSubtitle =>
      'Technologies I use to build production-grade Flutter apps.';

  @override
  String get contactSectionTitle => 'Let\'s Work Together';

  @override
  String get contactSectionSubtitle =>
      'Open to Senior / Lead Flutter roles. Let\'s build something great.';

  @override
  String get contactNameLabel => 'Your Name';

  @override
  String get contactEmailLabel => 'Your Email';

  @override
  String get contactSubjectLabel => 'Subject';

  @override
  String get contactMessageLabel => 'Message';

  @override
  String get contactSendButton => 'Send Message';

  @override
  String get contactSending => 'Sending...';

  @override
  String get contactSuccess => 'Message sent! I\'ll get back to you soon.';

  @override
  String get contactError => 'Failed to send. Please try again.';

  @override
  String get downloadResume => 'Download Resume';

  @override
  String get toggleTheme => 'Toggle Theme';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';
}
