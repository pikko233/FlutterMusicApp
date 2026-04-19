# 基于Flutter开发的音乐播放器App

## 介绍

基于 Flutter 开发的网易云音乐第三方客户端，对接 [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)，使用 GetX 进行状态管理，采用 MVVM 分层架构。

## 已实现功能

### 认证

- 游客登录（匿名 cookie 模式）
- 手机验证码登录（含倒计时 UI）
- 邮箱密码登录（前端 MD5 加密）
- 二维码扫码登录（轮询状态检查）
- Cookie 持久化（登录状态保持）

### 音乐播放器

- 播放 / 暂停 / 上下首切歌
- 三种循环模式（列表循环 / 单曲循环 / 顺序播放）
- 版权检查与自动跳过无版权歌曲
- 逐字歌词显示与时间轴同步（支持翻译歌词）
- 封面旋转动画（播放时旋转，暂停时停止）
- 播放进度条 + 缓冲进度条
- 播放列表分页加载（播放到倒数第 3 首时自动加载下一页）
- 最近播放历史（本地缓存最近 20 首）
- 后台播放 + 通知栏控制（Android / iOS）

### 搜索

- 热搜榜单（含搜索次数）
- 实时搜索建议（防抖 0.5s）
- 多类型搜索结果（歌曲 / 专辑 / 歌手 / 歌单）
- 搜索结果分 Tab 展示，下拉自动加载更多

### 首页

- 推荐歌单
- 精品歌单（分类筛选：华语、古风、欧美等）
- 排行榜入口

### 歌单详情

- 歌单信息展示（封面、描述、歌曲数）
- 歌曲列表分页加载
- 播放整个歌单
- 歌曲长按操作菜单（加入下一首播放等）

### 歌手详情

- 歌手信息（头像、简介、粉丝数）
- 热门歌曲 Top 50
- 相似歌手推荐
- 全部歌曲页面（支持按热度 / 时间排序，分页加载）

### 专辑详情

- 专辑信息（名称、发行日期、艺术家、描述）
- 专辑歌曲列表与整张播放

### 精品歌单浏览

- 分类 Tab 切换
- 网格卡片布局

### 个人主页 / 最近播放

- 登录 / 游客状态展示
- 最近播放歌曲列表
- 用户统计信息（收藏数、关注数、粉丝数）

---

## 未完成功能

| 功能               | 说明                                         |
| ------------------ | -------------------------------------------- |
| 用户注册           | UI 已完成，提交接口未对接                    |
| 关注歌手           | 歌手详情页与搜索结果页 UI 已完成，接口未对接 |
| 收藏歌曲 / 歌单    | 未实现                                       |
| 搜索历史记录       | UI 有入口，无存储逻辑                        |
| 音乐库页面         | 仅占位符                                     |
| 登录后个人歌单同步 | 登录后无法拉取个人歌单                       |
| 下载 / 离线播放    | 未实现                                       |
| 主题切换           | 目前仅深色主题                               |

---

## 项目中用到的[第三方库](https://pub.dev)

| 库 | 用途 |
| --- | --- |
| [get](https://pub.dev/packages/get) | 使用 GetX 进行状态管理 |
| [intl](https://pub.dev/packages/intl) | 格式化工具 - 用于千分位分隔符、日期时间格式化 |
| [audio_video_progress_bar](https://pub.dev/packages/audio_video_progress_bar) | 音频进度条 UI 库 |
| [dio](https://pub.dev/packages/dio) | 网络请求库 |
| [cached_network_image](https://pub.dev/packages/cached_network_image) | 将网络图片缓存至本地，防止刷新页面时重新发送请求获取图片，浪费资源 |
| [marquee](https://pub.dev/packages/marquee) | 文字跑马灯效果 |
| [just_audio](https://pub.dev/packages/just_audio) | 音频播放功能 |
| [just_audio_background](https://pub.dev/packages/just_audio_background) | 后台播放功能 |
| [rxdart](https://pub.dev/packages/rxdart) | 合并数据流，将音频的*播放进度*、*缓冲进度*以及*总时长*三个数据流合并成一个数据流 |
| [carousel_slider](https://pub.dev/packages/carousel_slider) | 实现左右滑动切换歌曲的轮播图效果 |
| [flutter_lyric](https://pub.dev/packages/flutter_lyric) | 实现歌词展示与滚动 |
| [palette_generator_master](https://pub.dev/packages/palette_generator_master) | 从图片中提取色调，用于背景氛围色渲染 |
| [crypto](https://pub.dev/packages/crypto) | MD5 加密，用于登录注册对密码进行加密处理 |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 持久化存储，用于存储登录成功后返回的 cookie 和用户信息，以及游客登录时的最近播放歌曲记录 |

---

## 开发环境

- Flutter SDK: ^3.12.0
- Dart SDK: ^3.12.0
- 后端 API：[NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)（需本地部署）

---

## 快速开始

1. 克隆服务端项目 并启动网易云音乐 API 服务（默认端口 3000）

```bash
git clone https://github.com/pikko233/NeteaseCloudMusicApi.git
cd NeteaseCloudMusicApi
npm install # 安装依赖
node app.js
```

2. 克隆客户端项目

```bash
git clone https://github.com/pikko233/FlutterMusicApp.git
cd FlutterMusicApp
```

3. 安装依赖

```bash
flutter pub get
```

4. 运行项目

```bash
flutter run
```

---

## 学习记录

### 2026.03.23 — 加载网易云图片需要设置请求头

**问题：** 网易云 API 返回的图片 URL 有防盗链保护，直接请求会返回 403。

**原因：** 网易云 CDN 同时校验 `Referer` 和 `User-Agent`，缺一不可。

**解决方案：** 使用 `cached_network_image` 包（`Image.network` 的 headers 参数在某些平台上不生效（在macOS上是不生效的，其他平台暂未得知）。用 `cached_network_image` 包来处理，它对 headers 支持更好。），安装：

```
flutter pub add cached_network_image
```

```dart
CachedNetworkImage(
  imageUrl: url,
  httpHeaders: {
    'Referer': 'https://music.163.com',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  },
)
```

---

### 2026.04.19 — GetX 同路由跳转被静默拦截 & Get.put tag 机制

**问题：** 在歌手详情页（`/artist_detail`）点击相似歌手，想再次跳转到 `/artist_detail`，但点击完全没有反应。

**原因：** GetX 对"防止重复路由"有**两处独立**的拦截逻辑，必须同时处理：`GetPage(preventDuplicates: true)` 和 `Get.toNamed(..., preventDuplicates: true)`

**解决方案：** 两处都需要设为 `false`。

`my_app.dart` 中注册路由：

```dart
GetPage(
  name: AppRoutes.artistDetail,
  page: () => const ArtistDetailView(),
  preventDuplicates: false, // 允许同路由叠加
),
```

调用跳转时：

```dart
Get.toNamed(
  AppRoutes.artistDetail,
  arguments: {'id': item.id},
  preventDuplicates: false, // 必须同时在调用处声明
);
```

---

**另外：** 同一路由（`/artist_detail`）有多个实例时需要用 `Get.put` 的 tag 区分 ViewModel

```dart
// ArtistDetailView 的 initState 中
final id = Get.arguments['id'] as int? ?? 0;
_artistDetailVM = Get.put(
  ArtistDetailViewmodel(id: id),
  tag: id.toString(), // 用 id 作为 tag，不同歌手互不干扰
);
```
