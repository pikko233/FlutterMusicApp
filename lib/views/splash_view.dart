import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:get/get.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _jumpToMainView();
  }

  Future<void> _jumpToMainView() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.offAllNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                "assets/images/app_logo.png",
                width: media.width * 0.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              "Powered by Spotify Api",
              style: TextStyle(color: AppColors.textPrimary60),
            ),
          ),
        ],
      ),
    );
  }
}
