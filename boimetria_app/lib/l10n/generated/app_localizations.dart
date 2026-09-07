import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('pt'),
  ];

  /// Nome do app, no cabecalho
  ///
  /// In pt, this message translates to:
  /// **'Boimetria'**
  String get appName;

  /// Subtitulo do cabecalho
  ///
  /// In pt, this message translates to:
  /// **'PELO FOCINHO'**
  String get appTagline;

  /// No description provided for @homeQuestion.
  ///
  /// In pt, this message translates to:
  /// **'O que você quer fazer?'**
  String get homeQuestion;

  /// No description provided for @homeIdentifyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quem é esse boi?'**
  String get homeIdentifyTitle;

  /// No description provided for @homeIdentifyDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aponte a câmera no focinho — o app diz o brinco na hora'**
  String get homeIdentifyDescription;

  /// No description provided for @homeRegisterTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar um animal'**
  String get homeRegisterTitle;

  /// No description provided for @homeRegisterDescription.
  ///
  /// In pt, this message translates to:
  /// **'Bezerro novo ou animal comprado que ainda não está no rebanho'**
  String get homeRegisterDescription;

  /// No description provided for @imageSourceQuestion.
  ///
  /// In pt, this message translates to:
  /// **'De onde vem a foto do focinho?'**
  String get imageSourceQuestion;

  /// No description provided for @imageSourceCameraTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tirar foto agora'**
  String get imageSourceCameraTitle;

  /// No description provided for @imageSourceCameraDescription.
  ///
  /// In pt, this message translates to:
  /// **'O animal está na sua frente'**
  String get imageSourceCameraDescription;

  /// No description provided for @imageSourceGalleryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolher da galeria'**
  String get imageSourceGalleryTitle;

  /// No description provided for @imageSourceGalleryDescription.
  ///
  /// In pt, this message translates to:
  /// **'Uma foto já tirada do focinho'**
  String get imageSourceGalleryDescription;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'CANCELAR'**
  String get cancel;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar animal'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Toque num campo para corrigir. Depois salve.'**
  String get registerSubtitle;

  /// No description provided for @registerSave.
  ///
  /// In pt, this message translates to:
  /// **'SALVAR'**
  String get registerSave;

  /// No description provided for @registerTagLabel.
  ///
  /// In pt, this message translates to:
  /// **'IDENTIFICADOR'**
  String get registerTagLabel;

  /// No description provided for @registerTagPlaceholder.
  ///
  /// In pt, this message translates to:
  /// **'Digite o número'**
  String get registerTagPlaceholder;

  /// No description provided for @registerSexLabel.
  ///
  /// In pt, this message translates to:
  /// **'SEXO'**
  String get registerSexLabel;

  /// No description provided for @registerSexMale.
  ///
  /// In pt, this message translates to:
  /// **'MACHO'**
  String get registerSexMale;

  /// No description provided for @registerSexFemale.
  ///
  /// In pt, this message translates to:
  /// **'FÊMEA'**
  String get registerSexFemale;

  /// No description provided for @registerEntryDateLabel.
  ///
  /// In pt, this message translates to:
  /// **'ENTRADA'**
  String get registerEntryDateLabel;

  /// No description provided for @registerBirthDateLabel.
  ///
  /// In pt, this message translates to:
  /// **'NASCIMENTO'**
  String get registerBirthDateLabel;

  /// No description provided for @registerWeightLabel.
  ///
  /// In pt, this message translates to:
  /// **'PESO'**
  String get registerWeightLabel;

  /// No description provided for @registerWeightPlaceholder.
  ///
  /// In pt, this message translates to:
  /// **'Digite'**
  String get registerWeightPlaceholder;

  /// No description provided for @unitKilogram.
  ///
  /// In pt, this message translates to:
  /// **'kg'**
  String get unitKilogram;

  /// No description provided for @muzzleMissingTitle.
  ///
  /// In pt, this message translates to:
  /// **'BIOMETRIA FALTANDO'**
  String get muzzleMissingTitle;

  /// No description provided for @muzzleMissingDescription.
  ///
  /// In pt, this message translates to:
  /// **'Sem a foto do focinho não dá pra salvar'**
  String get muzzleMissingDescription;

  /// No description provided for @muzzleMissingAction.
  ///
  /// In pt, this message translates to:
  /// **'LER FOCINHO'**
  String get muzzleMissingAction;

  /// No description provided for @muzzleDetectingTitle.
  ///
  /// In pt, this message translates to:
  /// **'LENDO O FOCINHO'**
  String get muzzleDetectingTitle;

  /// No description provided for @muzzleDetectingDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aguarde um instante'**
  String get muzzleDetectingDescription;

  /// No description provided for @muzzleConfidenceTitle.
  ///
  /// In pt, this message translates to:
  /// **'BIOMETRIA {confidence}'**
  String muzzleConfidenceTitle(double confidence);

  /// No description provided for @muzzleOkDescription.
  ///
  /// In pt, this message translates to:
  /// **'Pode salvar'**
  String get muzzleOkDescription;

  /// No description provided for @muzzleWeakDescription.
  ///
  /// In pt, this message translates to:
  /// **'Mínimo é {minimum} — refaça a foto'**
  String muzzleWeakDescription(double minimum);

  /// No description provided for @muzzleRetakeAction.
  ///
  /// In pt, this message translates to:
  /// **'REFAZER FOTO'**
  String get muzzleRetakeAction;

  /// No description provided for @muzzleAbsentTitle.
  ///
  /// In pt, this message translates to:
  /// **'NÃO ACHEI O FOCINHO'**
  String get muzzleAbsentTitle;

  /// No description provided for @muzzleAbsentDescription.
  ///
  /// In pt, this message translates to:
  /// **'Aponte a câmera no focinho do animal'**
  String get muzzleAbsentDescription;

  /// No description provided for @muzzleAbsentAction.
  ///
  /// In pt, this message translates to:
  /// **'TIRAR OUTRA FOTO'**
  String get muzzleAbsentAction;

  /// No description provided for @muzzleFailedTitle.
  ///
  /// In pt, this message translates to:
  /// **'NÃO DEU PRA LER'**
  String get muzzleFailedTitle;

  /// No description provided for @muzzleRetryAction.
  ///
  /// In pt, this message translates to:
  /// **'TENTAR DE NOVO'**
  String get muzzleRetryAction;

  /// No description provided for @dateFieldPlaceholder.
  ///
  /// In pt, this message translates to:
  /// **'dd/mm/aaaa'**
  String get dateFieldPlaceholder;

  /// No description provided for @dateFieldToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get dateFieldToday;
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
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
