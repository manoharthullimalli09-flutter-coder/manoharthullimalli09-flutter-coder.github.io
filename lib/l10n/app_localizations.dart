import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Manohar Thullimalli — Flutter Developer'**
  String get appTitle;

  /// No description provided for @heroGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, I\'m Manohar'**
  String get heroGreeting;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Senior Flutter Developer'**
  String get heroTitle;

  /// No description provided for @heroBio.
  ///
  /// In en, this message translates to:
  /// **'I build high-performance, cross-platform apps with Flutter — from pixel-perfect mobile UIs to full-featured web and desktop products.'**
  String get heroBio;

  /// No description provided for @heroCtaProjects.
  ///
  /// In en, this message translates to:
  /// **'View My Work'**
  String get heroCtaProjects;

  /// No description provided for @heroCtaContact.
  ///
  /// In en, this message translates to:
  /// **'Hire Me'**
  String get heroCtaContact;

  /// No description provided for @statYears.
  ///
  /// In en, this message translates to:
  /// **'{count} Years'**
  String statYears(int count);

  /// No description provided for @statProjects.
  ///
  /// In en, this message translates to:
  /// **'{count}+ Projects'**
  String statProjects(int count);

  /// No description provided for @statPlatforms.
  ///
  /// In en, this message translates to:
  /// **'{count} Platforms'**
  String statPlatforms(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navSkills;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @projectsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Projects'**
  String get projectsSectionTitle;

  /// No description provided for @projectsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-world apps shipped across e-commerce, healthcare, fintech, logistics, and social platforms.'**
  String get projectsSectionSubtitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get filterAndroid;

  /// No description provided for @filterIos.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get filterIos;

  /// No description provided for @filterWeb.
  ///
  /// In en, this message translates to:
  /// **'Web'**
  String get filterWeb;

  /// No description provided for @filterDesktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get filterDesktop;

  /// No description provided for @skillsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills & Tech Stack'**
  String get skillsSectionTitle;

  /// No description provided for @skillsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Technologies I use to build production-grade Flutter apps.'**
  String get skillsSectionSubtitle;

  /// No description provided for @contactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Work Together'**
  String get contactSectionTitle;

  /// No description provided for @contactSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open to Senior / Lead Flutter roles. Let\'s build something great.'**
  String get contactSectionSubtitle;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get contactNameLabel;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get contactEmailLabel;

  /// No description provided for @contactSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactSubjectLabel;

  /// No description provided for @contactMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get contactMessageLabel;

  /// No description provided for @contactSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get contactSendButton;

  /// No description provided for @contactSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get contactSending;

  /// No description provided for @contactSuccess.
  ///
  /// In en, this message translates to:
  /// **'Message sent! I\'ll get back to you soon.'**
  String get contactSuccess;

  /// No description provided for @contactError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send. Please try again.'**
  String get contactError;

  /// No description provided for @downloadResume.
  ///
  /// In en, this message translates to:
  /// **'Download Resume'**
  String get downloadResume;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle Theme'**
  String get toggleTheme;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
