import 'package:flutter_music_app/models/artist_detail_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/artist_repository.dart';
import 'package:get/get.dart';

class ArtistDetailViewmodel extends GetxController {
  final int id;
  ArtistDetailViewmodel({required this.id});
  final artist = Rxn<ArtistDetailModel>(); // 歌手详情
  final isLoading = false.obs;
  final topSongs = <SongModel>[].obs; // 歌手热门歌曲50首

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([_getArtistDetail(id), _getArtistTopSong(id)]);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // 获取歌手详情
  Future<void> _getArtistDetail(int id) async {
    final res = await ArtistRepository.getArtistDetail(id);
    artist.value = ArtistDetailModel.fromMap(
      res['artist'] as Map<String, dynamic>,
      videoCount: res['videoCount'] as int?,
    );
  }

  // 获取歌手热门50首
  Future<void> _getArtistTopSong(int id) async {
    final res = await ArtistRepository.getArtistTopSong(id);
    topSongs.value = (res as List).map((e) => SongModel.fromMap(e)).toList();
    print('歌手热门歌曲50首, $topSongs');
  }
}
