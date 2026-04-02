import 'package:flutter/material.dart';
import 'package:flutter_lyric/core/lyric_style.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class AppLyric {
  static final playerScreenLyricStyle = LyricStyle(
    textStyle: TextStyle(fontSize: 19, color: Colors.white70, height: 1.2),
    activeStyle: TextStyle(
      fontSize: 20,
      height: 1.2,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    translationStyle: TextStyle(fontSize: 18, color: Colors.white70),
    translationActiveColor: Colors.white,
    lineTextAlign: TextAlign.center,
    lineGap: 40,
    translationLineGap: 5,
    contentAlignment: CrossAxisAlignment.center,
    contentPadding: EdgeInsets.only(top: 300, left: 20, right: 20, bottom: 20),
    selectionAnchorPosition: 0.5,
    activeAnchorPosition: 0.5, // 高亮歌词停在视图中的垂直位置, 0.5表示视图高度的50%
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
    switchEnterDuration: Duration(milliseconds: 150), // 进入高亮时长
    switchExitDuration: Duration.zero, // 退出高亮时长
    switchEnterCurve: Curves.easeIn,
    switchExitCurve: Curves.easeOut,
    activeHighlightGradient: AppColors.gradientPink,
    // LinearGradient(
    //   colors: [Color(0xFF3bb2b8), Color(0xFF42e695)],
    // ),
    activeHighlightExtraFadeWidth: 40,
  );
}
