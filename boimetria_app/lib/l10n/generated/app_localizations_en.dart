// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Boimetria';

  @override
  String get appTagline => 'BY THE MUZZLE';

  @override
  String get homeQuestion => 'What do you want to do?';

  @override
  String get homeIdentifyTitle => 'Which one is this?';

  @override
  String get homeIdentifyDescription =>
      'Point the camera at the muzzle — the app names the tag right away';

  @override
  String get homeRegisterTitle => 'Register an animal';

  @override
  String get homeRegisterDescription =>
      'A new calf, or one you bought that is not in the herd yet';

  @override
  String get imageSourceQuestion => 'Where does the muzzle photo come from?';

  @override
  String get imageSourceCameraTitle => 'Take a photo now';

  @override
  String get imageSourceCameraDescription => 'The animal is in front of you';

  @override
  String get imageSourceGalleryTitle => 'Pick from the gallery';

  @override
  String get imageSourceGalleryDescription => 'A muzzle photo you already took';

  @override
  String get cancel => 'CANCEL';

  @override
  String get registerTitle => 'Register animal';

  @override
  String get registerSubtitle => 'Tap a field to correct it. Then save.';

  @override
  String get registerSave => 'SAVE';

  @override
  String get registerTagLabel => 'TAG';

  @override
  String get registerTagPlaceholder => 'Enter the number';

  @override
  String get registerSexLabel => 'SEX';

  @override
  String get registerSexMale => 'MALE';

  @override
  String get registerSexFemale => 'FEMALE';

  @override
  String get registerEntryDateLabel => 'ENTRY';

  @override
  String get registerBirthDateLabel => 'BIRTH';

  @override
  String get registerWeightLabel => 'WEIGHT';

  @override
  String get registerWeightPlaceholder => 'Enter';

  @override
  String get unitKilogram => 'kg';

  @override
  String get muzzleMissingTitle => 'BIOMETRICS MISSING';

  @override
  String get muzzleMissingDescription =>
      'Without the muzzle photo you cannot save';

  @override
  String get muzzleMissingAction => 'READ MUZZLE';

  @override
  String get muzzleDetectingTitle => 'READING THE MUZZLE';

  @override
  String get muzzleDetectingDescription => 'Just a moment';

  @override
  String muzzleConfidenceTitle(double confidence) {
    final intl.NumberFormat confidenceNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String confidenceString = confidenceNumberFormat.format(confidence);

    return 'BIOMETRICS $confidenceString';
  }

  @override
  String get muzzleOkDescription => 'Ready to save';

  @override
  String muzzleWeakDescription(double minimum) {
    final intl.NumberFormat minimumNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);

    return 'Minimum is $minimumString — take the photo again';
  }

  @override
  String get muzzleRetakeAction => 'RETAKE PHOTO';

  @override
  String get muzzleAbsentTitle => 'NO MUZZLE FOUND';

  @override
  String get muzzleAbsentDescription =>
      'Point the camera at the animal\'s muzzle';

  @override
  String get muzzleAbsentAction => 'TAKE ANOTHER PHOTO';

  @override
  String get muzzleFailedTitle => 'COULD NOT READ IT';

  @override
  String get muzzleRetryAction => 'TRY AGAIN';

  @override
  String get dateFieldPlaceholder => 'mm/dd/yyyy';

  @override
  String get dateFieldToday => 'Today';
}
