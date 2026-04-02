import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/services/report_pdf_service.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class ReportTab extends ConsumerStatefulWidget {
  const ReportTab({super.key});

  @override
  ConsumerState<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends ConsumerState<ReportTab> with FilterActions {
  // Remover para deixar um cor definida para cada categoria
  Color _getCategoryColor(int? id) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.purple,
      Colors.cyan,
      Colors.orange,
      Colors.indigo,
      Colors.teal,
      Colors.pink,
      Colors.lime,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,

      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.amberAccent,
      Colors.purpleAccent,
      Colors.cyanAccent,
      Colors.orangeAccent,
      Colors.indigoAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.limeAccent,
      Colors.deepPurpleAccent,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.deepOrangeAccent,

      Colors.blueGrey,
      Colors.brown,
      Colors.grey,
      Colors.black,
      Colors.yellow,
      Colors.blue[900]!,
      Colors.red[900]!,
      Colors.green[900]!,
      Colors.brown[300]!,
      Colors.grey[400]!,
    ];
    return colors[(id ?? 0) % colors.length];
  }

  Widget _buildLegendItem(String label, Color color, double width) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final currency = ref.watch(preferencesProvider).currencySymbol;
    final filter = ref.watch(transactionFilterProvider);
    final totalExpenses = ref.watch(categoriesTotalSpentProvider);

    final total = totalExpenses.values.fold(0.0, (sum, item) => sum + item);

    return Column(
      spacing: 10,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeOutCubic,
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 100,

                            sections: totalExpenses.entries.map((e) {
                              final category = e.key;
                              final value = e.value;

                              return PieChartSectionData(
                                value: value,
                                showTitle: false,
                                color: _getCategoryColor(category.id),
                                radius: 20,
                                borderSide: BorderSide(width: 0.5),
                              );
                            }).toList(),
                          ),
                        ),

                        Column(
                          spacing: 4,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TOTAL GASTO',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              total.toCurrency(
                                code: currency.code,
                                locale: currency.locale,
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = totalExpenses.length == 1 ? 1 : 2;

                      final itemWidth = (constraints.maxWidth / columns) - 10;

                      return Wrap(
                        spacing: 10,
                        runSpacing: 12,
                        children: totalExpenses.entries.map((e) {
                          final category = e.key;
                          final value = e.value;

                          final label =
                              '${category.name} ${(value * 100 / total).toStringAsFixed(2)}%';

                          return _buildLegendItem(
                            label,
                            _getCategoryColor(category.id),
                            itemWidth,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), //
            ),
          ),
          onPressed: () async {
            final transactions = ref.watch(transactionListProvider).value ?? [];

            return await ReportPdfService(
              transactions: transactions,
              totalExpenses: totalExpenses,
              currency: currency,
              locale: myLocale,
            ).generatePdf();
          },
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(LucideIcons.save), Text('Exportar PDF')],
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
