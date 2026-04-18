import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/viewmodels/auth_viewmodel.dart';
import 'package:flutter_music_app/views/auth/widgets/login_form.dart';
import 'package:flutter_music_app/views/auth/widgets/register_form.dart';
import 'package:get/get.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _gestureRecognizer = TapGestureRecognizer();
  bool _isLogin = true; // true-登录页，false-注册页
  final _authVM = Get.put(AuthViewmodel());

  void _handleCaptchaLogin(String phone, String captcha) {
    _authVM.captchaLogin(phone, captcha);
  }

  Future<void> _handleSendCaptcha(String phone) async {
    await _authVM.sendCaptcha(phone);
  }

  Future<String> _handleGetQrKey() => _authVM.getQrKey();
  Future<String> _handleCreateQrCode(String key) => _authVM.createQrCode(key);
  Future<Map<String, dynamic>> _handleCheckQrStatus(String key) =>
      _authVM.checkQrStatus(key);

  void _handleEmailLogin(String email, String password) {
    _authVM.loginByEmail(email, password);
  }

  void _handleQrLoginSuccess(Map<String, dynamic> result) {
    print('二维码登录成功: $result');
    // TODO: 存储 cookie/用户信息
  }

  Future<void> _handleGuestLogin() async {
    await _authVM.guestLogin();
  }

  void _handleRegister(String phone, String password) {
    // TODO 调用注册接口
    print('$phone, $password');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _gestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.bgCard, AppColors.bgPrimary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: media.height * 0.1,
            ),
            child: Column(
              spacing: 16,
              children: [
                Row(),
                Container(
                  width: media.width * 0.2,
                  height: media.width * 0.2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryAuth, AppColors.accent1],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 1],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Container(
                      width: media.width * 0.2 / 3,
                      height: media.width * 0.2 / 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: media.width * 0.2 / 3 * 0.6,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Pikko Music',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'YOUR MUSIC, EVERYWHERE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _isLogin
                    ? LoginForm(
                        onCaptchaLogin: _handleCaptchaLogin,
                        onSendCaptcha: _handleSendCaptcha,
                        onGetQrKey: _handleGetQrKey,
                        onCreateQrCode: _handleCreateQrCode,
                        onCheckQrStatus: _handleCheckQrStatus,
                        onQrLoginSuccess: _handleQrLoginSuccess,
                        onEmailLogin: _handleEmailLogin,
                      )
                    : RegisterForm(onRegister: _handleRegister),

                GestureDetector(
                  onTap: _handleGuestLogin,
                  child: Text(
                    '游客登录',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _isLogin ? '还没有账号？' : '已经有账号？',
                        style: TextStyle(
                          color: AppColors.textPrimary40,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: _isLogin ? '立即注册' : '立即登录',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: _gestureRecognizer
                          ..onTap = () {
                            // print('跳转注册页');
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
