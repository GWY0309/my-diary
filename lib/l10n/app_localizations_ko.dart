// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '나의 일기';

  @override
  String get settings => '설정';

  @override
  String get darkMode => '다크 모드';

  @override
  String get login => '로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get appLock => '앱 잠금';

  @override
  String get deleteSuccess => '삭제 성공';

  @override
  String get filterByTag => '태그로 필터링';

  @override
  String get tagLife => '일상';

  @override
  String get tagWork => '업무';

  @override
  String get tagTravel => '여행';

  @override
  String get tagMood => '기분';

  @override
  String get tagFood => '음식';

  @override
  String get tagStudy => '공부';

  @override
  String get tapAgainToExit => '한 번 더 누르면 종료됩니다';

  @override
  String get selected => '선택됨';

  @override
  String get searchHint => '일기 검색...';

  @override
  String get noDiariesFound => '일기를 찾을 수 없습니다';

  @override
  String get logoutConfirmation => '정말 로그아웃 하시겠습니까?\n다음에는 다시 로그인해야 합니다.';

  @override
  String get cancel => '취소';

  @override
  String get confirmLogout => '로그아웃';

  @override
  String get appearanceAndExperience => '화면 및 기능';

  @override
  String get privacyAndSecurity => '개인정보 및 보안';

  @override
  String get pinLock => 'PIN 잠금';

  @override
  String get biometricUnlock => '생체 인증 잠금 해제';

  @override
  String get enablePinFirst => '먼저 PIN 잠금을 설정하세요';

  @override
  String get account => '계정';

  @override
  String get pleaseEnablePinFirst => '먼저 PIN 잠금을 설정해주세요';

  @override
  String get biometricNotSupported => '생체 인증을 지원하지 않거나 활성화되지 않았습니다';

  @override
  String get enterEmailAndPassword => '이메일과 비밀번호를 입력하세요';

  @override
  String get emailLabel => '이메일 주소';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get autoLogin => '자동 로그인';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get loginButton => '로그인';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get registerNow => '회원가입';

  @override
  String get registerTitle => '회원가입';

  @override
  String get confirmPasswordLabel => '비밀번호 확인';

  @override
  String get passwordsDoNotMatch => '비밀번호가 일치하지 않습니다';

  @override
  String get registerSuccess => '가입 성공';

  @override
  String registerFailed(Object error) {
    return '가입 실패: $error';
  }

  @override
  String get newDiaryTitle => '새 일기';

  @override
  String get editDiaryTitle => '일기 수정';

  @override
  String get saveButton => '저장';

  @override
  String get titleHint => '제목';

  @override
  String get contentHint => '오늘 무슨 일이 있었나요?';

  @override
  String get moodLabel => '기분';

  @override
  String get tagsLabel => '태그';

  @override
  String get selectDate => '날짜 선택';

  @override
  String get pleaseEnterContent => '내용을 입력해주세요';

  @override
  String get diaryDetailTitle => '일기 상세';

  @override
  String get editAction => '수정';

  @override
  String get deleteAction => '삭제';

  @override
  String get shareAction => '공유';

  @override
  String get statisticsTitle => '통계';

  @override
  String get moodChartTitle => '기분 흐름';

  @override
  String get diaryCountTitle => '총 일기 수';

  @override
  String get moodDistribution => '기분 분포';

  @override
  String get enterPinTitle => 'PIN 입력';

  @override
  String get setPinTitle => 'PIN 설정';

  @override
  String get confirmPinTitle => 'PIN 확인';

  @override
  String get pinIncorrect => 'PIN이 올바르지 않습니다';

  @override
  String get pinNotMatch => 'PIN이 일치하지 않습니다';

  @override
  String get pinSetSuccess => 'PIN이 설정되었습니다';

  @override
  String get unlockTitle => '잠금 해제';

  @override
  String get weatherLabel => '날씨';

  @override
  String get weatherSunny => '맑음';

  @override
  String get weatherCloudy => '흐림';

  @override
  String get weatherRainy => '비';

  @override
  String get weatherSnowy => '눈';

  @override
  String get weatherThunder => '뇌우';

  @override
  String get weatherWindy => '바람';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';
}
