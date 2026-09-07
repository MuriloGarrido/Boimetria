// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Boimetria';

  @override
  String get appTagline => 'PELO FOCINHO';

  @override
  String get homeQuestion => 'O que você quer fazer?';

  @override
  String get homeIdentifyTitle => 'Quem é esse boi?';

  @override
  String get homeIdentifyDescription =>
      'Aponte a câmera no focinho — o app diz o brinco na hora';

  @override
  String get homeRegisterTitle => 'Cadastrar um animal';

  @override
  String get homeRegisterDescription =>
      'Bezerro novo ou animal comprado que ainda não está no rebanho';

  @override
  String get imageSourceQuestion => 'De onde vem a foto do focinho?';

  @override
  String get imageSourceCameraTitle => 'Tirar foto agora';

  @override
  String get imageSourceCameraDescription => 'O animal está na sua frente';

  @override
  String get imageSourceGalleryTitle => 'Escolher da galeria';

  @override
  String get imageSourceGalleryDescription => 'Uma foto já tirada do focinho';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get registerTitle => 'Cadastrar animal';

  @override
  String get registerSubtitle => 'Toque num campo para corrigir. Depois salve.';

  @override
  String get registerSave => 'SALVAR';

  @override
  String get registerTagLabel => 'IDENTIFICADOR';

  @override
  String get registerTagPlaceholder => 'Digite o número';

  @override
  String get registerSexLabel => 'SEXO';

  @override
  String get registerSexMale => 'MACHO';

  @override
  String get registerSexFemale => 'FÊMEA';

  @override
  String get registerEntryDateLabel => 'ENTRADA';

  @override
  String get registerBirthDateLabel => 'NASCIMENTO';

  @override
  String get registerWeightLabel => 'PESO';

  @override
  String get registerWeightPlaceholder => 'Digite';

  @override
  String get unitKilogram => 'kg';

  @override
  String get muzzleMissingTitle => 'BIOMETRIA FALTANDO';

  @override
  String get muzzleMissingDescription =>
      'Sem a foto do focinho não dá pra salvar';

  @override
  String get muzzleMissingAction => 'LER FOCINHO';

  @override
  String get muzzleDetectingTitle => 'LENDO O FOCINHO';

  @override
  String get muzzleDetectingDescription => 'Aguarde um instante';

  @override
  String muzzleConfidenceTitle(double confidence) {
    final intl.NumberFormat confidenceNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String confidenceString = confidenceNumberFormat.format(confidence);

    return 'BIOMETRIA $confidenceString';
  }

  @override
  String get muzzleOkDescription => 'Pode salvar';

  @override
  String muzzleWeakDescription(double minimum) {
    final intl.NumberFormat minimumNumberFormat =
        intl.NumberFormat.percentPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);

    return 'Mínimo é $minimumString — refaça a foto';
  }

  @override
  String get muzzleRetakeAction => 'REFAZER FOTO';

  @override
  String get muzzleAbsentTitle => 'NÃO ACHEI O FOCINHO';

  @override
  String get muzzleAbsentDescription => 'Aponte a câmera no focinho do animal';

  @override
  String get muzzleAbsentAction => 'TIRAR OUTRA FOTO';

  @override
  String get muzzleFailedTitle => 'NÃO DEU PRA LER';

  @override
  String get muzzleRetryAction => 'TENTAR DE NOVO';

  @override
  String get dateFieldPlaceholder => 'dd/mm/aaaa';

  @override
  String get dateFieldToday => 'Hoje';
}
