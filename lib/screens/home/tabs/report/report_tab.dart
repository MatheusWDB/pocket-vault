import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/providers/category_provider.dart';
import 'package:pocket_vault/providers/loading_provider.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/providers/user_preferences_provider.dart';
import 'package:pocket_vault/screens/components/filter_actions_mixin.dart';
import 'package:pocket_vault/screens/home/tabs/report/widgets/category_legend_item.dart';
import 'package:pocket_vault/services/report_pdf_service.dart';
import 'package:pocket_vault/utils/app_alerts.dart';
import 'package:pocket_vault/utils/category_color_utils.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';

class ReportTab extends ConsumerStatefulWidget {
  const ReportTab({super.key});

  @override
  ConsumerState<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends ConsumerState<ReportTab> with FilterActions {
  Future<void> _onPressedExportPDF(
    Map<Category, double> totalExpenses,
    CurrencySymbolEnum currency,
    Locale myLocale,
    AppLocalizations t,
  ) async {
    final loadingNotifier = ref.read(loadingStateProvider.notifier);
    loadingNotifier.setLoading(true);

    try {
      final transactionState = ref.read(transactionListProvider);

      await transactionState.when(
        data: (data) async {
          await ReportPdfService(
            transactions: data,
            totalExpenses: totalExpenses,
            currency: currency,
            locale: myLocale,
            t: t,
          ).generatePdf();
        },
        error: (error, _) {
          if (mounted) AppAlerts.error(context, message: error.toString());
        },
        loading: () {},
      );
    } finally {
      loadingNotifier.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final myLocale = Localizations.localeOf(context);
    final currency = ref.watch(preferencesProvider).currencySymbol;
    final filter = ref.watch(transactionFilterProvider);
    final totalExpenses = ref.watch(totalSpentByCategoryProvider);

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

                              final categoryColor = category.color;

                              return PieChartSectionData(
                                value: value,
                                showTitle: false,
                                color: categoryColor == null
                                    ? CategoryColorUtils.getCategoryColor(
                                        category.id,
                                      )
                                    : Color(
                                        int.parse(categoryColor, radix: 16),
                                      ),
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
                              t.totalSpent,
                              style: TextStyle(
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
                        spacing: 20,
                        runSpacing: 12,
                        children: totalExpenses.entries.map((e) {
                          final category = e.key;
                          final value = e.value;

                          final percentage =
                              '${(value * 100 / total).toStringAsFixed(2)}%';

                          return CategoryLegendItem(
                            category: category,
                            percentage: percentage,
                            width: itemWidth,
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
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () =>
              _onPressedExportPDF(totalExpenses, currency, myLocale, t),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(LucideIcons.save), Text(t.generatePdf)],
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }
}
