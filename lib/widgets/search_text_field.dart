import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final Function(String) onSubmitted;

  const SearchTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      style: TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.bgPrimary.withValues(alpha: 0.3),
        prefixIcon: Icon(Icons.search, color: AppColors.textHint),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
