// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Nhật Ký Của Tôi';

  @override
  String get settings => 'Cài đặt';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get appLock => 'Khóa ứng dụng';

  @override
  String get deleteSuccess => 'Xóa thành công';

  @override
  String get filterByTag => 'Lọc theo thẻ';

  @override
  String get tagLife => 'Cuộc sống';

  @override
  String get tagWork => 'Công việc';

  @override
  String get tagTravel => 'Du lịch';

  @override
  String get tagMood => 'Tâm trạng';

  @override
  String get tagFood => 'Ẩm thực';

  @override
  String get tagStudy => 'Học tập';

  @override
  String get tapAgainToExit => 'Nhấn lần nữa để thoát';

  @override
  String get selected => 'Đã chọn';

  @override
  String get searchHint => 'Tìm nhật ký...';

  @override
  String get noDiariesFound => 'Không tìm thấy nhật ký';

  @override
  String get logoutConfirmation =>
      'Bạn có chắc chắn muốn đăng xuất?\nBạn sẽ phải đăng nhập lại lần sau.';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirmLogout => 'Đăng xuất';

  @override
  String get appearanceAndExperience => 'Giao diện và Trải nghiệm';

  @override
  String get privacyAndSecurity => 'Quyền riêng tư và Bảo mật';

  @override
  String get pinLock => 'Khóa PIN';

  @override
  String get biometricUnlock => 'Mở khóa sinh trắc học';

  @override
  String get enablePinFirst => 'Hãy bật khóa PIN trước';

  @override
  String get account => 'Tài khoản';

  @override
  String get pleaseEnablePinFirst => 'Vui lòng bật khóa PIN trước';

  @override
  String get biometricNotSupported =>
      'Sinh trắc học không được hỗ trợ hoặc chưa bật';

  @override
  String get enterEmailAndPassword => 'Vui lòng nhập email và mật khẩu';

  @override
  String get emailLabel => 'Địa chỉ Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get autoLogin => 'Tự động đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get registerNow => 'Đăng ký ngay';

  @override
  String get registerTitle => 'Đăng ký';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get registerSuccess => 'Đăng ký thành công';

  @override
  String registerFailed(Object error) {
    return 'Đăng ký thất bại: $error';
  }

  @override
  String get newDiaryTitle => 'Nhật ký mới';

  @override
  String get editDiaryTitle => 'Sửa nhật ký';

  @override
  String get saveButton => 'Lưu';

  @override
  String get titleHint => 'Tiêu đề';

  @override
  String get contentHint => 'Viết gì đó về hôm nay...';

  @override
  String get moodLabel => 'Tâm trạng';

  @override
  String get tagsLabel => 'Thẻ';

  @override
  String get selectDate => 'Chọn ngày';

  @override
  String get pleaseEnterContent => 'Vui lòng nhập nội dung';

  @override
  String get diaryDetailTitle => 'Chi tiết nhật ký';

  @override
  String get editAction => 'Sửa';

  @override
  String get deleteAction => 'Xóa';

  @override
  String get shareAction => 'Chia sẻ';

  @override
  String get statisticsTitle => 'Thống kê';

  @override
  String get moodChartTitle => 'Xu hướng tâm trạng';

  @override
  String get diaryCountTitle => 'Tổng số nhật ký';

  @override
  String get moodDistribution => 'Phân bố tâm trạng';

  @override
  String get enterPinTitle => 'Nhập PIN';

  @override
  String get setPinTitle => 'Thiết lập PIN';

  @override
  String get confirmPinTitle => 'Xác nhận PIN';

  @override
  String get pinIncorrect => 'PIN không đúng';

  @override
  String get pinNotMatch => 'PIN không khớp';

  @override
  String get pinSetSuccess => 'Thiết lập PIN thành công';

  @override
  String get unlockTitle => 'Mở khóa ứng dụng';

  @override
  String get weatherLabel => 'Thời tiết';

  @override
  String get weatherSunny => 'Nắng';

  @override
  String get weatherCloudy => 'Nhiều mây';

  @override
  String get weatherRainy => 'Mưa';

  @override
  String get weatherSnowy => 'Tuyết';

  @override
  String get weatherThunder => 'Giông bão';

  @override
  String get weatherWindy => 'Gió';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get deleteTitle => 'Delete Confirmation';

  @override
  String deleteConfirm(Object count) {
    return 'Are you sure you want to delete $count diaries?';
  }
}
