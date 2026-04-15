import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/constants/app_routes.dart';
import 'package:flutter_music_app/models/artist_detail_model.dart';
import 'package:flutter_music_app/widgets/netease_image.dart';
import 'package:get/get.dart';

class ArtistBottomSheet extends StatelessWidget {
  final List<ArtistDetailModel> artists;
  const ArtistBottomSheet({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '该歌曲有多个歌手',
                textAlign: TextAlign.start,
                style: TextStyle(color: AppColors.textPrimary60, fontSize: 14),
              ),
            ),
          ),
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final item = artists[index];
              return ListTile(
                onTap: () => {
                  Get.toNamed(
                    AppRoutes.artistDetail,
                    arguments: {'id': item.id},
                  ),
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: NeteaseImage(url: item.avatar, width: 40, height: 40),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // TODO 未登录时，歌手详情api没有返回是否关注的字段，等做完登录功能后再回来看看
                trailing: ElevatedButton.icon(
                  onPressed: () {
                    print('点击关注歌手: ${item.id}');
                  },
                  label: Text(
                    '关注',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: Icon(Icons.add, color: AppColors.primary, size: 15),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bgCard,
                    overlayColor: Colors.white.withValues(alpha: 0.2),
                    side: BorderSide(color: AppColors.primary),
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
