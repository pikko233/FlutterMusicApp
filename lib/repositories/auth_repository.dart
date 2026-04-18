import 'package:flutter_music_app/utils/request.dart';
import 'package:flutter_music_app/utils/user_storage.dart';

class AuthRepository {
  // 手机验证码登录
  static Future<dynamic> captchaLogin(String phone, String captcha) async {
    final res = await Request.post(
      '/login/cellphone',
      data: {'phone': phone, 'captcha': captcha},
    );
    return res.data;
  }

  // 使用邮箱登录（只传 md5_password，避免明文密码与 hash 同时出现导致 502）
  static Future<dynamic> loginByEmail(String email, String md5Password) async {
    final res = await Request.post(
      '/login',
      data: {'email': email, 'md5_password': md5Password},
    );
    return res.data;
  }

  static Future<dynamic> sendCaptcha(String phone) async {
    final res = await Request.get('/captcha/sent', params: {'phone': phone});
    return res.data;
  }

  static Future<String> getQrKey() async {
    final res = await Request.get(
      '/login/qr/key',
      params: {'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
    return res.data['data']['unikey'] as String;
  }

  static Future<String> createQrCode(String key) async {
    final res = await Request.getRaw(
      '/login/qr/create',
      params: {
        'key': key,
        'qrimg': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return res.data['data']['qrimg'] as String;
  }

  // 返回 { code, message, cookie }
  // 800: 过期  801: 等待扫码  802: 待确认  803: 登录成功
  static Future<Map<String, dynamic>> checkQrStatus(String key) async {
    final res = await Request.getRaw(
      '/login/qr/check',
      params: {'key': key, 'timestamp': DateTime.now().millisecondsSinceEpoch},
    );
    return Map<String, dynamic>.from(res.data);
  }

  // 游客登录
  static Future<dynamic> guestLogin() async {
    final res = await Request.post('/register/anonimous');
    return res.data;
  }
}
