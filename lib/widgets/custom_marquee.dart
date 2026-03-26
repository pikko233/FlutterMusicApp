import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class CustomMarquee extends StatelessWidget {
  final String text;
  final TextStyle style;
  const CustomMarquee({super.key, required this.text, required this.style});

  bool _isOverflow(double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);
    return painter.width > maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_isOverflow(constraints.maxWidth)) {
          return Text(text, style: style);
        }
        return Marquee(
          text: text,
          style: style,
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 20.0,
          velocity: 80.0,
          pauseAfterRound: Duration(seconds: 3),
          startPadding: 10.0,
          accelerationDuration: Duration(seconds: 1),
          accelerationCurve: Curves.linear,
          decelerationDuration: Duration(milliseconds: 500),
          decelerationCurve: Curves.easeOut,
        );
      },
    );
  }
}
