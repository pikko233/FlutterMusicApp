// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_music_app/models/song_model.dart';
import 'package:get/get.dart';

import 'package:flutter_music_app/repositories/song_repository.dart';

class PlayerScreenViewmodel extends GetxController {
  final int ids;
  PlayerScreenViewmodel({required this.ids});
  final isLoading = false.obs;
  final song = Rxn<SongModel>();
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await _getSongDetail(ids);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌曲信息
  Future<void> _getSongDetail(int ids) async {
    final res = await SongRepository.getSongDetail(ids);
    print('歌曲详情：$res');
    song.value = res;
  }
}
