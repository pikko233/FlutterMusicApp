import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:get/get.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  String _phone = ''; // 手机号
  String _password = ''; // 密码
  final _formKey = GlobalKey<FormState>();

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
          Positioned(
            top: media.height * 0.1,
            left: 20,
            right: 20,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
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
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      label: Text(
                        '手机号',
                        style: TextStyle(color: AppColors.textHint),
                      ),
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
                        borderSide: BorderSide(
                          width: 2,
                          color: AppColors.primary,
                        ),
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
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      label: Text(
                        '密码',
                        style: TextStyle(color: AppColors.textHint),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
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
                        borderSide: BorderSide(
                          width: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return '密码不能为空';
                      return null;
                    },
                    onSaved: (newValue) => _password = newValue!,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print('$_phone, $_password');
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '还没有账号？',
                          style: TextStyle(
                            color: AppColors.textPrimary40,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '立即注册',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
