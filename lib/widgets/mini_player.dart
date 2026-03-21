import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          onTap: () {},
          dense: true,
          visualDensity: VisualDensity.compact,
          contentPadding: const EdgeInsets.only(left: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/ar_4.png",
              width: 35,
              height: 35,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "晴天",
            maxLines: 1,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            "周杰伦",
            style: TextStyle(
              color: AppColors.textPrimary60,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.pause),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.skip_next, color: AppColors.textSecondary),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
