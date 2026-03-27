import 'package:flutter/material.dart';
import 'package:flutter_music_app/routes/my_app.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:get/get.dart';

void main() {
  Get.put(PlayerService(), permanent: true);
  runApp(const MyApp());
}
