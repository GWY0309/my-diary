// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Mon Journal';

  @override
  String get settings => 'Paramètres';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get appLock => 'Verrouillage App';

  @override
  String get deleteSuccess => 'Supprimé avec succès';

  @override
  String get filterByTag => 'Filtrer par tag';

  @override
  String get tagLife => 'Vie';

  @override
  String get tagWork => 'Travail';

  @override
  String get tagTravel => 'Voyage';

  @override
  String get tagMood => 'Humeur';

  @override
  String get tagFood => 'Nourriture';

  @override
  String get tagStudy => 'Études';

  @override
  String get tapAgainToExit => 'Appuyez encore pour quitter';

  @override
  String get selected => 'Sélectionné';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get noDiariesFound => 'Aucun journal trouvé';

  @override
  String get logoutConfirmation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?\nVous devrez vous reconnecter la prochaine fois.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirmLogout => 'Se déconnecter';

  @override
  String get appearanceAndExperience => 'Apparence et Expérience';

  @override
  String get privacyAndSecurity => 'Confidentialité et Sécurité';

  @override
  String get pinLock => 'Verrouillage PIN';

  @override
  String get biometricUnlock => 'Déverrouillage Biométrique';

  @override
  String get enablePinFirst => 'Activez d\'abord le code PIN';

  @override
  String get account => 'Compte';

  @override
  String get pleaseEnablePinFirst => 'Veuillez d\'abord activer le code PIN';

  @override
  String get biometricNotSupported => 'Biométrie non supportée ou non activée';

  @override
  String get enterEmailAndPassword =>
      'Veuillez entrer l\'email et le mot de passe';

  @override
  String get emailLabel => 'Adresse Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get autoLogin => 'Connexion auto';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get noAccount => 'Pas de compte ?';

  @override
  String get registerNow => 'S\'inscrire';

  @override
  String get registerTitle => 'Inscription';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get registerSuccess => 'Inscription réussie';

  @override
  String registerFailed(Object error) {
    return 'Échec de l\'inscription : $error';
  }

  @override
  String get newDiaryTitle => 'Nouveau Journal';

  @override
  String get editDiaryTitle => 'Modifier le Journal';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get titleHint => 'Titre';

  @override
  String get contentHint => 'Écrivez quelque chose aujourd\'hui...';

  @override
  String get moodLabel => 'Humeur';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get selectDate => 'Choisir une date';

  @override
  String get pleaseEnterContent => 'Veuillez entrer du contenu';

  @override
  String get diaryDetailTitle => 'Détail du Journal';

  @override
  String get editAction => 'Modifier';

  @override
  String get deleteAction => 'Supprimer';

  @override
  String get shareAction => 'Partager';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get moodChartTitle => 'Tendance d\'humeur';

  @override
  String get diaryCountTitle => 'Total Journaux';

  @override
  String get moodDistribution => 'Distribution d\'humeur';

  @override
  String get enterPinTitle => 'Entrer le PIN';

  @override
  String get setPinTitle => 'Définir le PIN';

  @override
  String get confirmPinTitle => 'Confirmer le PIN';

  @override
  String get pinIncorrect => 'PIN incorrect';

  @override
  String get pinNotMatch => 'Les PIN ne correspondent pas';

  @override
  String get pinSetSuccess => 'PIN défini avec succès';

  @override
  String get unlockTitle => 'Déverrouiller l\'App';

  @override
  String get weatherLabel => 'Météo';

  @override
  String get weatherSunny => 'Ensoleillé';

  @override
  String get weatherCloudy => 'Nuageux';

  @override
  String get weatherRainy => 'Pluvieux';

  @override
  String get weatherSnowy => 'Neigeux';

  @override
  String get weatherThunder => 'Orageux';

  @override
  String get weatherWindy => 'Venteux';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';
}
