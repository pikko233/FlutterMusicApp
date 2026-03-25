import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class NeteaseImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  const NeteaseImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return SizedBox(width: width, height: height);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: {
        'Referer': 'https://music.163.com',
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      },
    );
  }
}
