import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/md5_util.dart';

class LoginForm extends StatefulWidget {
  final void Function(String phone, String password) onLogin;
  const LoginForm({super.key, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _phone = '';
  String _password = '';
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              label: Text('手机号', style: TextStyle(color: AppColors.textHint)),
              prefixIcon: Icon(Icons.phone, color: AppColors.textHint),
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
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '手机号不能为空';
              final reg = RegExp(r'^1[3-9]\d{9}$');
              if (!reg.hasMatch(value)) return '手机号格式不正确';
              return null;
            },
            onSaved: (newValue) => _phone = newValue!,
          ),
          TextFormField(
            obscureText: !_showPassword,
            decoration: InputDecoration(
              filled: true,
              label: Text('密码', style: TextStyle(color: AppColors.textHint)),
              prefixIcon: Icon(Icons.lock_outline, color: AppColors.textHint),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                color: AppColors.textHint,
              ),
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
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return '密码不能为空';
              return null;
            },
            onSaved: (newValue) => _password = Md5Util.md5Hash(newValue!),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onLogin(_phone, _password);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAuth,
              overlayColor: Colors.white.withValues(alpha: 0.2),
              minimumSize: Size(double.infinity, 48),
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
