// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mein Tagebuch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get deleteSuccess => 'Erfolgreich gelöscht';

  @override
  String get filterByTag => 'Nach Tag filtern';

  @override
  String get tagLife => 'Leben';

  @override
  String get tagWork => 'Arbeit';

  @override
  String get tagTravel => 'Reisen';

  @override
  String get tagMood => 'Stimmung';

  @override
  String get tagFood => 'Essen';

  @override
  String get tagStudy => 'Studium';

  @override
  String get tapAgainToExit => 'Erneut tippen zum Beenden';

  @override
  String get selected => 'Ausgewählt';

  @override
  String get searchHint => 'Tagebücher suchen...';

  @override
  String get noDiariesFound => 'Keine Tagebücher gefunden';

  @override
  String get logoutConfirmation =>
      'Möchten Sie sich wirklich abmelden?\nSie müssen sich beim nächsten Mal erneut anmelden.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirmLogout => 'Abmelden';

  @override
  String get appearanceAndExperience => 'Erscheinungsbild';

  @override
  String get privacyAndSecurity => 'Datenschutz & Sicherheit';

  @override
  String get pinLock => 'PIN-Sperre';

  @override
  String get biometricUnlock => 'Biometrische Entsperrung';

  @override
  String get enablePinFirst => 'Bitte zuerst PIN-Sperre aktivieren';

  @override
  String get account => 'Konto';

  @override
  String get pleaseEnablePinFirst => 'Bitte zuerst PIN-Sperre aktivieren';

  @override
  String get biometricNotSupported =>
      'Biometrie nicht unterstützt oder deaktiviert';

  @override
  String get enterEmailAndPassword => 'Bitte E-Mail und Passwort eingeben';

  @override
  String get emailLabel => 'E-Mail-Adresse';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get autoLogin => 'Auto-Login';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get noAccount => 'Kein Konto?';

  @override
  String get registerNow => 'Jetzt registrieren';

  @override
  String get registerTitle => 'Registrieren';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get registerSuccess => 'Registrierung erfolgreich';

  @override
  String registerFailed(Object error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String get newDiaryTitle => 'Neues Tagebuch';

  @override
  String get editDiaryTitle => 'Tagebuch bearbeiten';

  @override
  String get saveButton => 'Speichern';

  @override
  String get titleHint => 'Titel';

  @override
  String get contentHint => 'Schreibe etwas über heute...';

  @override
  String get moodLabel => 'Stimmung';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get selectDate => 'Datum wählen';

  @override
  String get pleaseEnterContent => 'Bitte Inhalt eingeben';

  @override
  String get diaryDetailTitle => 'Tagebuch Details';

  @override
  String get editAction => 'Bearbeiten';

  @override
  String get deleteAction => 'Löschen';

  @override
  String get shareAction => 'Teilen';

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String get moodChartTitle => 'Stimmungsverlauf';

  @override
  String get diaryCountTitle => 'Gesamtanzahl';

  @override
  String get moodDistribution => 'Stimmungsverteilung';

  @override
  String get enterPinTitle => 'PIN eingeben';

  @override
  String get setPinTitle => 'PIN festlegen';

  @override
  String get confirmPinTitle => 'PIN bestätigen';

  @override
  String get pinIncorrect => 'Falsche PIN';

  @override
  String get pinNotMatch => 'PINs stimmen nicht überein';

  @override
  String get pinSetSuccess => 'PIN erfolgreich festgelegt';

  @override
  String get unlockTitle => 'App entsperren';

  @override
  String get weatherLabel => 'Wetter';

  @override
  String get weatherSunny => 'Sonnig';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherRainy => 'Regnerisch';

  @override
  String get weatherSnowy => 'Schneereich';

  @override
  String get weatherThunder => 'Gewitter';

  @override
  String get weatherWindy => 'Windig';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache wählen';
}
