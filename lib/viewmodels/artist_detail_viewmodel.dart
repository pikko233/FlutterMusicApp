import 'package:flutter_music_app/models/artist_detail_model.dart';
import 'package:flutter_music_app/models/artist_model.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/repositories/artist_repository.dart';
import 'package:get/get.dart';

class ArtistDetailViewmodel extends GetxController {
  final int id;
  ArtistDetailViewmodel({required this.id});
  final artist = Rxn<ArtistDetailModel>(); // 歌手详情
  final isLoading = false.obs;
  final topSongs = <SongModel>[].obs; // 歌手热门歌曲50首
  final similarArtists = <ArtistModel>[].obs; // 相似歌手

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _getArtistDetail(id),
        _getArtistTopSong(id),
        _getSimilarArtists(id),
      ]);
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

  // 获取相似歌手
  // 需要cookie
  Future<void> _getSimilarArtists(int id) async {
    final res = await ArtistRepository.getSimilarArtists(id);
    similarArtists.value = (res as List)
        .map((e) => ArtistModel.fromMap(e))
        .toList();
  }
}
