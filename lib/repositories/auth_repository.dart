import 'package:flutter_music_app/utils/request.dart';

class AuthRepository {
  // 登录接口
  // 必选参数 :
  // phone: 手机号码
  // password: 密码
  // 可选参数 :
  // countrycode: 国家码，用于国外手机号登录，例如美国传入：1
  // md5_password: md5 加密后的密码,传入后 password 参数将失效
  // captcha: 验证码,使用 /captcha/sent接口传入手机号获取验证码,调用此接口传入验证码,可使用验证码登录,传入后 password 参数将失效
  static Future<dynamic> login(
    String phone,
    String password, {
    int? countrycode,
    String? md5_password,
    String? captcha,
  }) async {
    final res = await Request.post(
      '/login/cellphone',
      data: {
        'phone': phone,
        'password': password,
        'countrycode': countrycode,
        'md5_password': md5_password,
        'captcha': captcha,
      },
    );
    return res.data;
  }
}
