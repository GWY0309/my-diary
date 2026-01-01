// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '私の日記';

  @override
  String get settings => '設定';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get appLock => 'アプリロック';

  @override
  String get deleteSuccess => '削除しました';

  @override
  String get filterByTag => 'タグでフィルター';

  @override
  String get tagLife => '生活';

  @override
  String get tagWork => '仕事';

  @override
  String get tagTravel => '旅行';

  @override
  String get tagMood => '気分';

  @override
  String get tagFood => '食事';

  @override
  String get tagStudy => '勉強';

  @override
  String get tapAgainToExit => 'もう一度タップして終了';

  @override
  String get selected => '選択中';

  @override
  String get searchHint => '日記を検索...';

  @override
  String get noDiariesFound => '日記が見つかりません';

  @override
  String get logoutConfirmation => 'ログアウトしてもよろしいですか？\n次回は再ログインが必要です。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirmLogout => 'ログアウト';

  @override
  String get appearanceAndExperience => '外観と体験';

  @override
  String get privacyAndSecurity => 'プライバシーとセキュリティ';

  @override
  String get pinLock => 'PINロック';

  @override
  String get biometricUnlock => '生体認証ロック解除';

  @override
  String get enablePinFirst => '先にPINロックを有効にしてください';

  @override
  String get account => 'アカウント';

  @override
  String get pleaseEnablePinFirst => '先にPINロックを有効にしてください';

  @override
  String get biometricNotSupported => 'このデバイスは生体認証をサポートしていないか、有効になっていません';

  @override
  String get enterEmailAndPassword => 'メールアドレスとパスワードを入力してください';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get autoLogin => '自動ログイン';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get loginButton => 'ログイン';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get registerNow => '今すぐ登録';

  @override
  String get registerTitle => 'アカウント登録';

  @override
  String get confirmPasswordLabel => 'パスワード確認';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get registerSuccess => '登録成功';

  @override
  String registerFailed(Object error) {
    return '登録失敗: $error';
  }

  @override
  String get newDiaryTitle => '新しい日記';

  @override
  String get editDiaryTitle => '日記を編集';

  @override
  String get saveButton => '保存';

  @override
  String get titleHint => 'タイトル';

  @override
  String get contentHint => '今日の出来事を記録しましょう...';

  @override
  String get moodLabel => '気分';

  @override
  String get tagsLabel => 'タグ';

  @override
  String get selectDate => '日付を選択';

  @override
  String get pleaseEnterContent => '内容を入力してください';

  @override
  String get diaryDetailTitle => '日記の詳細';

  @override
  String get editAction => '編集';

  @override
  String get deleteAction => '削除';

  @override
  String get shareAction => '共有';

  @override
  String get statisticsTitle => '統計データ';

  @override
  String get moodChartTitle => '気分の傾向';

  @override
  String get diaryCountTitle => '日記の総数';

  @override
  String get moodDistribution => '気分の分布';

  @override
  String get enterPinTitle => 'PINを入力';

  @override
  String get setPinTitle => 'PINを設定';

  @override
  String get confirmPinTitle => 'PINを確認';

  @override
  String get pinIncorrect => 'PINが正しくありません';

  @override
  String get pinNotMatch => 'PINが一致しません';

  @override
  String get pinSetSuccess => 'PINが設定されました';

  @override
  String get unlockTitle => 'アプリのロック解除';

  @override
  String get weatherLabel => '天気';

  @override
  String get weatherSunny => '晴れ';

  @override
  String get weatherCloudy => '曇り';

  @override
  String get weatherRainy => '雨';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunder => '雷雨';

  @override
  String get weatherWindy => '強風';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';
}
