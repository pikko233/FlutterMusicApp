import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/utils/global_keys.dart';

class ToastUtil {
  ToastUtil._();

  static void showToast(String message) {
    final messenger = GlobalKeys.scaffoldMessengerKey.currentState;
    final context = GlobalKeys.scaffoldMessengerKey.currentContext;
    if (messenger == null || context == null) return;
    final screenHeight = MediaQuery.of(context).size.height;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.black87,
          elevation: 8,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // width: 150,
          margin: EdgeInsets.only(
            bottom: screenHeight * 0.5,
            left: 100,
            right: 100,
          ),
          duration: const Duration(milliseconds: 2000),
        ),
      );
  }
}
