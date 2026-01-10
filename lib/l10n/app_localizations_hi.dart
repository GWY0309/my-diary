// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मेरी डायरी';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get login => 'लॉग इन';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get deleteSuccess => 'सफलतापूर्वक हटाया गया';

  @override
  String get filterByTag => 'टैग द्वारा फ़िल्टर करें';

  @override
  String get tagLife => 'जीवन';

  @override
  String get tagWork => 'काम';

  @override
  String get tagTravel => 'यात्रा';

  @override
  String get tagMood => 'मनोदशा';

  @override
  String get tagFood => 'भोजन';

  @override
  String get tagStudy => 'अध्ययन';

  @override
  String get tapAgainToExit => 'बाहर निकलने के लिए फिर से टैप करें';

  @override
  String get selected => 'चयनित';

  @override
  String get searchHint => 'डायरी खोजें...';

  @override
  String get noDiariesFound => 'कोई डायरी नहीं मिली';

  @override
  String get logoutConfirmation =>
      'क्या आप वाकई लॉग आउट करना चाहते हैं?\nआपको अगली बार फिर से लॉग इन करना होगा।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirmLogout => 'लॉग आउट';

  @override
  String get appearanceAndExperience => 'दिखावट और अनुभव';

  @override
  String get privacyAndSecurity => 'गोपनीयता और सुरक्षा';

  @override
  String get pinLock => 'पिन लॉक';

  @override
  String get biometricUnlock => 'बायोमेट्रिक अनलॉक';

  @override
  String get enablePinFirst => 'पहले पिन लॉक सक्षम करें';

  @override
  String get account => 'खाता';

  @override
  String get pleaseEnablePinFirst => 'कृपया पहले पिन लॉक सक्षम करें';

  @override
  String get biometricNotSupported =>
      'बायोमेट्रिक समर्थित नहीं है या सक्षम नहीं है';

  @override
  String get enterEmailAndPassword => 'कृपया ईमेल और पासवर्ड दर्ज करें';

  @override
  String get emailLabel => 'ईमेल पता';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get autoLogin => 'स्वतः लॉग इन';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get loginButton => 'लॉग इन';

  @override
  String get noAccount => 'कोई खाता नहीं है?';

  @override
  String get registerNow => 'अभी पंजीकरण करें';

  @override
  String get registerTitle => 'पंजीकरण';

  @override
  String get confirmPasswordLabel => 'पासवर्ड की पुष्टि करें';

  @override
  String get passwordsDoNotMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get registerSuccess => 'पंजीकरण सफल';

  @override
  String registerFailed(Object error) {
    return 'पंजीकरण विफल: $error';
  }

  @override
  String get newDiaryTitle => 'नई डायरी';

  @override
  String get editDiaryTitle => 'डायरी संपादित करें';

  @override
  String get saveButton => 'सहेजें';

  @override
  String get titleHint => 'शीर्षक';

  @override
  String get contentHint => 'आज के बारे में कुछ लिखें...';

  @override
  String get moodLabel => 'मनोदशा';

  @override
  String get tagsLabel => 'टैग';

  @override
  String get selectDate => 'तारीख़ चुनें';

  @override
  String get pleaseEnterContent => 'कृपया सामग्री दर्ज करें';

  @override
  String get diaryDetailTitle => 'डायरी विवरण';

  @override
  String get editAction => 'संपादित करें';

  @override
  String get deleteAction => 'हटाएं';

  @override
  String get shareAction => 'साझा करें';

  @override
  String get statisticsTitle => 'आंकड़े';

  @override
  String get moodChartTitle => 'मनोदशा प्रवृत्ति';

  @override
  String get diaryCountTitle => 'कुल डायरी';

  @override
  String get moodDistribution => 'मनोदशा वितरण';

  @override
  String get enterPinTitle => 'पिन दर्ज करें';

  @override
  String get setPinTitle => 'पिन सेट करें';

  @override
  String get confirmPinTitle => 'पिन की पुष्टि करें';

  @override
  String get pinIncorrect => 'गलत पिन';

  @override
  String get pinNotMatch => 'पिन मेल नहीं खाते';

  @override
  String get pinSetSuccess => 'पिन सफलतापूर्वक सेट किया गया';

  @override
  String get unlockTitle => 'ऐप अनलॉक करें';

  @override
  String get weatherLabel => 'मौसम';

  @override
  String get weatherSunny => 'धूप';

  @override
  String get weatherCloudy => 'बादल';

  @override
  String get weatherRainy => 'बरसात';

  @override
  String get weatherSnowy => 'बर्फबारी';

  @override
  String get weatherThunder => 'आंधी';

  @override
  String get weatherWindy => 'हवादार';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
