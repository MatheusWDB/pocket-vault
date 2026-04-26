import 'package:flutter/material.dart';
import 'package:pocket_vault/enums/edit_category_dialog_enum.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/screens/components/marquee_text.dart';
import 'package:pocket_vault/screens/components/edit_category_dialog.dart';
import 'package:pocket_vault/utils/category_color_utils.dart';

class CategoryLegendItem extends StatelessWidget {
  final Category category;
  final String percentage;
  final double width;

  const CategoryLegendItem({
    required this.category,
    required this.percentage,
    required this.width,
    super.key,
  });

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => EditCategoryDialog(
        category: category,
        lastTab: EditCategoryDialogEnum.color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = category.name;
    final categoryColor = category.color;

    return InkWell(
      onTap: () => _showCategoryDialog(context),
      child: SizedBox(
        width: width,
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: categoryColor == null
                    ? CategoryColorUtils.getCategoryColor(category.id)
                    : Color(int.parse(categoryColor, radix: 16)),
                shape: BoxShape.circle,
              ),
            ),

            Expanded(
              child: MarqueeText(
                text: categoryName,
                style: TextStyle(fontSize: 14),
                velocity: 25.0,
              ),
            ),

            Text(percentage),
          ],
        ),
      ),
    );
  }
}
