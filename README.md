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

**解决方案：** 使用 `Image.network` 时加上以下 headers：

```dart
Image.network(
  url,
  headers: {
    'Referer': 'https://music.163.com',
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  },
)
```
