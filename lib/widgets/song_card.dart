import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SongCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final bool isPlaying;
  final VoidCallback onPressed;
  const SongCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    this.isPlaying = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        trailing: IconButton(
          onPressed: onPressed,
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
