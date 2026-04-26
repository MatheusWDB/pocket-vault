import 'package:flutter/material.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/enums/edit_category_dialog_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/screens/components/marquee_text.dart';
import 'package:pocket_vault/screens/components/edit_category_dialog.dart';
import 'package:pocket_vault/screens/home/tabs/budget/widgets/budget_progress_bar.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class BudgetListBuilder extends StatelessWidget {
  final List<Category> categories;
  final Map<Category, double> totalExpenses;
  final CurrencySymbolEnum currency;

  const BudgetListBuilder({
    required this.categories,
    required this.totalExpenses,
    required this.currency,
    super.key,
  });

  String _formatCurrency(double number, CurrencySymbolEnum currency) =>
      number.toCurrency(code: currency.code, locale: currency.locale);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final budgetCategories = categories
        .where((c) => (c.budgetLimit ?? 0.0) > 0.0)
        .toList();

    if (budgetCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: budgetCategories.length,
        itemBuilder: (context, index) {
          final category = budgetCategories[index];

          final spent = totalExpenses[category] ?? 0.0;
          final limit = category.budgetLimit!;

          final progress = spent / limit;

          final spentText = _formatCurrency(spent, currency);
          final limitText = _formatCurrency(limit, currency);

          return ListTile(
            contentPadding: const EdgeInsets.all(8),
            dense: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MarqueeText(text: category.name),
                Text(
                  t.spentOfLimit(spentText, limitText),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            subtitle: BudgetProgressBar(progress: progress),
            onTap: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => EditCategoryDialog(
                category: category,
                lastTab: EditCategoryDialogEnum.budget,
              ),
            ),
          );
        },
      ),
    );
  }
}
