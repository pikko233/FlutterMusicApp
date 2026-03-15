import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_theme.dart';
import 'package:flutter_music_app/views/main/main_view.dart';
import 'package:flutter_music_app/views/splash_view.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Music App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashView()),
        GetPage(name: '/main', page: () => const MainView()),
      ],
    );
  }
}
