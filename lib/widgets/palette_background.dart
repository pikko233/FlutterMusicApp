import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

/// 从图片自动提取调色板，并以动态渐变背景包裹子组件
class PaletteBackground extends StatefulWidget {
  const PaletteBackground({
    super.key,
    required this.imageProvider,
    required this.child,
    this.fallbackColors = const [Color(0xFF1A1A2E), Color(0xFF16213E)],
    this.duration = const Duration(milliseconds: 500),
    this.colorSpace = ColorSpace.lab,
    this.onColorsExtracted,
  });

  // 歌词高亮色（ValueNotifier，变化时通知监听者重建）
  static final lyricGradientNotifier = ValueNotifier<LinearGradient>(
    const LinearGradient(colors: [Color(0xFF42e695), Color(0xFF3bb2b8)]),
  );

  /// 专辑封面的 ImageProvider（支持 Network / Asset / File）
  final ImageProvider imageProvider;

  /// 子组件（播放页内容）
  final Widget child;

  /// 提取颜色前显示的兜底渐变
  final List<Color> fallbackColors;

  /// 颜色切换动画时长
  final Duration duration;

  /// 色彩空间，lab 最准确，rgb 最快
  final ColorSpace colorSpace;

  /// 提取完成回调，可拿到原始 palette 做更多处理
  final void Function(PaletteGeneratorMaster palette)? onColorsExtracted;

  @override
  State<PaletteBackground> createState() => _PaletteBackgroundState();
}

/// 亮度低于阈值时，用 HSL 强制提亮到可读范围
Color? _ensureReadable(Color? color, {double minLightness = 0.6}) {
  if (color == null) return null;
  final hsl = HSLColor.fromColor(color);
  if (hsl.lightness < minLightness) {
    // 检查亮度
    return hsl.withLightness(minLightness).toColor(); // 若亮度较低，强制提高到0.6
  }
  return color;
}

class _PaletteBackgroundState extends State<PaletteBackground> {
  List<Color> _gradientColors = [];
  Color _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _gradientColors = widget.fallbackColors;
    _extractColors();
  }

  @override
  void didUpdateWidget(PaletteBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 封面换了就重新提取
    if (oldWidget.imageProvider != widget.imageProvider) {
      _extractColors();
    }
  }

  Future<void> _extractColors() async {
    try {
      final palette = await PaletteGeneratorMaster.fromImageProvider(
        widget.imageProvider,
        maximumColorCount: 12,
        colorSpace: widget.colorSpace,
      );

      widget.onColorsExtracted?.call(palette);

      // 优先取主导色，让封面氛围感更强
      final mainColor =
          palette.lightVibrantColor?.color ??
          palette.dominantColor?.color ??
          palette.vibrantColor?.color ??
          widget.fallbackColors[0];

      // 顶部
      final top = mainColor.withValues(
        red: (mainColor.r * 0.7).clamp(0.0, 1.0),
        green: (mainColor.g * 0.7).clamp(0.0, 1.0),
        blue: (mainColor.b * 0.7).clamp(0.0, 1.0),
      );

      // 中部 - 较暗
      final mid = mainColor.withValues(
        red: (mainColor.r * 0.5).clamp(0.0, 1.0),
        green: (mainColor.g * 0.5).clamp(0.0, 1.0),
        blue: (mainColor.b * 0.5).clamp(0.0, 1.0),
      );

      // 底部 - 最暗
      final bottom = mainColor.withValues(
        red: (mainColor.r * 0.3).clamp(0.0, 1.0),
        green: (mainColor.g * 0.3).clamp(0.0, 1.0),
        blue: (mainColor.b * 0.3).clamp(0.0, 1.0),
      );

      // 自动选对比度高的文字颜色
      final textColor = palette.dominantColor != null
          ? palette.getBestTextColorFor(mainColor)
          : Colors.white;

      if (mounted) {
        setState(() {
          _gradientColors = [top, mid, bottom];
          _textColor = textColor;
        });

        // 通知歌词颜色监听者，优先亮色系，亮度不足时强制提亮到 0.6
        final lyric1 =
            palette.lightVibrantColor?.color ??
            palette.vibrantColor?.color ??
            palette.lightMutedColor?.color;
        final lyric2 =
            palette.vibrantColor?.color ??
            palette.lightMutedColor?.color ??
            palette.dominantColor?.color;

        PaletteBackground.lyricGradientNotifier.value = LinearGradient(
          colors: [
            _ensureReadable(lyric1) ?? const Color(0xFF42e695),
            _ensureReadable(lyric2) ?? const Color(0xFF3bb2b8),
          ],
        );
      }
    } catch (_) {
      // 提取失败静默降级到兜底色
    }
  }

  @override
  Widget build(BuildContext context) {
    // 确保始终有 3 个色标
    final colors = _gradientColors.length >= 3
        ? _gradientColors
        : [_gradientColors.first, _gradientColors.first, _gradientColors.last];

    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          stops: const [0.0, 0.45, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      // 把文字颜色注入 DefaultTextStyle，子组件自动继承
      child: DefaultTextStyle(
        style: TextStyle(color: _textColor),
        child: widget.child,
      ),
    );
  }
}
