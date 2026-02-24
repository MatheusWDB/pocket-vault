import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/month_year_picker_modal.dart';
import 'package:pocket_vault/screens/components/transacation_tile.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class DashboardTab extends ConsumerWidget {
  const DashboardTab({super.key});

  Map<DateTime, List<Transaction>> _groupTransactions(
    List<Transaction> transactions,
  ) {
    final Map<DateTime, List<Transaction>> grouped = {};
    for (var t in transactions) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);

      if (grouped[date] == null) grouped[date] = [];

      grouped[date]!.add(t);
    }

    return grouped;
  }

  String _formatHeaderDate(DateTime date) {
    if (date.isToday) return 'Hoje';
    if (date.isYesterday) return 'Ontem';

    return DateFormat('dd MMM', 'pt_BR').format(date);
  }

  void _showFilterPicker(BuildContext context) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return MonthYearPickerModal();
      },
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required double value,
    required Color color,
    required IconData icon,
    required CurrencySymbolEnum symbol,
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
              value.toCurrency(symbol),
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
    final preferences = ref.watch(preferencesProvider);
    final summary = ref.watch(transactionSummaryProvider);
    final transactionsAsync = ref.watch(transactionListProvider);
    final filter = ref.watch(transactionFilterProvider);

    final displayYear = filter.start?.year ?? DateTime.now().year;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 16.0,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo Total', style: TextStyle(color: Colors.grey)),
                  Text(
                    summary.balance.toCurrency(preferences.currencySymbol),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showFilterPicker(context),
                icon: Icon(LucideIcons.funnel),
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
                  symbol: preferences.currencySymbol,
                ),
              ),
              Expanded(
                child: _buildSummaryCard(
                  label: 'Saídas',
                  value: summary.totalExpenses,
                  color: Colors.red,
                  icon: LucideIcons.circleArrowDown,
                  symbol: preferences.currencySymbol,
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
                    Text(
                      'Histórico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      displayYear.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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

                      final grouped = _groupTransactions(transactions);

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
                                  _formatHeaderDate(date),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              ...dayTransactions.map(
                                (t) => TransactionTile(
                                  transaction: t,
                                  currencySymbol: preferences.currencySymbol,
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
                    error: (err, _) => Center(child: Text('Erro: $err')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
