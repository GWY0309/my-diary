// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'خاطرات من';

  @override
  String get settings => 'تنظیمات';

  @override
  String get darkMode => 'حالت تاریک';

  @override
  String get login => 'ورود';

  @override
  String get logout => 'خروج';

  @override
  String get appLock => 'قفل برنامه';

  @override
  String get deleteSuccess => 'با موفقیت حذف شد';

  @override
  String get filterByTag => 'فیلتر بر اساس تگ';

  @override
  String get tagLife => 'زندگی';

  @override
  String get tagWork => 'کار';

  @override
  String get tagTravel => 'سفر';

  @override
  String get tagMood => 'حال و هوا';

  @override
  String get tagFood => 'غذا';

  @override
  String get tagStudy => 'مطالعه';

  @override
  String get tapAgainToExit => 'برای خروج دوباره ضربه بزنید';

  @override
  String get selected => 'انتخاب شده';

  @override
  String get searchHint => 'جستجوی خاطرات...';

  @override
  String get noDiariesFound => 'هیچ خاطره‌ای پیدا نشد';

  @override
  String get logoutConfirmation =>
      'آیا مطمئن هستید که می‌خواهید خارج شوید؟\nدفعه بعد باید دوباره وارد شوید.';

  @override
  String get cancel => 'لغو';

  @override
  String get confirmLogout => 'خروج';

  @override
  String get appearanceAndExperience => 'ظاهر و تجربه';

  @override
  String get privacyAndSecurity => 'حریم خصوصی و امنیت';

  @override
  String get pinLock => 'قفل پین';

  @override
  String get biometricUnlock => 'بازگشایی با بیومتریک';

  @override
  String get enablePinFirst => 'ابتدا قفل پین را فعال کنید';

  @override
  String get account => 'حساب کاربری';

  @override
  String get pleaseEnablePinFirst => 'لطفاً ابتدا قفل پین را فعال کنید';

  @override
  String get biometricNotSupported => 'بیومتریک پشتیبانی نمی‌شود یا فعال نیست';

  @override
  String get enterEmailAndPassword => 'لطفاً ایمیل و رمز عبور را وارد کنید';

  @override
  String get emailLabel => 'آدرس ایمیل';

  @override
  String get passwordLabel => 'رمز عبور';

  @override
  String get autoLogin => 'ورود خودکار';

  @override
  String get forgotPassword => 'رمز عبور را فراموش کرده‌اید؟';

  @override
  String get loginButton => 'ورود';

  @override
  String get noAccount => 'حساب کاربری ندارید؟';

  @override
  String get registerNow => 'ثبت‌نام کنید';

  @override
  String get registerTitle => 'ثبت‌نام';

  @override
  String get confirmPasswordLabel => 'تایید رمز عبور';

  @override
  String get passwordsDoNotMatch => 'رمزهای عبور مطابقت ندارند';

  @override
  String get registerSuccess => 'ثبت‌نام موفقیت‌آمیز بود';

  @override
  String registerFailed(Object error) {
    return 'ثبت‌نام ناموفق بود: $error';
  }

  @override
  String get newDiaryTitle => 'خاطره جدید';

  @override
  String get editDiaryTitle => 'ویرایش خاطره';

  @override
  String get saveButton => 'ذخیره';

  @override
  String get titleHint => 'عنوان';

  @override
  String get contentHint => 'چیزی درباره امروز بنویسید...';

  @override
  String get moodLabel => 'حال و هوا';

  @override
  String get tagsLabel => 'تگ‌ها';

  @override
  String get selectDate => 'انتخاب تاریخ';

  @override
  String get pleaseEnterContent => 'لطفاً محتوا را وارد کنید';

  @override
  String get diaryDetailTitle => 'جزئیات خاطره';

  @override
  String get editAction => 'ویرایش';

  @override
  String get deleteAction => 'حذف';

  @override
  String get shareAction => 'اشتراک‌گذاری';

  @override
  String get statisticsTitle => 'آمار';

  @override
  String get moodChartTitle => 'روند حال و هوا';

  @override
  String get diaryCountTitle => 'کل خاطرات';

  @override
  String get moodDistribution => 'توزیع حال و هوا';

  @override
  String get enterPinTitle => 'پین را وارد کنید';

  @override
  String get setPinTitle => 'تنظیم پین';

  @override
  String get confirmPinTitle => 'تایید پین';

  @override
  String get pinIncorrect => 'پین نادرست است';

  @override
  String get pinNotMatch => 'پین‌ها مطابقت ندارند';

  @override
  String get pinSetSuccess => 'پین با موفقیت تنظیم شد';

  @override
  String get unlockTitle => 'باز کردن قفل برنامه';

  @override
  String get weatherLabel => 'آب و هوا';

  @override
  String get weatherSunny => 'آفتابی';

  @override
  String get weatherCloudy => 'ابری';

  @override
  String get weatherRainy => 'بارانی';

  @override
  String get weatherSnowy => 'برفی';

  @override
  String get weatherThunder => 'طوفانی';

  @override
  String get weatherWindy => 'بادی';

  @override
  String get language => 'زبان';

  @override
  String get selectLanguage => 'انتخاب زبان';
}
