import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/views/home/home_view.dart';
import 'package:flutter_music_app/views/library/library_view.dart';
import 'package:flutter_music_app/views/profile/profile_view.dart';
import 'package:flutter_music_app/views/search/search_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  Widget get selectedView {
    List<Widget> list = [
      HomeView(),
      SearchView(),
      LibraryView(),
      ProfileView(),
    ];
    return list[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: selectedView),
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
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "音乐库"),
          BottomNavigationBarItem(
            icon: Icon(Icons.radio_button_checked),
            label: "我的",
          ),
        ],
      ),
    );
  }
}
