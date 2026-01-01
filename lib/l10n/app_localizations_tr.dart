// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Günlüğüm';

  @override
  String get settings => 'Ayarlar';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get login => 'Giriş Yap';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get appLock => 'Uygulama Kilidi';

  @override
  String get deleteSuccess => 'Başarıyla silindi';

  @override
  String get filterByTag => 'Etikete Göre Filtrele';

  @override
  String get tagLife => 'Yaşam';

  @override
  String get tagWork => 'İş';

  @override
  String get tagTravel => 'Seyahat';

  @override
  String get tagMood => 'Ruh Hali';

  @override
  String get tagFood => 'Yemek';

  @override
  String get tagStudy => 'Ders';

  @override
  String get tapAgainToExit => 'Çıkmak için tekrar dokunun';

  @override
  String get selected => 'Seçildi';

  @override
  String get searchHint => 'Günlük ara...';

  @override
  String get noDiariesFound => 'Günlük bulunamadı';

  @override
  String get logoutConfirmation =>
      'Çıkış yapmak istediğinize emin misiniz?\nBir dahaki sefere tekrar giriş yapmanız gerekecek.';

  @override
  String get cancel => 'İptal';

  @override
  String get confirmLogout => 'Çıkış';

  @override
  String get appearanceAndExperience => 'Görünüm ve Deneyim';

  @override
  String get privacyAndSecurity => 'Gizlilik ve Güvenlik';

  @override
  String get pinLock => 'PIN Kilidi';

  @override
  String get biometricUnlock => 'Biyometrik Kilit Açma';

  @override
  String get enablePinFirst => 'Önce PIN kilidini etkinleştirin';

  @override
  String get account => 'Hesap';

  @override
  String get pleaseEnablePinFirst => 'Lütfen önce PIN kilidini etkinleştirin';

  @override
  String get biometricNotSupported =>
      'Biyometri desteklenmiyor veya etkin değil';

  @override
  String get enterEmailAndPassword => 'Lütfen e-posta ve şifre girin';

  @override
  String get emailLabel => 'E-posta Adresi';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get autoLogin => 'Otomatik Giriş';

  @override
  String get forgotPassword => 'Şifrenizi mi unuttunuz?';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get noAccount => 'Hesabınız yok mu?';

  @override
  String get registerNow => 'Şimdi Kayıt Ol';

  @override
  String get registerTitle => 'Kayıt Ol';

  @override
  String get confirmPasswordLabel => 'Şifreyi Onayla';

  @override
  String get passwordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get registerSuccess => 'Kayıt başarılı';

  @override
  String registerFailed(Object error) {
    return 'Kayıt başarısız: $error';
  }

  @override
  String get newDiaryTitle => 'Yeni Günlük';

  @override
  String get editDiaryTitle => 'Günlüğü Düzenle';

  @override
  String get saveButton => 'Kaydet';

  @override
  String get titleHint => 'Başlık';

  @override
  String get contentHint => 'Bugün hakkında bir şeyler yaz...';

  @override
  String get moodLabel => 'Ruh Hali';

  @override
  String get tagsLabel => 'Etiketler';

  @override
  String get selectDate => 'Tarih Seç';

  @override
  String get pleaseEnterContent => 'Lütfen içerik girin';

  @override
  String get diaryDetailTitle => 'Günlük Detayı';

  @override
  String get editAction => 'Düzenle';

  @override
  String get deleteAction => 'Sil';

  @override
  String get shareAction => 'Paylaş';

  @override
  String get statisticsTitle => 'İstatistikler';

  @override
  String get moodChartTitle => 'Ruh Hali Trendi';

  @override
  String get diaryCountTitle => 'Toplam Günlük';

  @override
  String get moodDistribution => 'Ruh Hali Dağılımı';

  @override
  String get enterPinTitle => 'PIN Girin';

  @override
  String get setPinTitle => 'PIN Ayarla';

  @override
  String get confirmPinTitle => 'PIN Onayla';

  @override
  String get pinIncorrect => 'Yanlış PIN';

  @override
  String get pinNotMatch => 'PIN\'ler eşleşmiyor';

  @override
  String get pinSetSuccess => 'PIN başarıyla ayarlandı';

  @override
  String get unlockTitle => 'Uygulamanın Kilidini Aç';

  @override
  String get weatherLabel => 'Hava Durumu';

  @override
  String get weatherSunny => 'Güneşli';

  @override
  String get weatherCloudy => 'Bulutlu';

  @override
  String get weatherRainy => 'Yağmurlu';

  @override
  String get weatherSnowy => 'Karlı';

  @override
  String get weatherThunder => 'Fırtınalı';

  @override
  String get weatherWindy => 'Rüzgarlı';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seçin';
}
