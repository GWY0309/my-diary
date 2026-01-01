// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Mój Pamiętnik';

  @override
  String get settings => 'Ustawienia';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get login => 'Zaloguj się';

  @override
  String get logout => 'Wyloguj się';

  @override
  String get appLock => 'Blokada aplikacji';

  @override
  String get deleteSuccess => 'Pomyślnie usunięto';

  @override
  String get filterByTag => 'Filtruj wg tagu';

  @override
  String get tagLife => 'Życie';

  @override
  String get tagWork => 'Praca';

  @override
  String get tagTravel => 'Podróże';

  @override
  String get tagMood => 'Nastrój';

  @override
  String get tagFood => 'Jedzenie';

  @override
  String get tagStudy => 'Nauka';

  @override
  String get tapAgainToExit => 'Naciśnij ponownie, aby wyjść';

  @override
  String get selected => 'Wybrano';

  @override
  String get searchHint => 'Szukaj pamiętników...';

  @override
  String get noDiariesFound => 'Nie znaleziono pamiętników';

  @override
  String get logoutConfirmation =>
      'Czy na pewno chcesz się wylogować?\nNastępnym razem będziesz musiał zalogować się ponownie.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirmLogout => 'Wyloguj się';

  @override
  String get appearanceAndExperience => 'Wygląd i działanie';

  @override
  String get privacyAndSecurity => 'Prywatność i bezpieczeństwo';

  @override
  String get pinLock => 'Blokada PIN';

  @override
  String get biometricUnlock => 'Odblokowanie biometryczne';

  @override
  String get enablePinFirst => 'Najpierw włącz blokadę PIN';

  @override
  String get account => 'Konto';

  @override
  String get pleaseEnablePinFirst => 'Proszę najpierw włączyć blokadę PIN';

  @override
  String get biometricNotSupported => 'Biometria nieobsługiwana lub wyłączona';

  @override
  String get enterEmailAndPassword => 'Wprowadź e-mail i hasło';

  @override
  String get emailLabel => 'Adres e-mail';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get autoLogin => 'Automatyczne logowanie';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get loginButton => 'Zaloguj się';

  @override
  String get noAccount => 'Nie masz konta?';

  @override
  String get registerNow => 'Zarejestruj się teraz';

  @override
  String get registerTitle => 'Rejestracja';

  @override
  String get confirmPasswordLabel => 'Potwierdź hasło';

  @override
  String get passwordsDoNotMatch => 'Hasła nie pasują do siebie';

  @override
  String get registerSuccess => 'Rejestracja zakończona sukcesem';

  @override
  String registerFailed(Object error) {
    return 'Rejestracja nie powiodła się: $error';
  }

  @override
  String get newDiaryTitle => 'Nowy wpis';

  @override
  String get editDiaryTitle => 'Edytuj wpis';

  @override
  String get saveButton => 'Zapisz';

  @override
  String get titleHint => 'Tytuł';

  @override
  String get contentHint => 'Napisz coś o dzisiejszym dniu...';

  @override
  String get moodLabel => 'Nastrój';

  @override
  String get tagsLabel => 'Tagi';

  @override
  String get selectDate => 'Wybierz datę';

  @override
  String get pleaseEnterContent => 'Proszę wprowadzić treść';

  @override
  String get diaryDetailTitle => 'Szczegóły wpisu';

  @override
  String get editAction => 'Edytuj';

  @override
  String get deleteAction => 'Usuń';

  @override
  String get shareAction => 'Udostępnij';

  @override
  String get statisticsTitle => 'Statystyki';

  @override
  String get moodChartTitle => 'Trend nastroju';

  @override
  String get diaryCountTitle => 'Łącznie wpisów';

  @override
  String get moodDistribution => 'Rozkład nastroju';

  @override
  String get enterPinTitle => 'Wprowadź PIN';

  @override
  String get setPinTitle => 'Ustaw PIN';

  @override
  String get confirmPinTitle => 'Potwierdź PIN';

  @override
  String get pinIncorrect => 'Nieprawidłowy PIN';

  @override
  String get pinNotMatch => 'PIN-y nie pasują do siebie';

  @override
  String get pinSetSuccess => 'PIN ustawiony pomyślnie';

  @override
  String get unlockTitle => 'Odblokuj aplikację';

  @override
  String get weatherLabel => 'Pogoda';

  @override
  String get weatherSunny => 'Słonecznie';

  @override
  String get weatherCloudy => 'Pochmurno';

  @override
  String get weatherRainy => 'Deszczowo';

  @override
  String get weatherSnowy => 'Śnieżnie';

  @override
  String get weatherThunder => 'Burzowo';

  @override
  String get weatherWindy => 'Wietrznie';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';
}
