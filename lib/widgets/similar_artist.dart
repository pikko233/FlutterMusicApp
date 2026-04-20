import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/models/artist_model.dart';
import 'package:flutter_music_app/utils/count_util.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';

class SimilarArtist extends StatelessWidget {
  final ArtistModel artist;
  final VoidCallback onPressed;
  final VoidCallback toggleFollow;
  const SimilarArtist({
    super.key,
    required this.artist,
    required this.onPressed,
    required this.toggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: media.width * 0.26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26,
        ),
        child: Column(
          children: [
            ClipOval(
              child: NeteaseImage(url: artist.img1v1Url, width: 50, height: 50),
            ),
            const SizedBox(height: 6),
            Text(
              artist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textPrimary80,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${CountUtil.formatCount(artist.fansCount!)} 粉丝',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
            ),
            const SizedBox(height: 2),
            ElevatedButton.icon(
              onPressed: toggleFollow,
              label: Text(
                artist.followed ? '已关注' : '关注',
                style: TextStyle(
                  fontSize: 12,
                  color: artist.followed
                      ? Colors.grey.withValues(alpha: 0.5)
                      : AppColors.primary,
                ),
              ),
              icon: Icon(
                artist.followed ? Icons.check : Icons.add,
                size: 12,
                color: artist.followed
                    ? Colors.grey.withValues(alpha: 0.5)
                    : AppColors.primary,
              ),
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size(50, 36),
                side: BorderSide(
                  color: artist.followed
                      ? Colors.grey.withValues(alpha: 0.5)
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
