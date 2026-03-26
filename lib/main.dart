import 'package:flutter/material.dart';
import 'package:flutter_music_app/routes/my_app.dart';
import 'package:flutter_music_app/viewmodels/global_player_controller.dart';
import 'package:get/get.dart';

void main() {
  Get.put(GlobalPlayerController(), permanent: true);
  runApp(const MyApp());
}
