import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';

class SearchArtistCell extends StatelessWidget {
  final bool followed; // 是否已关注该歌手
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed; // 点击进入歌手主页
  final VoidCallback onPressedSub; // 点击关注按钮
  const SearchArtistCell({
    super.key,
    this.followed = false,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.onPressedSub,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      contentPadding: const EdgeInsets.only(left: 15, right: 10),
      tileColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
        side: BorderSide(color: Colors.transparent),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: NeteaseImage(url: image, width: 40, height: 40),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
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
      trailing: ElevatedButton.icon(
        onPressed: onPressedSub,
        label: Text(followed ? '已关注' : '关注'),
        icon: followed ? null : Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          backgroundColor: followed ? AppColors.primary : AppColors.bgElevated,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          visualDensity: VisualDensity.compact,
          foregroundColor: followed ? AppColors.textPrimary80 : null,
        ),
      ),
      // trailing: InkWell(
      //   onTap: () {},
      //   borderRadius: BorderRadius.circular(20),
      //   child: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      //     decoration: BoxDecoration(
      //       border: BoxBorder.all(
      //         color: followed ? Colors.transparent : AppColors.primary,
      //       ),
      //       borderRadius: BorderRadius.circular(20),
      //       color: followed ? AppColors.primary : AppColors.bgCard,
      //     ),
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         followed
      //             ? const SizedBox.shrink()
      //             : Icon(Icons.add, color: AppColors.primary, size: 12),
      //         followed ? const SizedBox.shrink() : const SizedBox(width: 4),
      //         Text(
      //           followed ? "已关注" : "关注",
      //           style: TextStyle(
      //             color: followed ? AppColors.textPrimary : AppColors.primary,
      //             fontSize: 12,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
