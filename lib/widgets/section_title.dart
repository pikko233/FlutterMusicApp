import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showMore;
  final String showMoreLabel;
  final VoidCallback onPressed;
  const SectionTitle({
    super.key,
    required this.title,
    required this.onPressed,
    this.showMore = true,
    this.showMoreLabel = "更多",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          showMore
              ? TextButton.icon(
                  icon: Icon(Icons.chevron_right),
                  iconAlignment: IconAlignment.end,
                  onPressed: onPressed,
                  label: Text(
                    showMoreLabel,
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
