import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/home/tabs/budget/widgets/budget_dialog.dart';
import 'package:pocket_vault/screens/home/tabs/budget/widgets/budget_list_builder.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';

class BudgetTab extends ConsumerStatefulWidget {
  const BudgetTab({super.key});

  @override
  ConsumerState<BudgetTab> createState() => _BudgetsTabState();
}

class _BudgetsTabState extends ConsumerState<BudgetTab> with FilterActions {
  void _budgetLimitDialog(bool noBudgetLimit) {
    if (noBudgetLimit) {
      AppAlerts.warning(context, 'Todas as categorias já possuem limite');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const BudgetDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final filter = ref.watch(transactionFilterProvider);
    final currency = ref.watch(preferencesProvider).currencySymbol;
    final totalExpenses = ref.watch(categoriesTotalSpentProvider);
    final categoriesNoBudgetLimit = ref.watch(
      categoriesAvailableForBudgetProvider,
    );

    final categories = totalExpenses.keys.toList();

    return Column(
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(filter.start!.toMonthYear(myLocale)),
            IconButton(
              onPressed: () => showFilterPicker(
                context,
                showAllYearsOption: false,
                showAllMonthsOption: false,
              ),
              icon: Icon(LucideIcons.funnel),
            ),
          ],
        ),

        if (categories.isNotEmpty)
          BudgetListBuilder(
            categories: categories,
            totalExpenses: totalExpenses,
            currency: currency,
          ),

        OutlinedButton(
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(15)),
          onPressed: () => _budgetLimitDialog(categoriesNoBudgetLimit.isEmpty),
          child: const Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(LucideIcons.circlePlus), Text('Novo Limite')],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
