import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchSingerCell extends StatelessWidget {
  final bool isSubscribed; // 是否已关注该歌手
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed; // 点击进入歌手主页
  final VoidCallback onPressedSub; // 点击关注按钮
  const SearchSingerCell({
    super.key,
    this.isSubscribed = false,
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
      trailing: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: isSubscribed ? Colors.transparent : AppColors.primary,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isSubscribed ? AppColors.primary : AppColors.bgCard,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              isSubscribed
                  ? const SizedBox.shrink()
                  : Icon(Icons.add, color: AppColors.primary, size: 12),
              isSubscribed ? const SizedBox.shrink() : const SizedBox(width: 4),
              Text(
                isSubscribed ? "已关注" : "关注",
                style: TextStyle(
                  color: isSubscribed
                      ? AppColors.textPrimary
                      : AppColors.primary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
