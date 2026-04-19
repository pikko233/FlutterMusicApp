# flutter_music_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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
