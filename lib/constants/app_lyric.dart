import 'package:flutter/material.dart';
import 'package:flutter_lyric/core/lyric_style.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class AppLyric {
  static LyricStyle playerScreenLyricStyle(
    LinearGradient gradient, // 根据传入的颜色显示歌词高亮颜色
  ) => LyricStyle(
    textStyle: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary40,
      height: 1.2,
    ),
    activeStyle: TextStyle(
      fontSize: 16,
      height: 1.2,
      color: AppColors.textPrimary80,
      fontWeight: FontWeight.w600,
    ),
    translationStyle: TextStyle(
      fontSize: 15,
      color: AppColors.textPrimary40,
      fontWeight: FontWeight.w600,
    ),
    translationActiveColor: AppColors.textPrimary80,
    lineTextAlign: TextAlign.center,
    lineGap: 40,
    translationLineGap: 5,
    contentAlignment: CrossAxisAlignment.center,
    contentPadding: EdgeInsets.only(
      top: 300,
      left: 20,
      right: 20,
      bottom: 20,
    ), // 内间距
    selectionAnchorPosition: 0.5,
    activeAnchorPosition: 0.5, // 高亮歌词视图垂直位置，0.5-垂直居中
    fadeRange: FadeRange(top: 40, bottom: 80),
    selectionAlignment: MainAxisAlignment.end,
    activeAlignment: MainAxisAlignment.center,
    selectedColor: Colors.white,
    selectedTranslationColor: Colors.white,
    scrollDuration: Duration(milliseconds: 240),
    scrollDurations: {
      500: Duration(milliseconds: 500),
      1000: Duration(milliseconds: 1000),
    },
    enableSwitchAnimation: true,
    selectionAutoResumeMode: SelectionAutoResumeMode.neverResume,
    selectionAutoResumeDuration: Duration(milliseconds: 320),
    activeAutoResumeDuration: Duration(milliseconds: 2000),
    switchEnterDuration: Duration(milliseconds: 150), // 进入高亮的时间
    switchExitDuration: Duration.zero, // 退出高亮的时间
    switchEnterCurve: Curves.easeIn,
    switchExitCurve: Curves.easeOut,
    activeHighlightGradient: gradient, // 歌词高亮颜色渐变
    activeHighlightExtraFadeWidth: 40,
  );
}
