import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  // 单例模式 (可选)
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  EmailService._internal();

  // 🔴【配置区】请替换为您自己的邮箱账号和授权码
  final String _username = '2760309276@qq.com'; // 例如: 123456@qq.com
  final String _password = 'tpzwflaiquzodfii';        // 刚才获取的16位授权码 (不是QQ密码!)

  // 内存中临时存储验证码：Map<邮箱, 验证码>
  final Map<String, String> _otpCache = {};
  // 内存中临时存储过期时间：Map<邮箱, 过期时间>
  final Map<String, DateTime> _otpExpiry = {};

  // 1. 生成 6 位随机验证码
  String _generateOtp() {
    var rng = Random();
    return (100000 + rng.nextInt(900000)).toString();
  }

  // 2. 发送验证码
  Future<bool> sendOtp(String recipientEmail) async {
    final otp = _generateOtp();

    // 配置 SMTP 服务器 (QQ邮箱: smtp.qq.com, 端口 465, ssl)
    // 如果是 163: smtp.163.com
    // 如果是 Gmail: gmail(_username, _password)
    final smtpServer = qq(_username, _password);

    // 构建邮件内容
    final message = Message()
      ..from = Address(_username, 'My Diary Team') // 发件人名称
      ..recipients.add(recipientEmail) // 收件人
      ..subject = '【My Diary】注册验证码' // 邮件标题
      ..text = '您的注册验证码是：$otp\n该验证码 5 分钟内有效。请勿泄露给他人。'; // 纯文本内容
    // ..html = "<h1>$otp</h1>"; // 如果想发 HTML 格式可以用这个

    try {
      final sendReport = await send(message, smtpServer);
      print('邮件发送成功: ${sendReport.toString()}');

      // 发送成功后，保存验证码到内存，并设置 5 分钟过期
      _otpCache[recipientEmail] = otp;
      _otpExpiry[recipientEmail] = DateTime.now().add(const Duration(minutes: 5));

      return true;
    } on MailerException catch (e) {
      print('邮件发送失败: $e');
      for (var p in e.problems) {
        print('问题: ${p.code}: ${p.msg}');
      }
      return false;
    } catch (e) {
      print('未知错误: $e');
      return false;
    }
  }

  // 3. 验证验证码
  bool verifyOtp(String email, String inputOtp) {
    // 检查是否有记录
    if (!_otpCache.containsKey(email)) return false;

    // 检查是否过期
    if (DateTime.now().isAfter(_otpExpiry[email]!)) {
      _otpCache.remove(email); // 清理过期数据
      _otpExpiry.remove(email);
      return false;
    }

    // 检查号码是否一致
    final cachedOtp = _otpCache[email];
    if (cachedOtp == inputOtp) {
      // 验证通过后，立刻清除，防止重复使用
      _otpCache.remove(email);
      _otpExpiry.remove(email);
      return true;
    }

    return false;
  }
}