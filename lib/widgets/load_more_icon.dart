import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class LoadMoreIcon extends StatelessWidget {
  final bool hasMore;
  const LoadMoreIcon({super.key, required this.hasMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: SizedBox(
        height: 60,
        child: Center(
          child: !hasMore
              ? Text(
                  '没有更多了',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
