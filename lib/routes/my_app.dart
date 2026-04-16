import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/utils/global_keys.dart';
import 'package:flutter_music_app/constants/app_theme.dart';
import 'package:flutter_music_app/views/album/album_detail_view.dart';
import 'package:flutter_music_app/views/artist/artist_songs_view.dart';
import 'package:flutter_music_app/views/auth/auth_view.dart';
import 'package:flutter_music_app/views/main/main_view.dart';
import 'package:flutter_music_app/views/player/player_screen_view.dart';
import 'package:flutter_music_app/views/playlist/high_quality_playlist_view.dart';
import 'package:flutter_music_app/views/playlist/playlist_detail_view.dart';
import 'package:flutter_music_app/views/search/search_result_view.dart';
import 'package:flutter_music_app/views/artist/artist_detail_view.dart';
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
      scaffoldMessengerKey: GlobalKeys.scaffoldMessengerKey,
      initialRoute: AppRoutes.splash,
      getPages: [
        GetPage(name: AppRoutes.splash, page: () => const SplashView()),
        GetPage(name: AppRoutes.main, page: () => const MainView()),
        GetPage(
          name: AppRoutes.searchResult,
          page: () => const SearchResultView(),
        ),
        GetPage(
          name: AppRoutes.playlistDetail,
          page: () => const PlaylistDetailView(),
        ),
        GetPage(
          name: AppRoutes.artistDetail,
          page: () => const ArtistDetailView(),
        ),
        GetPage(
          name: AppRoutes.playerScreen,
          page: () => const PlayerScreenView(),
        ),
        GetPage(
          name: AppRoutes.highQualityPlaylist,
          page: () => const HighQualityPlaylistView(),
        ),
        GetPage(
          name: AppRoutes.albumDetail,
          page: () => const AlbumDetailView(),
        ),
        GetPage(
          name: AppRoutes.artistSongs,
          page: () => const ArtistSongsView(),
        ),
        GetPage(name: AppRoutes.auth, page: () => const AuthView()),
      ],
    );
  }
}
