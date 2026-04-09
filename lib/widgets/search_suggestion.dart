import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchSuggestion extends StatelessWidget {
  final double top;
  final List<String> suggestions;
  final Function(String) onPressed;
  const SearchSuggestion({
    super.key,
    required this.top,
    required this.suggestions,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 15,
      right: 15,
      child: Material(
        elevation: 8,
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final word = suggestions[index];
              return ListTile(
                leading: Icon(
                  Icons.search,
                  color: AppColors.textHint,
                  size: 18,
                ),
                title: Text(
                  word,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.textPrimary80),
                ),
                onTap: () => onPressed(word),
              );
            },
          ),
        ),
      ),
    );
  }
}
