// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Diario';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get appLock => 'Bloqueo de App';

  @override
  String get deleteSuccess => 'Eliminado con éxito';

  @override
  String get filterByTag => 'Filtrar por etiqueta';

  @override
  String get tagLife => 'Vida';

  @override
  String get tagWork => 'Trabajo';

  @override
  String get tagTravel => 'Viaje';

  @override
  String get tagMood => 'Ánimo';

  @override
  String get tagFood => 'Comida';

  @override
  String get tagStudy => 'Estudio';

  @override
  String get tapAgainToExit => 'Toque de nuevo para salir';

  @override
  String get selected => 'Seleccionado';

  @override
  String get searchHint => 'Buscar diarios...';

  @override
  String get noDiariesFound => 'No se encontraron diarios';

  @override
  String get logoutConfirmation =>
      '¿Seguro que quieres cerrar sesión?\nTendrás que iniciar sesión de nuevo la próxima vez.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirmLogout => 'Salir';

  @override
  String get appearanceAndExperience => 'Apariencia y Experiencia';

  @override
  String get privacyAndSecurity => 'Privacidad y Seguridad';

  @override
  String get pinLock => 'Bloqueo PIN';

  @override
  String get biometricUnlock => 'Desbloqueo Biométrico';

  @override
  String get enablePinFirst => 'Habilite primero el bloqueo PIN';

  @override
  String get account => 'Cuenta';

  @override
  String get pleaseEnablePinFirst =>
      'Por favor, habilite primero el bloqueo PIN';

  @override
  String get biometricNotSupported => 'Biometría no soportada o no habilitada';

  @override
  String get enterEmailAndPassword => 'Por favor ingrese correo y contraseña';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get autoLogin => 'Inicio Automático';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get loginButton => 'Entrar';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get registerNow => 'Regístrate Ahora';

  @override
  String get registerTitle => 'Registrarse';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get registerSuccess => 'Registro exitoso';

  @override
  String registerFailed(Object error) {
    return 'Registro fallido: $error';
  }

  @override
  String get newDiaryTitle => 'Nuevo Diario';

  @override
  String get editDiaryTitle => 'Editar Diario';

  @override
  String get saveButton => 'Guardar';

  @override
  String get titleHint => 'Título';

  @override
  String get contentHint => 'Escribe algo hoy...';

  @override
  String get moodLabel => 'Ánimo';

  @override
  String get tagsLabel => 'Etiquetas';

  @override
  String get selectDate => 'Seleccionar Fecha';

  @override
  String get pleaseEnterContent => 'Por favor ingrese contenido';

  @override
  String get diaryDetailTitle => 'Detalle del Diario';

  @override
  String get editAction => 'Editar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get shareAction => 'Compartir';

  @override
  String get statisticsTitle => 'Estadísticas';

  @override
  String get moodChartTitle => 'Tendencia de Ánimo';

  @override
  String get diaryCountTitle => 'Total de Diarios';

  @override
  String get moodDistribution => 'Distribución de Ánimo';

  @override
  String get enterPinTitle => 'Ingresar PIN';

  @override
  String get setPinTitle => 'Configurar PIN';

  @override
  String get confirmPinTitle => 'Confirmar PIN';

  @override
  String get pinIncorrect => 'PIN incorrecto';

  @override
  String get pinNotMatch => 'Los PIN no coinciden';

  @override
  String get pinSetSuccess => 'PIN configurado con éxito';

  @override
  String get unlockTitle => 'Desbloquear App';

  @override
  String get weatherLabel => 'Clima';

  @override
  String get weatherSunny => 'Soleado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherRainy => 'Lluvioso';

  @override
  String get weatherSnowy => 'Nevado';

  @override
  String get weatherThunder => 'Tormenta';

  @override
  String get weatherWindy => 'Ventoso';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';
}
