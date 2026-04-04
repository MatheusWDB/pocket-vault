import 'package:flutter/material.dart';
import 'package:pocket_vault/screens/components/build_marquee_text.dart';

class BuildLegendItem extends StatelessWidget {
  final String categoryName;
  final String percentage;
  final Color color;
  final double width;

  const BuildLegendItem({
    required this.categoryName,
    required this.percentage,
    required this.color,
    required this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),

          SizedBox(
            width: 75,
            child: BuildMarqueeText(
              text: categoryName,
              style: TextStyle(fontSize: 14),
              velocity: 25.0,
            ),
          ),

          Text(percentage),
        ],
      ),
    );
  }
}
