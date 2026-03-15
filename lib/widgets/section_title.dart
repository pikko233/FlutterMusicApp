import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback onPressed;
  const SectionTitle({
    super.key,
    required this.title,
    required this.onPressed,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
        showSeeAll
            ? TextButton(
                onPressed: onPressed,
                child: Text(
                  "更多",
                  style: TextStyle(color: AppColors.primary, fontSize: 14),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
