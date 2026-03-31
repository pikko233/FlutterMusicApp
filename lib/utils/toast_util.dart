import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:get/get.dart';

class ToastUtil {
  ToastUtil._();

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
}
