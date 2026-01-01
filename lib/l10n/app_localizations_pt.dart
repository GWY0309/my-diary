// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Meu Diário';

  @override
  String get settings => 'Configurações';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get login => 'Entrar';

  @override
  String get logout => 'Sair';

  @override
  String get appLock => 'Bloqueio do App';

  @override
  String get deleteSuccess => 'Excluído com sucesso';

  @override
  String get filterByTag => 'Filtrar por Tag';

  @override
  String get tagLife => 'Vida';

  @override
  String get tagWork => 'Trabalho';

  @override
  String get tagTravel => 'Viagem';

  @override
  String get tagMood => 'Humor';

  @override
  String get tagFood => 'Comida';

  @override
  String get tagStudy => 'Estudo';

  @override
  String get tapAgainToExit => 'Toque novamente para sair';

  @override
  String get selected => 'Selecionado';

  @override
  String get searchHint => 'Pesquisar diários...';

  @override
  String get noDiariesFound => 'Nenhum diário encontrado';

  @override
  String get logoutConfirmation =>
      'Tem certeza que deseja sair?\nVocê precisará fazer login novamente.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirmLogout => 'Sair';

  @override
  String get appearanceAndExperience => 'Aparência e Experiência';

  @override
  String get privacyAndSecurity => 'Privacidade e Segurança';

  @override
  String get pinLock => 'Bloqueio por PIN';

  @override
  String get biometricUnlock => 'Desbloqueio Biométrico';

  @override
  String get enablePinFirst => 'Ative o bloqueio por PIN primeiro';

  @override
  String get account => 'Conta';

  @override
  String get pleaseEnablePinFirst =>
      'Por favor, ative o bloqueio por PIN primeiro';

  @override
  String get biometricNotSupported => 'Biometria não suportada ou não ativada';

  @override
  String get enterEmailAndPassword => 'Por favor, insira e-mail e senha';

  @override
  String get emailLabel => 'Endereço de E-mail';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get autoLogin => 'Login Automático';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get loginButton => 'Entrar';

  @override
  String get noAccount => 'Não tem uma conta?';

  @override
  String get registerNow => 'Registre-se Agora';

  @override
  String get registerTitle => 'Registrar';

  @override
  String get confirmPasswordLabel => 'Confirmar Senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get registerSuccess => 'Registro realizado com sucesso';

  @override
  String registerFailed(Object error) {
    return 'Falha no registro: $error';
  }

  @override
  String get newDiaryTitle => 'Novo Diário';

  @override
  String get editDiaryTitle => 'Editar Diário';

  @override
  String get saveButton => 'Salvar';

  @override
  String get titleHint => 'Título';

  @override
  String get contentHint => 'Escreva algo sobre hoje...';

  @override
  String get moodLabel => 'Humor';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get selectDate => 'Selecionar Data';

  @override
  String get pleaseEnterContent => 'Por favor, insira o conteúdo';

  @override
  String get diaryDetailTitle => 'Detalhes do Diário';

  @override
  String get editAction => 'Editar';

  @override
  String get deleteAction => 'Excluir';

  @override
  String get shareAction => 'Compartilhar';

  @override
  String get statisticsTitle => 'Estatísticas';

  @override
  String get moodChartTitle => 'Tendência de Humor';

  @override
  String get diaryCountTitle => 'Total de Diários';

  @override
  String get moodDistribution => 'Distribuição de Humor';

  @override
  String get enterPinTitle => 'Digite o PIN';

  @override
  String get setPinTitle => 'Definir PIN';

  @override
  String get confirmPinTitle => 'Confirmar PIN';

  @override
  String get pinIncorrect => 'PIN incorreto';

  @override
  String get pinNotMatch => 'Os PINs não coincidem';

  @override
  String get pinSetSuccess => 'PIN definido com sucesso';

  @override
  String get unlockTitle => 'Desbloquear App';

  @override
  String get weatherLabel => 'Clima';

  @override
  String get weatherSunny => 'Ensolarado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherRainy => 'Chuvoso';

  @override
  String get weatherSnowy => 'Nevando';

  @override
  String get weatherThunder => 'Tempestade';

  @override
  String get weatherWindy => 'Ventoso';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecione o Idioma';
}
