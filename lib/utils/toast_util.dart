import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:get/get.dart';

class ToastUtil {
  ToastUtil._();

  // Getx内置的通知方法
  static void showToast(String message) {
    Get
      ..closeAllSnackbars()
      ..snackbar(
        '',
        '',
        titleText: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        messageText: const SizedBox.shrink(),
        maxWidth: 160,
        padding: const EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
      );
  }

  // flutter原生的snackbar通知栏
  static void showToast2(
    BuildContext context,
    String message, {
    int duration = 1000,
  }) {
    final media = MediaQuery.sizeOf(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          elevation: 8,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(
            bottom: media.height * 0.5,
            left: media.width * 0.3,
            right: media.width * 0.3,
          ),
          duration: Duration(milliseconds: duration),
        ),
      );
  }
}
