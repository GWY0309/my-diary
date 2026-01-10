// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'Min Dagbok';

  @override
  String get settings => 'Inställningar';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get login => 'Logga in';

  @override
  String get logout => 'Logga ut';

  @override
  String get appLock => 'App-lås';

  @override
  String get deleteSuccess => 'Raderad framgångsrikt';

  @override
  String get filterByTag => 'Filtrera efter tagg';

  @override
  String get tagLife => 'Livet';

  @override
  String get tagWork => 'Arbete';

  @override
  String get tagTravel => 'Resor';

  @override
  String get tagMood => 'Humör';

  @override
  String get tagFood => 'Mat';

  @override
  String get tagStudy => 'Studier';

  @override
  String get tapAgainToExit => 'Tryck igen för att avsluta';

  @override
  String get selected => 'Vald';

  @override
  String get searchHint => 'Sök dagböcker...';

  @override
  String get noDiariesFound => 'Inga dagböcker hittades';

  @override
  String get logoutConfirmation =>
      'Är du säker på att du vill logga ut?\nDu måste logga in igen nästa gång.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get confirmLogout => 'Logga ut';

  @override
  String get appearanceAndExperience => 'Utseende och Upplevelse';

  @override
  String get privacyAndSecurity => 'Integritet och Säkerhet';

  @override
  String get pinLock => 'PIN-lås';

  @override
  String get biometricUnlock => 'Biometrisk upplåsning';

  @override
  String get enablePinFirst => 'Aktivera PIN-lås först';

  @override
  String get account => 'Konto';

  @override
  String get pleaseEnablePinFirst => 'Vänligen aktivera PIN-lås först';

  @override
  String get biometricNotSupported =>
      'Biometri stöds inte eller är inte aktiverat';

  @override
  String get enterEmailAndPassword => 'Ange e-post och lösenord';

  @override
  String get emailLabel => 'E-postadress';

  @override
  String get passwordLabel => 'Lösenord';

  @override
  String get autoLogin => 'Automatisk inloggning';

  @override
  String get forgotPassword => 'Glömt lösenord?';

  @override
  String get loginButton => 'Logga in';

  @override
  String get noAccount => 'Inget konto?';

  @override
  String get registerNow => 'Registrera nu';

  @override
  String get registerTitle => 'Registrera';

  @override
  String get confirmPasswordLabel => 'Bekräfta lösenord';

  @override
  String get passwordsDoNotMatch => 'Lösenorden matchar inte';

  @override
  String get registerSuccess => 'Registrering lyckades';

  @override
  String registerFailed(Object error) {
    return 'Registrering misslyckades: $error';
  }

  @override
  String get newDiaryTitle => 'Ny Dagbok';

  @override
  String get editDiaryTitle => 'Redigera Dagbok';

  @override
  String get saveButton => 'Spara';

  @override
  String get titleHint => 'Titel';

  @override
  String get contentHint => 'Skriv något om idag...';

  @override
  String get moodLabel => 'Humör';

  @override
  String get tagsLabel => 'Taggar';

  @override
  String get selectDate => 'Välj datum';

  @override
  String get pleaseEnterContent => 'Vänligen ange innehåll';

  @override
  String get diaryDetailTitle => 'Dagboksdetalj';

  @override
  String get editAction => 'Redigera';

  @override
  String get deleteAction => 'Radera';

  @override
  String get shareAction => 'Dela';

  @override
  String get statisticsTitle => 'Statistik';

  @override
  String get moodChartTitle => 'Humörtrend';

  @override
  String get diaryCountTitle => 'Totalt antal dagböcker';

  @override
  String get moodDistribution => 'Humörfördelning';

  @override
  String get enterPinTitle => 'Ange PIN';

  @override
  String get setPinTitle => 'Ställ in PIN';

  @override
  String get confirmPinTitle => 'Bekräfta PIN';

  @override
  String get pinIncorrect => 'Felaktig PIN';

  @override
  String get pinNotMatch => 'PIN-koderna matchar inte';

  @override
  String get pinSetSuccess => 'PIN inställd';

  @override
  String get unlockTitle => 'Lås upp appen';

  @override
  String get weatherLabel => 'Väder';

  @override
  String get weatherSunny => 'Soligt';

  @override
  String get weatherCloudy => 'Molnigt';

  @override
  String get weatherRainy => 'Regnigt';

  @override
  String get weatherSnowy => 'Snöigt';

  @override
  String get weatherThunder => 'Åska';

  @override
  String get weatherWindy => 'Blåsigt';

  @override
  String get language => 'Språk';

  @override
  String get selectLanguage => 'Välj språk';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
