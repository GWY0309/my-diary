// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Diari Saya';

  @override
  String get settings => 'Pengaturan';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get login => 'Masuk';

  @override
  String get logout => 'Keluar';

  @override
  String get appLock => 'Kunci Aplikasi';

  @override
  String get deleteSuccess => 'Berhasil dihapus';

  @override
  String get filterByTag => 'Filter berdasarkan Tag';

  @override
  String get tagLife => 'Kehidupan';

  @override
  String get tagWork => 'Pekerjaan';

  @override
  String get tagTravel => 'Perjalanan';

  @override
  String get tagMood => 'Suasana Hati';

  @override
  String get tagFood => 'Makanan';

  @override
  String get tagStudy => 'Belajar';

  @override
  String get tapAgainToExit => 'Ketuk lagi untuk keluar';

  @override
  String get selected => 'Dipilih';

  @override
  String get searchHint => 'Cari diari...';

  @override
  String get noDiariesFound => 'Tidak ada diari ditemukan';

  @override
  String get logoutConfirmation =>
      'Apakah Anda yakin ingin keluar?\nAnda harus masuk lagi nanti.';

  @override
  String get cancel => 'Batal';

  @override
  String get confirmLogout => 'Keluar';

  @override
  String get appearanceAndExperience => 'Tampilan dan Pengalaman';

  @override
  String get privacyAndSecurity => 'Privasi dan Keamanan';

  @override
  String get pinLock => 'Kunci PIN';

  @override
  String get biometricUnlock => 'Buka Kunci Biometrik';

  @override
  String get enablePinFirst => 'Aktifkan kunci PIN terlebih dahulu';

  @override
  String get account => 'Akun';

  @override
  String get pleaseEnablePinFirst => 'Harap aktifkan kunci PIN terlebih dahulu';

  @override
  String get biometricNotSupported =>
      'Biometrik tidak didukung atau tidak aktif';

  @override
  String get enterEmailAndPassword => 'Harap masukkan email dan kata sandi';

  @override
  String get emailLabel => 'Alamat Email';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get autoLogin => 'Masuk Otomatis';

  @override
  String get forgotPassword => 'Lupa Kata Sandi?';

  @override
  String get loginButton => 'Masuk';

  @override
  String get noAccount => 'Belum punya akun?';

  @override
  String get registerNow => 'Daftar Sekarang';

  @override
  String get registerTitle => 'Daftar';

  @override
  String get confirmPasswordLabel => 'Konfirmasi Kata Sandi';

  @override
  String get passwordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get registerSuccess => 'Pendaftaran berhasil';

  @override
  String registerFailed(Object error) {
    return 'Pendaftaran gagal: $error';
  }

  @override
  String get newDiaryTitle => 'Diari Baru';

  @override
  String get editDiaryTitle => 'Edit Diari';

  @override
  String get saveButton => 'Simpan';

  @override
  String get titleHint => 'Judul';

  @override
  String get contentHint => 'Tulis sesuatu tentang hari ini...';

  @override
  String get moodLabel => 'Mood';

  @override
  String get tagsLabel => 'Tag';

  @override
  String get selectDate => 'Pilih Tanggal';

  @override
  String get pleaseEnterContent => 'Harap masukkan konten';

  @override
  String get diaryDetailTitle => 'Detail Diari';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Hapus';

  @override
  String get shareAction => 'Bagikan';

  @override
  String get statisticsTitle => 'Statistik';

  @override
  String get moodChartTitle => 'Tren Mood';

  @override
  String get diaryCountTitle => 'Total Diari';

  @override
  String get moodDistribution => 'Distribusi Mood';

  @override
  String get enterPinTitle => 'Masukkan PIN';

  @override
  String get setPinTitle => 'Atur PIN';

  @override
  String get confirmPinTitle => 'Konfirmasi PIN';

  @override
  String get pinIncorrect => 'PIN salah';

  @override
  String get pinNotMatch => 'PIN tidak cocok';

  @override
  String get pinSetSuccess => 'PIN berhasil diatur';

  @override
  String get unlockTitle => 'Buka Kunci Aplikasi';

  @override
  String get weatherLabel => 'Cuaca';

  @override
  String get weatherSunny => 'Cerah';

  @override
  String get weatherCloudy => 'Berawan';

  @override
  String get weatherRainy => 'Hujan';

  @override
  String get weatherSnowy => 'Salju';

  @override
  String get weatherThunder => 'Badai';

  @override
  String get weatherWindy => 'Berangin';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
