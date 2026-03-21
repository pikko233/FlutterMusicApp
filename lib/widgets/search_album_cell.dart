import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchAlbumCell extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  const SearchAlbumCell({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              image,
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.maxFinite,
              height: (media.width - 60) / 8,
              decoration: BoxDecoration(
                color: AppColors.bgCard.withValues(alpha: 0.9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textPrimary60,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
