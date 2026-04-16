import 'package:flutter_music_app/repositories/auth_repository.dart';
import 'package:get/get.dart';

class AuthViewmodel extends GetxController {
  final user = Rxn(); // 登录成功后返回的用户信息
  final isLoading = false.obs; // 是否加载中

  // 登录
  Future<void> login(
    String phone,
    String password, {
    int? countrycode,
    String? md5_password,
    String? captcha,
  }) async {
    try {
      isLoading.value = true;
      final res = await AuthRepository.login(
        phone,
        password,
        countrycode: countrycode,
        md5_password: md5_password,
        captcha: captcha,
      );
      print('登录结果: $res');
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
