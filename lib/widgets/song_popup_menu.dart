import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/song_model.dart';
import 'package:flutter_music_app/services/player_service.dart';
import 'package:flutter_music_app/utils/toast_util.dart';
import 'package:get/get.dart';

class SongPopupMenu extends StatelessWidget {
  final SongModel song;
  SongPopupMenu({super.key, required this.song});

  final _player = Get.find<PlayerService>();

  // 点击菜单按钮的映射
  final Map<MenuButton, int> _map = {
    MenuButton.toggleFavorite: 1, // 添加至喜欢/取消喜欢
    MenuButton.addToPlaylist: 2, // 添加至歌单
    MenuButton.playNext: 3, // 下一首播放
    MenuButton.deleteFromPlaylist: 4, // 从播放列表删除
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: AppColors.bgElevated,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _map[MenuButton.toggleFavorite],
          child: MenuItem(
            title: '添加至我喜欢',
            icon: Icon(Icons.favorite_border, color: Color(0xFFEC4899)),
          ),
        ),
        PopupMenuDivider(
          color: AppColors.textPrimary.withValues(alpha: 0.12),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        PopupMenuItem(
          value: _map[MenuButton.addToPlaylist],
          child: MenuItem(
            title: '添加至歌单',
            icon: Icon(Icons.add_box_outlined, color: Colors.white),
          ),
        ),
        PopupMenuDivider(
          color: AppColors.textPrimary.withValues(alpha: 0.12),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        PopupMenuItem(
          onTap: () {
            _player.addToNextPlay(song);
            ToastUtil.showToast('添加成功');
          },
          value: _map[MenuButton.playNext],
          child: MenuItem(
            title: '下一首播放',
            icon: Icon(Icons.skip_next, color: Colors.white),
          ),
        ),
        PopupMenuDivider(
          color: AppColors.textPrimary.withValues(alpha: 0.12),
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
        PopupMenuItem(
          onTap: () {
            print('从播放列表中删除');
          },
          value: _map[MenuButton.deleteFromPlaylist],
          child: MenuItem(
            title: '从播放列表中删除',
            icon: Icon(
              Icons.delete_forever,
              color: Color.fromARGB(255, 236, 72, 99),
            ),
          ),
        ),
      ],
    );
  }
}

// 定义菜单按钮的枚举变量
enum MenuButton { toggleFavorite, addToPlaylist, playNext, deleteFromPlaylist }

// 菜单的单个按钮项
class MenuItem extends StatelessWidget {
  final String title;
  final Icon icon;
  const MenuItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: icon,
    );
  }
}
