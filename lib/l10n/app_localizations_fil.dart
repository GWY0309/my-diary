// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Ang Aking Talaarawan';

  @override
  String get settings => 'Mga Setting';

  @override
  String get darkMode => 'Madilim na Mode';

  @override
  String get login => 'Mag-login';

  @override
  String get logout => 'Mag-logout';

  @override
  String get appLock => 'Lock ng App';

  @override
  String get deleteSuccess => 'Matagumpay na natanggal';

  @override
  String get filterByTag => 'I-filter ayon sa Tag';

  @override
  String get tagLife => 'Buhay';

  @override
  String get tagWork => 'Trabaho';

  @override
  String get tagTravel => 'Paglalakbay';

  @override
  String get tagMood => 'Mood';

  @override
  String get tagFood => 'Pagkain';

  @override
  String get tagStudy => 'Pag-aaral';

  @override
  String get tapAgainToExit => 'I-tap muli upang lumabas';

  @override
  String get selected => 'Napili';

  @override
  String get searchHint => 'Maghanap ng mga talaarawan...';

  @override
  String get noDiariesFound => 'Walang natagpuang talaarawan';

  @override
  String get logoutConfirmation =>
      'Sigurado ka bang gusto mong mag-logout?\nKailangan mong mag-login muli sa susunod.';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get confirmLogout => 'Mag-logout';

  @override
  String get appearanceAndExperience => 'Hitsura at Karanasan';

  @override
  String get privacyAndSecurity => 'Pagkapribado at Seguridad';

  @override
  String get pinLock => 'PIN Lock';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get enablePinFirst => 'Paganahin muna ang PIN lock';

  @override
  String get account => 'Account';

  @override
  String get pleaseEnablePinFirst => 'Mangyaring paganahin muna ang PIN lock';

  @override
  String get biometricNotSupported =>
      'Hindi suportado o hindi paganahin ang biometrics';

  @override
  String get enterEmailAndPassword => 'Mangyaring ilagay ang email at password';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get autoLogin => 'Auto Login';

  @override
  String get forgotPassword => 'Nakalimutan ang Password?';

  @override
  String get loginButton => 'Mag-login';

  @override
  String get noAccount => 'Wala pang account?';

  @override
  String get registerNow => 'Magrehistro Ngayon';

  @override
  String get registerTitle => 'Magrehistro';

  @override
  String get confirmPasswordLabel => 'Kumpirmahin ang Password';

  @override
  String get passwordsDoNotMatch => 'Hindi magkatugma ang mga password';

  @override
  String get registerSuccess => 'Matagumpay na pagpaparehistro';

  @override
  String registerFailed(Object error) {
    return 'Nabigo ang pagpaparehistro: $error';
  }

  @override
  String get newDiaryTitle => 'Bagong Talaarawan';

  @override
  String get editDiaryTitle => 'I-edit ang Talaarawan';

  @override
  String get saveButton => 'I-save';

  @override
  String get titleHint => 'Pamagat';

  @override
  String get contentHint => 'Sumulat ng tungkol sa araw na ito...';

  @override
  String get moodLabel => 'Mood';

  @override
  String get tagsLabel => 'Mga Tag';

  @override
  String get selectDate => 'Pumili ng Petsa';

  @override
  String get pleaseEnterContent => 'Mangyaring maglagay ng nilalaman';

  @override
  String get diaryDetailTitle => 'Detalye ng Talaarawan';

  @override
  String get editAction => 'I-edit';

  @override
  String get deleteAction => 'Tanggalin';

  @override
  String get shareAction => 'Ibahagi';

  @override
  String get statisticsTitle => 'Mga Istatistika';

  @override
  String get moodChartTitle => 'Trend ng Mood';

  @override
  String get diaryCountTitle => 'Kabuuang Talaarawan';

  @override
  String get moodDistribution => 'Pamamahagi ng Mood';

  @override
  String get enterPinTitle => 'Ilagay ang PIN';

  @override
  String get setPinTitle => 'Itakda ang PIN';

  @override
  String get confirmPinTitle => 'Kumpirmahin ang PIN';

  @override
  String get pinIncorrect => 'Maling PIN';

  @override
  String get pinNotMatch => 'Hindi magkatugma ang mga PIN';

  @override
  String get pinSetSuccess => 'Matagumpay na naitakda ang PIN';

  @override
  String get unlockTitle => 'I-unlock ang App';

  @override
  String get weatherLabel => 'Panahon';

  @override
  String get weatherSunny => 'Maaraw';

  @override
  String get weatherCloudy => 'Maulap';

  @override
  String get weatherRainy => 'Maulan';

  @override
  String get weatherSnowy => 'Maniyebe';

  @override
  String get weatherThunder => 'May Kulog';

  @override
  String get weatherWindy => 'Mahangin';

  @override
  String get language => 'Wika';

  @override
  String get selectLanguage => 'Pumili ng Wika';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
