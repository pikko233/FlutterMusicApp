// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart';

import 'package:flutter_music_app/repositories/song_repository.dart';

class PlayerScreenViewmodel extends GetxController {
  final int id;
  PlayerScreenViewmodel({required this.id});
  final isLoading = false.obs;
  final isAvailable = false.obs; // 音乐是否可用（是否有版权）
  final song = Rxn<SongModel>();
  final songUrl = RxnString();
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await _checkSong(id);
      if (!isAvailable.value) return;
      await _getSongDetail(id);
      await _getSongUrl(id);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌曲信息
  Future<void> _getSongDetail(int id) async {
    final res = await SongRepository.getSongDetail(id);
    song.value = res;
  }

  // 检查歌曲是否有版权
  Future<void> _checkSong(int id) async {
    final res = await SongRepository.checkSong(id);
    isAvailable.value = res;
  }

  // 获取歌曲URL
  Future<void> _getSongUrl(int id) async {
    final res = await SongRepository.getSongUrl(id, level: 'higher');
    songUrl.value = res as String?;
  }
}
