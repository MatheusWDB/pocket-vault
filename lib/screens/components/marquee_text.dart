import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double velocity;

  const MarqueeText({
    required this.text,
    this.style,
    this.velocity = 50.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final textFits = textPainter.width <= constraints.maxWidth;

        if (textFits) {
          return Text(text, style: style, maxLines: 1);
        }

        return SizedBox(
          height: 20,
          child: Marquee(
            text: text,
            style: style,
            blankSpace: 50,
            velocity: velocity,
            pauseAfterRound: const Duration(seconds: 2),
            startAfter: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
