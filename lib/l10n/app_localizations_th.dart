// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'บันทึกของฉัน';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get appLock => 'ล็อคแอป';

  @override
  String get deleteSuccess => 'ลบสำเร็จ';

  @override
  String get filterByTag => 'กรองตามแท็ก';

  @override
  String get tagLife => 'ชีวิต';

  @override
  String get tagWork => 'งาน';

  @override
  String get tagTravel => 'ท่องเที่ยว';

  @override
  String get tagMood => 'อารมณ์';

  @override
  String get tagFood => 'อาหาร';

  @override
  String get tagStudy => 'การเรียน';

  @override
  String get tapAgainToExit => 'แตะอีกครั้งเพื่อออก';

  @override
  String get selected => 'เลือกแล้ว';

  @override
  String get searchHint => 'ค้นหาบันทึก...';

  @override
  String get noDiariesFound => 'ไม่พบบันทึก';

  @override
  String get logoutConfirmation =>
      'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?\nคุณจะต้องเข้าสู่ระบบใหม่ในครั้งถัดไป';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get confirmLogout => 'ออก';

  @override
  String get appearanceAndExperience => 'รูปลักษณ์และประสบการณ์';

  @override
  String get privacyAndSecurity => 'ความเป็นส่วนตัวและความปลอดภัย';

  @override
  String get pinLock => 'ล็อคด้วย PIN';

  @override
  String get biometricUnlock => 'ปลดล็อคด้วยชีวมาตร';

  @override
  String get enablePinFirst => 'เปิดใช้งานล็อค PIN ก่อน';

  @override
  String get account => 'บัญชี';

  @override
  String get pleaseEnablePinFirst => 'กรุณาเปิดใช้งานล็อค PIN ก่อน';

  @override
  String get biometricNotSupported => 'ไม่รองรับชีวมาตรหรือไม่ได้เปิดใช้งาน';

  @override
  String get enterEmailAndPassword => 'กรุณากรอกอีเมลและรหัสผ่าน';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get autoLogin => 'เข้าสู่ระบบอัตโนมัติ';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String get noAccount => 'ยังไม่มีบัญชี?';

  @override
  String get registerNow => 'ลงทะเบียนเลย';

  @override
  String get registerTitle => 'ลงทะเบียน';

  @override
  String get confirmPasswordLabel => 'ยืนยันรหัสผ่าน';

  @override
  String get passwordsDoNotMatch => 'รหัสผ่านไม่ตรงกัน';

  @override
  String get registerSuccess => 'ลงทะเบียนสำเร็จ';

  @override
  String registerFailed(Object error) {
    return 'ลงทะเบียนล้มเหลว: $error';
  }

  @override
  String get newDiaryTitle => 'บันทึกใหม่';

  @override
  String get editDiaryTitle => 'แก้ไขบันทึก';

  @override
  String get saveButton => 'บันทึก';

  @override
  String get titleHint => 'หัวข้อ';

  @override
  String get contentHint => 'เขียนบางอย่างเกี่ยวกับวันนี้...';

  @override
  String get moodLabel => 'อารมณ์';

  @override
  String get tagsLabel => 'แท็ก';

  @override
  String get selectDate => 'เลือกวันที่';

  @override
  String get pleaseEnterContent => 'กรุณากรอกเนื้อหา';

  @override
  String get diaryDetailTitle => 'รายละเอียดบันทึก';

  @override
  String get editAction => 'แก้ไข';

  @override
  String get deleteAction => 'ลบ';

  @override
  String get shareAction => 'แชร์';

  @override
  String get statisticsTitle => 'สถิติ';

  @override
  String get moodChartTitle => 'แนวโน้มอารมณ์';

  @override
  String get diaryCountTitle => 'บันทึกทั้งหมด';

  @override
  String get moodDistribution => 'การกระจายของอารมณ์';

  @override
  String get enterPinTitle => 'ใส่ PIN';

  @override
  String get setPinTitle => 'ตั้งค่า PIN';

  @override
  String get confirmPinTitle => 'ยืนยัน PIN';

  @override
  String get pinIncorrect => 'PIN ไม่ถูกต้อง';

  @override
  String get pinNotMatch => 'PIN ไม่ตรงกัน';

  @override
  String get pinSetSuccess => 'ตั้งค่า PIN สำเร็จ';

  @override
  String get unlockTitle => 'ปลดล็อคแอป';

  @override
  String get weatherLabel => 'สภาพอากาศ';

  @override
  String get weatherSunny => 'แดดจัด';

  @override
  String get weatherCloudy => 'มีเมฆมาก';

  @override
  String get weatherRainy => 'ฝนตก';

  @override
  String get weatherSnowy => 'หิมะตก';

  @override
  String get weatherThunder => 'พายุฝนฟ้าคะนอง';

  @override
  String get weatherWindy => 'ลมแรง';

  @override
  String get language => 'ภาษา';

  @override
  String get selectLanguage => 'เลือกภาษา';
}
