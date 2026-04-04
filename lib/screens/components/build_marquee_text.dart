import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class BuildMarqueeText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const BuildMarqueeText({required this.text, this.style, super.key});

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
            pauseAfterRound: const Duration(seconds: 2),
            startAfter: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
