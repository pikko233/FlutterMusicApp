import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/views/home/home_view.dart';
import 'package:flutter_music_app/views/library/library_view.dart';
import 'package:flutter_music_app/views/my/my_view.dart';
import 'package:flutter_music_app/views/search/search_view.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  Widget get selectedView {
    List<Widget> list = [HomeView(), SearchView(), MyView()];
    return list[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            selectedView,
            Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        backgroundColor: AppColors.bgSecondary,
        selectedItemColor: AppColors.primary,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedItemColor: AppColors.textHint,
        showUnselectedLabels: true,
        elevation: 1,
        // iconSize: 20,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "搜索"),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            label: "我的",
          ),
        ],
      ),
    );
  }
}
