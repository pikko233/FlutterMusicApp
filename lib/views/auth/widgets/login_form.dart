import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/md5_util.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:flutter_music_app/views/auth/widgets/qr_login_widget.dart';

class LoginForm extends StatefulWidget {
  final void Function(String phone, String captcha) onCaptchaLogin;
  final Future<void> Function(String phone) onSendCaptcha;
  final Future<String> Function() onGetQrKey;
  final Future<String> Function(String key) onCreateQrCode;
  final Future<Map<String, dynamic>> Function(String key) onCheckQrStatus;
  final void Function(Map<String, dynamic> result) onQrLoginSuccess;
  final void Function(String email, String password) onEmailLogin;

  const LoginForm({
    super.key,
    required this.onCaptchaLogin,
    required this.onSendCaptcha,
    required this.onGetQrKey,
    required this.onCreateQrCode,
    required this.onCheckQrStatus,
    required this.onQrLoginSuccess,
    required this.onEmailLogin,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _phone = '';
  String _email = '';
  String _password = '';
  String _captcha = '';
  bool _showPassword = false;
  bool _useQr = false;
  bool _useEmail = false;
  int _countdown = 0;
  Timer? _timer;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() => _countdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _countdown--);
      if (_countdown <= 0) t.cancel();
    });
  }

  Future<void> _handleSendCaptcha() async {
    final phone = _phoneController.text.trim();
    final reg = RegExp(r'^1[3-9]\d{9}$');
    if (!reg.hasMatch(phone)) {
      ToastUtil.showToast('请先输入正确的手机号');
      return;
    }
    await widget.onSendCaptcha(phone);
    ToastUtil.showToast('验证码发送成功');
    _startCountdown();
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      filled: true,
      label: Text(label, style: TextStyle(color: AppColors.textHint)),
      prefixIcon: Icon(icon, color: AppColors.textHint),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.textHint),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.textHint),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(width: 2, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_useQr) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          QrLoginWidget(
            onGetKey: widget.onGetQrKey,
            onCreateQrCode: widget.onCreateQrCode,
            onCheckStatus: widget.onCheckQrStatus,
            onLoginSuccess: widget.onQrLoginSuccess,
          ),
          GestureDetector(
            onTap: () => setState(() => _useQr = false),
            child: Text(
              '改用账号登录',
              style: TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          if (_useEmail) ...[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('邮箱', Icons.email_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) return '邮箱不能为空';
                final reg = RegExp(r'^[\w.+-]+@[\w-]+\.\w+$');
                if (!reg.hasMatch(value)) return '邮箱格式不正确';
                return null;
              },
              onSaved: (v) => _email = v!,
            ),
            TextFormField(
              obscureText: !_showPassword,
              decoration: _inputDecoration(
                '密码',
                Icons.lock_outline,
                suffix: IconButton(
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword),
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  color: AppColors.textHint,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '密码不能为空';
                return null;
              },
              onSaved: (v) => _password = Md5Util.md5Hash(v!),
            ),
          ] else ...[
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('手机号', Icons.phone),
              validator: (value) {
                if (value == null || value.isEmpty) return '手机号不能为空';
                final reg = RegExp(r'^1[3-9]\d{9}$');
                if (!reg.hasMatch(value)) return '手机号格式不正确';
                return null;
              },
              onSaved: (v) => _phone = v!,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: _inputDecoration(
                '验证码',
                Icons.message_outlined,
                suffix: TextButton(
                  onPressed: _countdown > 0 ? null : _handleSendCaptcha,
                  child: Text(
                    _countdown > 0 ? '${_countdown}s' : '发送验证码',
                    style: TextStyle(
                      color: _countdown > 0
                          ? AppColors.textHint
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return '验证码不能为空';
                return null;
              },
              onSaved: (v) => _captcha = v!,
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _useQr = true),
                child: Text(
                  '扫码登录',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _useEmail = !_useEmail;
                    _formKey.currentState?.reset();
                  });
                },
                child: Text(
                  _useEmail ? '改用手机号登录' : '改用邮箱登录',
                  style: TextStyle(color: AppColors.primary, fontSize: 13),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (_useEmail) {
                  widget.onEmailLogin(_email, _password);
                } else {
                  widget.onCaptchaLogin(_phone, _captcha);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAuth,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              '登录',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
