import 'package:flutter/material.dart';
import 'package:flutter_music_app/constants/app_colors.dart';
import 'package:flutter_music_app/viewmodels/high_quality_playlist_viewmodel.dart';
import 'package:flutter_music_app/widgets/mini_player.dart';
import 'package:flutter_music_app/widgets/playlist_card.dart';
import 'package:get/get.dart';

class HighQualityPlaylistView extends StatefulWidget {
  const HighQualityPlaylistView({super.key});

  @override
  State<HighQualityPlaylistView> createState() =>
      _HighQualityPlaylistViewState();
}

class _HighQualityPlaylistViewState extends State<HighQualityPlaylistView>
    with SingleTickerProviderStateMixin {
  final _highQualityPlaylistVM = Get.put(HighQualityPlaylistViewmodel());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.bgCard,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          '精品歌单',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgPrimary, AppColors.bgCard],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Obx(
            () => _highQualityPlaylistVM.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: kToolbarHeight - 10,
                            child: TabBar(
                              controller: _highQualityPlaylistVM.tabController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              indicator: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelStyle: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              unselectedLabelStyle: TextStyle(
                                color: AppColors.textPrimary40,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              tabs: List.generate(
                                _highQualityPlaylistVM.tags.length,
                                (index) {
                                  final item =
                                      _highQualityPlaylistVM.tags[index];
                                  return Tab(child: Text(item.name));
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 20,
                                right: 20,
                                bottom: 80,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 1 / 1.7,
                                  ),
                              itemCount: _highQualityPlaylistVM
                                  .highQualityPlaylist
                                  .length,
                              itemBuilder: (context, index) {
                                final item = _highQualityPlaylistVM
                                    .highQualityPlaylist[index];
                                return PlaylistCard(
                                  id: item.id,
                                  image: item.coverImgUrl,
                                  title: item.name,
                                  subtitle: item.tags.join(' '),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: MiniPlayer(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight * 0.5,
        color: Colors.black,
      ),
    );
  }
}
