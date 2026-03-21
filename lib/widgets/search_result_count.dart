import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:intl/intl.dart';

class SearchResultCount extends StatelessWidget {
  final int count;
  final String label;
  const SearchResultCount({
    super.key,
    required this.count,
    this.label = "首相关歌曲",
  });

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat('#,###').format(count);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        "找到 $formatted $label",
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
