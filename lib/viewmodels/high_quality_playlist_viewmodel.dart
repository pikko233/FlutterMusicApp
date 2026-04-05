import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_music_app/models/high_quality_playlist_model.dart';
import 'package:flutter_music_app/models/high_quality_playlist_tag_model.dart';
import 'package:flutter_music_app/repositories/playlist_repository.dart';
import 'package:get/get.dart';

class HighQualityPlaylistViewmodel extends GetxController {
  final isLoading = false.obs;
  final tags = <HighQualityPlaylistTagModel>[].obs; // 精品标签
  final currentIndex = 0.obs; // 选中的精品标签索引
  final highQualityPlaylist = <HighQualityPlaylistModel>[].obs; // 精品歌单
  late final TabController tabController;

  String get cat =>
      tags.isEmpty ? '全部' : tags[currentIndex.value].name; // 获取精品歌单api-cat参数
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _getHighQualityTags(),
        _getHighQualityPlaylist(0, cat: cat),
      ]);
      tabController = TabController(
        length: tags.length,
        vsync: _StandAloneTickerProvider(),
      );
      tabController.addListener(() {
        if (!tabController.indexIsChanging) return;
        currentIndex.value = tabController.index;
        _getHighQualityPlaylist(0, cat: cat);
      });
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取精品歌单标签
  Future<void> _getHighQualityTags() async {
    final res = await PlaylistRepository.getHighQualityTags();
    tags.add(
      HighQualityPlaylistTagModel(
        id: 0,
        name: '全部',
        type: 0,
        category: 0,
        hot: false,
      ),
    );
    tags.addAll(res);
  }

  // 获取精品歌单
  Future<void> _getHighQualityPlaylist(
    int before, {
    String? cat,
    int limit = 48,
  }) async {
    final res = await PlaylistRepository.getHighQualityPlaylist(
      before,
      cat: cat,
      limit: limit,
    );
    highQualityPlaylist.value = res;
  }
}

class _StandAloneTickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
