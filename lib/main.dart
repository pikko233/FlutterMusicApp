import 'package:flutter/material.dart';
import 'package:flutter_music_app/routes/my_app.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.flutter_music_app.audio',
    androidNotificationChannelName: '音乐播放',
    androidNotificationOngoing: true,
  );
  Get.put(PlayerService(), permanent: true);
  runApp(const MyApp());
}
