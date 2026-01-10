// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مذكراتي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get appLock => 'قفل التطبيق';

  @override
  String get deleteSuccess => 'تم الحذف بنجاح';

  @override
  String get filterByTag => 'تصفية حسب الوسم';

  @override
  String get tagLife => 'حياة';

  @override
  String get tagWork => 'عمل';

  @override
  String get tagTravel => 'سفر';

  @override
  String get tagMood => 'مزاج';

  @override
  String get tagFood => 'طعام';

  @override
  String get tagStudy => 'دراسة';

  @override
  String get tapAgainToExit => 'اضغط مرة أخرى للخروج';

  @override
  String get selected => 'محدد';

  @override
  String get searchHint => 'بحث في المذكرات...';

  @override
  String get noDiariesFound => 'لا توجد مذكرات';

  @override
  String get logoutConfirmation =>
      'هل أنت متأكد أنك تريد تسجيل الخروج؟\nسيتعين عليك تسجيل الدخول مرة أخرى في المرة القادمة.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirmLogout => 'خروج';

  @override
  String get appearanceAndExperience => 'المظهر والتجربة';

  @override
  String get privacyAndSecurity => 'الخصوصية والأمان';

  @override
  String get pinLock => 'قفل PIN';

  @override
  String get biometricUnlock => 'فتح بالقفل الحيوي';

  @override
  String get enablePinFirst => 'قم بتمكين قفل PIN أولاً';

  @override
  String get account => 'الحساب';

  @override
  String get pleaseEnablePinFirst => 'يرجى تمكين قفل PIN أولاً';

  @override
  String get biometricNotSupported =>
      'المصادقة الحيوية غير مدعومة أو غير مفعلة';

  @override
  String get enterEmailAndPassword =>
      'يرجى إدخال البريد الإلكتروني وكلمة المرور';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get autoLogin => 'دخول تلقائي';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get loginButton => 'دخول';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get registerNow => 'سجل الآن';

  @override
  String get registerTitle => 'تسجيل';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get registerSuccess => 'تم التسجيل بنجاح';

  @override
  String registerFailed(Object error) {
    return 'فشل التسجيل: $error';
  }

  @override
  String get newDiaryTitle => 'مذكرة جديدة';

  @override
  String get editDiaryTitle => 'تعديل المذكرة';

  @override
  String get saveButton => 'حفظ';

  @override
  String get titleHint => 'العنوان';

  @override
  String get contentHint => 'اكتب شيئاً عن اليوم...';

  @override
  String get moodLabel => 'المزاج';

  @override
  String get tagsLabel => 'الوسوم';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get pleaseEnterContent => 'يرجى إدخال المحتوى';

  @override
  String get diaryDetailTitle => 'تفاصيل المذكرة';

  @override
  String get editAction => 'تعديل';

  @override
  String get deleteAction => 'حذف';

  @override
  String get shareAction => 'مشاركة';

  @override
  String get statisticsTitle => 'الإحصائيات';

  @override
  String get moodChartTitle => 'اتجاه المزاج';

  @override
  String get diaryCountTitle => 'إجمالي المذكرات';

  @override
  String get moodDistribution => 'توزيع المزاج';

  @override
  String get enterPinTitle => 'أدخل PIN';

  @override
  String get setPinTitle => 'تعيين PIN';

  @override
  String get confirmPinTitle => 'تأكيد PIN';

  @override
  String get pinIncorrect => 'الرمز غير صحيح';

  @override
  String get pinNotMatch => 'الرموز غير متطابقة';

  @override
  String get pinSetSuccess => 'تم تعيين PIN بنجاح';

  @override
  String get unlockTitle => 'فتح التطبيق';

  @override
  String get weatherLabel => 'الطقس';

  @override
  String get weatherSunny => 'مشمس';

  @override
  String get weatherCloudy => 'غائم';

  @override
  String get weatherRainy => 'مطر';

  @override
  String get weatherSnowy => 'مثلج';

  @override
  String get weatherThunder => 'عاصف';

  @override
  String get weatherWindy => 'رياح';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
