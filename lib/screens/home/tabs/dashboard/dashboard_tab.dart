import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/components/transaction_tile.dart';
import 'package:pocket_vault/theme/app_theme.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';
import 'package:pocket_vault/utils/transactions_extension.dart';

class DashboardTab extends ConsumerWidget with FilterActions {
  const DashboardTab({super.key});

  Widget _buildSummaryCard({
    required String label,
    required double value,
    required Color color,
    required IconData icon,
    required CurrencySymbolEnum currencySymbol,
    required AppColors appColors,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Icon(icon, color: color),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Text(
              value.toCurrency(
                code: currencySymbol.code,
                locale: currencySymbol.locale,
              ),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myLocale = Localizations.localeOf(context);
    final appColors = Theme.of(context).extension<AppColors>()!;
    final currencySymbol = ref.watch(preferencesProvider).currencySymbol;
    final summary = ref.watch(transactionSummaryProvider);
    final transactionsAsync = ref.watch(transactionListProvider);
    final filter = ref.watch(transactionFilterProvider);

    final displayYear =
        filter.start?.toMonthYear(myLocale) ??
        DateTime.now().toMonthYear(myLocale);

    return Column(
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo Total'),
                Text(
                  summary.balance.toCurrency(
                    code: currencySymbol.code,
                    locale: currencySymbol.locale,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                label: 'Entradas',
                value: summary.totalIncomes,
                color: appColors.income,
                icon: LucideIcons.circleArrowUp,
                currencySymbol: currencySymbol,
                appColors: appColors,
              ),
            ),
            Expanded(
              child: _buildSummaryCard(
                label: 'Saídas',
                value: summary.totalExpenses,
                color: appColors.expense,
                icon: LucideIcons.circleArrowDown,
                currencySymbol: currencySymbol,
                appColors: appColors,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Histórico',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    displayYear,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                child: transactionsAsync.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma transação no período'),
                      );
                    }

                    final groupedByYear = transactions.groupByYearAndDate();

                    final grouped = {
                      for (var yearMap in groupedByYear.values) ...yearMap,
                    };

                    final sortedDates = grouped.keys.toList()
                      ..sort((a, b) => b.compareTo(a));

                    return ListView.builder(
                      itemCount: sortedDates.length + 1,
                      itemBuilder: (context, dateIndex) {
                        if (dateIndex == sortedDates.length) {
                          return const SizedBox(height: 25);
                        }

                        final DateTime date = sortedDates[dateIndex];
                        final List<Transaction> dayTransactions =
                            grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Text(
                                date.toShortDate(myLocale),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            ...dayTransactions.map(
                              (t) => TransactionTile(transaction: t),
                            ),
                            const Divider(height: 1),
                          ],
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      Center(child: Text('Erro: $error')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
