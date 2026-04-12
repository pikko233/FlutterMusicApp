import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class NeteaseImageUtil {
  static ImageProvider provider(String url) {
    return CachedNetworkImageProvider(
      url,
      headers: {
        'Referer': 'https://music.163.com',
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      },
    );
  }
}
