// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Мой Дневник';

  @override
  String get settings => 'Настройки';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get appLock => 'Блокировка';

  @override
  String get deleteSuccess => 'Успешно удалено';

  @override
  String get filterByTag => 'Фильтр по тегам';

  @override
  String get tagLife => 'Жизнь';

  @override
  String get tagWork => 'Работа';

  @override
  String get tagTravel => 'Путешествия';

  @override
  String get tagMood => 'Настроение';

  @override
  String get tagFood => 'Еда';

  @override
  String get tagStudy => 'Учёба';

  @override
  String get tapAgainToExit => 'Нажмите ещё раз для выхода';

  @override
  String get selected => 'Выбрано';

  @override
  String get searchHint => 'Поиск дневников...';

  @override
  String get noDiariesFound => 'Дневники не найдены';

  @override
  String get logoutConfirmation =>
      'Вы уверены, что хотите выйти?\nВам придется войти снова.';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirmLogout => 'Выйти';

  @override
  String get appearanceAndExperience => 'Внешний вид';

  @override
  String get privacyAndSecurity => 'Конфиденциальность';

  @override
  String get pinLock => 'PIN-код';

  @override
  String get biometricUnlock => 'Биометрия';

  @override
  String get enablePinFirst => 'Сначала включите PIN-код';

  @override
  String get account => 'Аккаунт';

  @override
  String get pleaseEnablePinFirst => 'Пожалуйста, сначала включите PIN-код';

  @override
  String get biometricNotSupported =>
      'Биометрия не поддерживается или выключена';

  @override
  String get enterEmailAndPassword => 'Введите email и пароль';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get autoLogin => 'Автоматический вход';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get loginButton => 'Войти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get registerNow => 'Регистрация';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get registerSuccess => 'Регистрация успешна';

  @override
  String registerFailed(Object error) {
    return 'Ошибка регистрации: $error';
  }

  @override
  String get newDiaryTitle => 'Новая запись';

  @override
  String get editDiaryTitle => 'Редактировать';

  @override
  String get saveButton => 'Сохранить';

  @override
  String get titleHint => 'Заголовок';

  @override
  String get contentHint => 'Напишите что-нибудь...';

  @override
  String get moodLabel => 'Настроение';

  @override
  String get tagsLabel => 'Теги';

  @override
  String get selectDate => 'Выбрать дату';

  @override
  String get pleaseEnterContent => 'Пожалуйста, введите текст';

  @override
  String get diaryDetailTitle => 'Детали';

  @override
  String get editAction => 'Изменить';

  @override
  String get deleteAction => 'Удалить';

  @override
  String get shareAction => 'Поделиться';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get moodChartTitle => 'Тренд настроения';

  @override
  String get diaryCountTitle => 'Всего записей';

  @override
  String get moodDistribution => 'Распределение настроения';

  @override
  String get enterPinTitle => 'Введите PIN';

  @override
  String get setPinTitle => 'Установить PIN';

  @override
  String get confirmPinTitle => 'Подтвердите PIN';

  @override
  String get pinIncorrect => 'Неверный PIN';

  @override
  String get pinNotMatch => 'PIN-коды не совпадают';

  @override
  String get pinSetSuccess => 'PIN успешно установлен';

  @override
  String get unlockTitle => 'Разблокировать';

  @override
  String get weatherLabel => 'Погода';

  @override
  String get weatherSunny => 'Солнечно';

  @override
  String get weatherCloudy => 'Облачно';

  @override
  String get weatherRainy => 'Дождливо';

  @override
  String get weatherSnowy => 'Снежно';

  @override
  String get weatherThunder => 'Гроза';

  @override
  String get weatherWindy => 'Ветрено';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выберите язык';
}
