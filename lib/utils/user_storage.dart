import 'package:flutter_music_app/models/song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _keyCookie = 'user_cookie';
  static const _keyUserId = 'user_id';
  static const _keyIsGuest = 'user_is_guest';
  static const _keyRecentSongs = 'user_recent_songs';

  static Future<void> save({
    required String cookie,
    required int userId,
    required bool isGuest,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCookie, cookie);
    await prefs.setInt(_keyUserId, userId);
    await prefs.setBool(_keyIsGuest, isGuest);
  }

  static Future<String?> getCookie() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCookie);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<bool> isGuest() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGuest) ?? false;
  }

  static Future<bool> isLoggedIn() async {
    final cookie = await getCookie();
    return cookie != null && cookie.isNotEmpty;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCookie);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyIsGuest);
  }

  // 存储游客的最近播放歌曲
  static Future<void> saveRecentSong(SongModel song) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyRecentSongs) ?? [];
    list.removeWhere((e) => SongModel.fromJson(e).id == song.id);
    list.insert(0, song.toJson()); // 将歌曲json序列化存起来
    if (list.length > 20) list.removeLast(); // 只保留最近播放的20首歌曲
    prefs.setStringList(_keyRecentSongs, list);
  }

  // 取出游客的最近播放歌曲
  static Future<List<SongModel>> getRecentSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyRecentSongs) ?? [];
    return list.map((e) => SongModel.fromJson(e)).toList();
  }
}
