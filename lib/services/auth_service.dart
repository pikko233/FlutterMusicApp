import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/repositories/auth_repository.dart';
import 'package:flutter_music_app/utils/user_storage.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final user = Rxn(); // 用户信息
  final isLoading = false.obs; // 是否加载中
  final isLogin = false.obs; // 是否登录

  @override
  void onInit() {
    super.onInit();
    // _initState();
  }

  Future<void> _initState() async {
    if (await UserStorage.getCookie() == null) {
      // 未登录，先使用游客登录拿到cookie
      await guestLogin();
    }
  }

  // 手机验证码登录
  Future<void> captchaLogin(String phone, String captcha) async {
    try {
      isLoading.value = true;
      final res = await AuthRepository.captchaLogin(phone, captcha);
      print('验证码登录结果: $res');
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 邮箱登录（password 已在 UI 层 MD5 处理）
  Future<void> loginByEmail(String email, String password) async {
    try {
      isLoading.value = true;
      final res = await AuthRepository.loginByEmail(email, password);
      print('邮箱登录结果: $res');
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 发送手机验证码
  Future<void> sendCaptcha(String phone) async {
    await AuthRepository.sendCaptcha(phone);
  }

  // 获取key，生成登录二维码的api需要key作为参数
  Future<String> getQrKey() => AuthRepository.getQrKey();

  // 生成登录二维码
  Future<String> createQrCode(String key) => AuthRepository.createQrCode(key);

  // 检查二维码状态
  Future<Map<String, dynamic>> checkQrStatus(String key) =>
      AuthRepository.checkQrStatus(key);

  // 游客登录
  Future<void> guestLogin() async {
    try {
      isLoading.value = true;
      final res = await AuthRepository.guestLogin();
      final cookie = res['cookie'] as String;
      final userId = res['userId'] as int;
      await UserStorage.save(cookie: cookie, userId: userId, isGuest: true);
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
