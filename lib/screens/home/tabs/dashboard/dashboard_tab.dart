import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/components/transaction_tile.dart';
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
  }) {
    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8.0,
              children: [
                Icon(icon, color: color),
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    final currencySymbol = ref.watch(preferencesProvider).currencySymbol;
    final summary = ref.watch(transactionSummaryProvider);
    final transactionsAsync = ref.watch(transactionListProvider);
    final filter = ref.watch(transactionFilterProvider);

    final displayYear = filter.start?.year ?? DateTime.now().year;

    return Column(
      spacing: 16.0,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo Total', style: TextStyle(color: Colors.grey)),
                Text(
                  summary.balance.toCurrency(
                    code: currencySymbol.code,
                    locale: currencySymbol.locale,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            IconButton(
              onPressed: () =>
                  showFilterPicker(context, showAllYearsOption: false),
              icon: const Icon(LucideIcons.funnel),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                label: 'Entradas',
                value: summary.totalIncomes,
                color: Colors.green,
                icon: LucideIcons.circleArrowUp,
                currencySymbol: currencySymbol,
              ),
            ),
            Expanded(
              child: _buildSummaryCard(
                label: 'Saídas',
                value: summary.totalExpenses,
                color: Colors.red,
                icon: LucideIcons.circleArrowDown,
                currencySymbol: currencySymbol,
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
                    displayYear.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
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
                      itemCount: sortedDates.length,
                      itemBuilder: (context, dateIndex) {
                        final date = sortedDates[dateIndex];
                        final dayTransactions = grouped[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: Text(
                                date.toHeaderFormat('$myLocale'),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            ...dayTransactions.map(
                              (t) => TransactionTile(
                                transaction: t
                              ),
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
