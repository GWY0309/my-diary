// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '我的日记';

  @override
  String get settings => '设置';

  @override
  String get darkMode => '深色模式';

  @override
  String get login => '登录';

  @override
  String get logout => '退出登录';

  @override
  String get appLock => '应用锁';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get filterByTag => '按标签筛选';

  @override
  String get tagLife => '生活';

  @override
  String get tagWork => '工作';

  @override
  String get tagTravel => '旅行';

  @override
  String get tagMood => '心情';

  @override
  String get tagFood => '美食';

  @override
  String get tagStudy => '学习';

  @override
  String get tapAgainToExit => '再滑一次退出 My Diary';

  @override
  String get selected => '已选';

  @override
  String get searchHint => '搜索日记...';

  @override
  String get noDiariesFound => '没有找到日记';

  @override
  String get logoutConfirmation => '确定要退出当前账号吗？\n下次进入需要重新登录。';

  @override
  String get cancel => '取消';

  @override
  String get confirmLogout => '退出';

  @override
  String get appearanceAndExperience => '外观与体验';

  @override
  String get privacyAndSecurity => '隐私安全';

  @override
  String get pinLock => '数字密码锁';

  @override
  String get biometricUnlock => '生物识别解锁';

  @override
  String get enablePinFirst => '需先开启数字密码锁';

  @override
  String get account => '账号';

  @override
  String get pleaseEnablePinFirst => '请先开启数字密码锁';

  @override
  String get biometricNotSupported => '您的设备不支持或未开启生物识别';

  @override
  String get enterEmailAndPassword => '请输入账号和密码';

  @override
  String get emailLabel => '邮箱地址';

  @override
  String get passwordLabel => '密码';

  @override
  String get autoLogin => '自动登录';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get loginButton => '登 录';

  @override
  String get noAccount => '还没有账号？';

  @override
  String get registerNow => '立即注册';

  @override
  String get registerTitle => '注册账号';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get registerSuccess => '注册成功';

  @override
  String registerFailed(Object error) {
    return '注册失败: $error';
  }

  @override
  String get newDiaryTitle => '写日记';

  @override
  String get editDiaryTitle => '编辑日记';

  @override
  String get saveButton => '保存';

  @override
  String get titleHint => '标题';

  @override
  String get contentHint => '记录今天发生的事...';

  @override
  String get moodLabel => '心情';

  @override
  String get tagsLabel => '标签';

  @override
  String get selectDate => '选择日期';

  @override
  String get pleaseEnterContent => '请输入日记内容';

  @override
  String get diaryDetailTitle => '日记详情';

  @override
  String get editAction => '编辑';

  @override
  String get deleteAction => '删除';

  @override
  String get shareAction => '分享';

  @override
  String get statisticsTitle => '数据统计';

  @override
  String get moodChartTitle => '心情走势';

  @override
  String get diaryCountTitle => '累计日记';

  @override
  String get moodDistribution => '心情分布';

  @override
  String get enterPinTitle => '输入密码';

  @override
  String get setPinTitle => '设置密码';

  @override
  String get confirmPinTitle => '确认密码';

  @override
  String get pinIncorrect => '密码错误';

  @override
  String get pinNotMatch => '两次密码不一致';

  @override
  String get pinSetSuccess => '密码设置成功';

  @override
  String get unlockTitle => '解锁应用';

  @override
  String get weatherLabel => '天气';

  @override
  String get weatherSunny => '晴天';

  @override
  String get weatherCloudy => '多云';

  @override
  String get weatherRainy => '雨天';

  @override
  String get weatherSnowy => '雪天';

  @override
  String get weatherThunder => '雷雨';

  @override
  String get weatherWindy => '大风';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get deleteTitle => '确认删除';

  @override
  String deleteConfirm(Object count) {
    return '确定要删除这 $count 篇日记吗？';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '我的日記';

  @override
  String get settings => '設定';

  @override
  String get darkMode => '深色模式';

  @override
  String get login => '登入';

  @override
  String get logout => '登出';

  @override
  String get appLock => '應用鎖';

  @override
  String get deleteSuccess => '刪除成功';

  @override
  String get filterByTag => '依標籤篩選';

  @override
  String get tagLife => '生活';

  @override
  String get tagWork => '工作';

  @override
  String get tagTravel => '旅行';

  @override
  String get tagMood => '心情';

  @override
  String get tagFood => '美食';

  @override
  String get tagStudy => '學習';

  @override
  String get tapAgainToExit => '再按一次退出 My Diary';

  @override
  String get selected => '已選';

  @override
  String get searchHint => '搜尋日記...';

  @override
  String get noDiariesFound => '沒有找到日記';

  @override
  String get logoutConfirmation => '確定要登出目前帳號嗎？\n下次進入需要重新登入。';

  @override
  String get cancel => '取消';

  @override
  String get confirmLogout => '登出';

  @override
  String get appearanceAndExperience => '外觀與體驗';

  @override
  String get privacyAndSecurity => '隱私安全';

  @override
  String get pinLock => '密碼鎖';

  @override
  String get biometricUnlock => '生物辨識解鎖';

  @override
  String get enablePinFirst => '需先開啟密碼鎖';

  @override
  String get account => '帳號';

  @override
  String get pleaseEnablePinFirst => '請先開啟密碼鎖';

  @override
  String get biometricNotSupported => '您的裝置不支援或未開啟生物辨識';

  @override
  String get enterEmailAndPassword => '請輸入帳號和密碼';

  @override
  String get emailLabel => '電子郵件';

  @override
  String get passwordLabel => '密碼';

  @override
  String get autoLogin => '自動登入';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String get loginButton => '登 入';

  @override
  String get noAccount => '還沒有帳號？';

  @override
  String get registerNow => '立即註冊';

  @override
  String get registerTitle => '註冊帳號';

  @override
  String get confirmPasswordLabel => '確認密碼';

  @override
  String get passwordsDoNotMatch => '兩次輸入的密碼不一致';

  @override
  String get registerSuccess => '註冊成功';

  @override
  String registerFailed(Object error) {
    return '註冊失敗: $error';
  }

  @override
  String get newDiaryTitle => '寫日記';

  @override
  String get editDiaryTitle => '編輯日記';

  @override
  String get saveButton => '儲存';

  @override
  String get titleHint => '標題';

  @override
  String get contentHint => '記錄今天發生的事...';

  @override
  String get moodLabel => '心情';

  @override
  String get tagsLabel => '標籤';

  @override
  String get selectDate => '選擇日期';

  @override
  String get pleaseEnterContent => '請輸入日記內容';

  @override
  String get diaryDetailTitle => '日記詳情';

  @override
  String get editAction => '編輯';

  @override
  String get deleteAction => '刪除';

  @override
  String get shareAction => '分享';

  @override
  String get statisticsTitle => '數據統計';

  @override
  String get moodChartTitle => '心情走勢';

  @override
  String get diaryCountTitle => '累計日記';

  @override
  String get moodDistribution => '心情分佈';

  @override
  String get enterPinTitle => '輸入密碼';

  @override
  String get setPinTitle => '設定密碼';

  @override
  String get confirmPinTitle => '確認密碼';

  @override
  String get pinIncorrect => '密碼錯誤';

  @override
  String get pinNotMatch => '兩次密碼不一致';

  @override
  String get pinSetSuccess => '密碼設定成功';

  @override
  String get unlockTitle => '解鎖應用程式';

  @override
  String get weatherLabel => '天氣';

  @override
  String get weatherSunny => '晴天';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherRainy => '雨天';

  @override
  String get weatherSnowy => '雪天';

  @override
  String get weatherThunder => '雷雨';

  @override
  String get weatherWindy => '強風';

  @override
  String get language => '語言';

  @override
  String get selectLanguage => '選擇語言';
}
