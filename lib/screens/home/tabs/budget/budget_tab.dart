import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/home/tabs/budget/widgets/budget_dialog.dart';
import 'package:pocket_vault/screens/home/tabs/budget/widgets/budget_progress_bar.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetsTabState();
}

class _BudgetsTabState extends ConsumerState<BudgetTab> {
  String _formatCurrency(double number, CurrencySymbolEnum currency) =>
      number.toCurrency(code: currency.code, locale: currency.locale);

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(preferencesProvider).currencySymbol;
    final categoriesAsync = ref.watch(categoryListProvider);
    final totals = ref.watch(categoriesTotalSpentProvider);
    final categoriesNoBudgetLimit = ref.watch(
      categoriesAvailableForBudgetProvider,
    );

    return Column(
      spacing: 10,
      children: [
        categoriesAsync.when(
          data: (categories) {
            final budgetCategories = categories
                .where((c) => c.budgetLimit != null && c.budgetLimit! > 0)
                .toList();

            if (budgetCategories.isEmpty) {
              return SizedBox.shrink();
            }

            return Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: budgetCategories.length,
                itemBuilder: (context, index) {
                  final category = budgetCategories[index];

                  final spent = totals[category.id!] ?? 0.0;
                  final limit = category.budgetLimit!;

                  final progress = spent / limit;

                  final spentText = _formatCurrency(spent, currency);
                  final limitText = _formatCurrency(limit, currency);

                  return ListTile(
                    contentPadding: EdgeInsets.all(8),
                    dense: true,
                    title: Column(
                      spacing: 4,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$spentText de $limitText',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: BudgetProgressBar(progress: progress),
                    onTap: () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => BudgetDialog(category: category),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text('Erro: $error'));
          },
          loading: () {
            return Center(child: CircularProgressIndicator());
          },
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(padding: EdgeInsets.all(15)),
          onPressed: () {
            if (categoriesNoBudgetLimit.isEmpty) {
              AlertInfo.show(
                context: context,
                text: 'Todas as categorias já possuem limite',
                typeInfo: TypeInfo.warning,
              );
              return;
            }

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => BudgetDialog(),
            );
          },
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(LucideIcons.circlePlus), Text('Novo Limite')],
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
