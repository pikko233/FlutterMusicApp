import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class PlaylistCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const PlaylistCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 1,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
