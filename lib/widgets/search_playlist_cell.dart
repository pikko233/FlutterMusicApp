import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchPlaylistCell extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed; // 点击进入歌单
  final VoidCallback onPressedPlay; // 点击播放按钮
  const SearchPlaylistCell({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.onPressedPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.only(left: 15, right: 5),
      tileColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
        side: BorderSide(color: Colors.transparent),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(image, width: 40, height: 40, fit: BoxFit.cover),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        style: TextStyle(
          color: AppColors.textPrimary60,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: IconButton(
        onPressed: onPressedPlay,
        icon: Icon(Icons.play_arrow, color: AppColors.textPrimary60),
      ),
    );
  }
}
