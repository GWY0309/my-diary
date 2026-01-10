// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Diary';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get appLock => 'App Lock';

  @override
  String get deleteSuccess => 'Delete successful';

  @override
  String get filterByTag => 'Filter by Tag';

  @override
  String get tagLife => 'Life';

  @override
  String get tagWork => 'Work';

  @override
  String get tagTravel => 'Travel';

  @override
  String get tagMood => 'Mood';

  @override
  String get tagFood => 'Food';

  @override
  String get tagStudy => 'Study';

  @override
  String get tapAgainToExit => 'Tap again to exit My Diary';

  @override
  String get selected => 'Selected';

  @override
  String get searchHint => 'Search diaries...';

  @override
  String get noDiariesFound => 'No diaries found';

  @override
  String get logoutConfirmation =>
      'Are you sure you want to logout?\nYou will need to login again next time.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmLogout => 'Logout';

  @override
  String get appearanceAndExperience => 'Appearance & Experience';

  @override
  String get privacyAndSecurity => 'Privacy & Security';

  @override
  String get pinLock => 'PIN Lock';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get enablePinFirst => 'Enable PIN lock first';

  @override
  String get account => 'Account';

  @override
  String get pleaseEnablePinFirst => 'Please enable PIN lock first';

  @override
  String get biometricNotSupported => 'Biometric not supported or enabled';

  @override
  String get enterEmailAndPassword => 'Please enter email and password';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get autoLogin => 'Auto Login';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginButton => 'Login';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get registerNow => 'Register Now';

  @override
  String get registerTitle => 'Register';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String registerFailed(Object error) {
    return 'Registration failed: $error';
  }

  @override
  String get newDiaryTitle => 'New Diary';

  @override
  String get editDiaryTitle => 'Edit Diary';

  @override
  String get saveButton => 'Save';

  @override
  String get titleHint => 'Title';

  @override
  String get contentHint => 'Write something today...';

  @override
  String get moodLabel => 'Mood';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get selectDate => 'Select Date';

  @override
  String get pleaseEnterContent => 'Please enter content';

  @override
  String get diaryDetailTitle => 'Diary Detail';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get shareAction => 'Share';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get moodChartTitle => 'Mood Trend';

  @override
  String get diaryCountTitle => 'Total Diaries';

  @override
  String get moodDistribution => 'Mood Distribution';

  @override
  String get enterPinTitle => 'Enter PIN';

  @override
  String get setPinTitle => 'Set PIN';

  @override
  String get confirmPinTitle => 'Confirm PIN';

  @override
  String get pinIncorrect => 'Incorrect PIN';

  @override
  String get pinNotMatch => 'PINs do not match';

  @override
  String get pinSetSuccess => 'PIN set successfully';

  @override
  String get unlockTitle => 'Unlock App';

  @override
  String get weatherLabel => 'Weather';

  @override
  String get weatherSunny => 'Sunny';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get weatherSnowy => 'Snowy';

  @override
  String get weatherThunder => 'Thunder';

  @override
  String get weatherWindy => 'Windy';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
