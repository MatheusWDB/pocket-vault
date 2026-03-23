import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';
import 'package:printing/printing.dart';

enum ReportPageType { summary, charts, statement }

class ReportPdfService {
  final List<Transaction> transactions;
  final Map<Category, double> totals;
  final CurrencySymbolEnum currency;
  final Locale locale;

  ReportPdfService({
    required this.transactions,
    required this.totals,
    required this.locale,
    required this.currency,
  });

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    //final fontData = await rootBundle.load('assets/fonts/lucide.ttf');
    //final lucideFont = pw.Font.ttf(fontData);

    pdf.addPage(
      index: 0,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(context, ReportPageType.summary),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildSummaryContent(context),
      ),
    );

    pdf.addPage(
      index: 1,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(
          context,
          ReportPageType.charts,
          'Análise Visual de Orçamentos',
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildChartsContent(context),
      ),
    );

    pdf.addPage(
      index: 2,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(
          context,
          ReportPageType.statement,
          'Histórico de Transações',
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildStatementContent(context),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildHeader(
    pw.Context context,
    ReportPageType type, [
    String? title,
  ]) {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              if (type == ReportPageType.summary) ...[
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'PocketVault',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    pw.Text(
                      'SOBERANIA FINACEIRA PESSOAL',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'RELATÓRIO MENSAL',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('MAR/2026', style: pw.TextStyle(fontSize: 20)),
                  ],
                ),
              ] else ...[
                pw.Text(
                  'PocketVault',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  title!,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ],
          ),
          pw.Divider(),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              /**
                  pw.Row(
                  children: [
                  pw.Icon(
                  pw.IconData(0xe900),
                  //font: lucideFont,
                  size: 20,
                  color: PdfColors.blue,
                  ),
                  ],
                  ),
               */
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Privacidade Total'),
                  pw.Text('Processamento 100% Offline.'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Página ${context.pageNumber} de ${context.pagesCount}',
                    //style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'PocketVault - ${DateTime.now().toFullDateNumeric(locale)}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      //fontWeight: pw.FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _buildSummaryContent(pw.Context context) {
    double expense = 0.0;
    double income = 0.0;

    for (Transaction t in transactions) {
      t.amount < 0 ? expense += t.amount.abs() : income += t.amount.abs();
    }

    final double total = income - expense;

    final budgetCategories = totals.keys
        .where((c) => c.budgetLimit != null && c.budgetLimit! > 0)
        .where((c) {
          final spent = totals[c] ?? 0.0;
          final limit = c.budgetLimit!;
          return spent / limit >= 0.8;
        })
        .toList();

    final highlights = budgetCategories.isNotEmpty;

    return [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
        children: [
          pw.Container(
            color: PdfColors.grey300,
            child: pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.Container(width: 3, height: 25, color: PdfColors.green),
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('TOTAL ENTRADAS'),
                        pw.Text(
                          '+ ${income.toCurrency(code: currency.code, locale: currency.locale)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          pw.SizedBox(width: 15),

          pw.Container(
            color: PdfColors.grey300,
            child: pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.Container(width: 3, height: 25, color: PdfColors.red),
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('TOTAL SAÍDAS'),
                        pw.Text(
                          '- ${expense.toCurrency(code: currency.code, locale: currency.locale)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      pw.SizedBox(height: 16),

      pw.Container(
        padding: pw.EdgeInsets.all(20),
        width: double.infinity,
        decoration: pw.BoxDecoration(
          color: PdfColors.blue,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Column(
          children: [
            pw.Text('SALDO FINAL'),
            pw.Text(
              total.toCurrency(code: currency.code, locale: currency.locale),
            ),
          ],
        ),
      ),

      if (highlights) ...[
        pw.Text('Destaques do Período'),
        pw.Divider(),

        pw.ListView.builder(
          itemCount: budgetCategories.length,
          itemBuilder: (context, index) {
            final category = budgetCategories[index];

            final spent = totals[category] ?? 0.0;
            final limit = category.budgetLimit!;

            final progress = spent / limit;

            late final String alertText;
            late final String descriptionText;

            final categoryName = category.name;

            final bool isOverBudget = progress > 1.0;
            final percentage = isOverBudget
                ? '${((progress - 1.0) * 100).toStringAsFixed(2)}%'
                : '${(progress * 100).toStringAsFixed(2)}%';

            if (progress > 1.0) {
              alertText = 'Limite Excedido em \'$categoryName\'';
              descriptionText =
                  'Você superou o limite orçamentário em $percentage.';
            } else if (progress == 1.0) {
              alertText = 'Limite Atingido em \'$categoryName\'';
              descriptionText = 'Você atingiu o limite orçamentário.';
            } else {
              alertText = 'Limite Próximo em \'$categoryName\'';
              descriptionText =
                  'Você atingiu $percentage do limite orçamentário.';
            }

            return pw.Container(
              child: pw.Row(
                children: [
                  pw.Container(
                    color: _getStatusColor(progress),
                    height: 20,
                    width: 5,
                  ),
                  pw.SizedBox(width: 16),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(alertText, overflow: pw.TextOverflow.clip),
                      pw.Text(
                        descriptionText,
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ];
  }

  List<pw.Widget> _buildChartsContent(pw.Context context) {
    final budgetCategories = totals.keys
        .where((c) => c.budgetLimit != null && c.budgetLimit! > 0)
        .toList();

    return [
      pw.SizedBox(height: 16),

      pw.Text(
        'Controle de Orçamentos',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
      pw.Divider(),

      pw.SizedBox(height: 8),

      pw.ListView.builder(
        itemCount: budgetCategories.length,
        spacing: 10,
        itemBuilder: (context, index) {
          final category = budgetCategories[index];

          final categoryName = category.name;

          final spent = totals[category] ?? 0.0;
          final limit = category.budgetLimit!;

          final progress = spent / limit;

          final spentText = spent.toCurrency(
            code: currency.code,
            locale: currency.locale,
          );
          final limitText = limit.toCurrency(
            code: currency.code,
            locale: currency.locale,
          );

          final bool isOverBudget = progress > 1.0;
          final double percentage = isOverBudget
              ? (progress - 1.0) * 100
              : progress * 100;

          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(categoryName, overflow: pw.TextOverflow.span),
                  pw.Text(
                    '$spentText de $limitText',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: _getStatusColor(progress),
                    ),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.LinearProgressIndicator(
                    minHeight: 6,
                    value: progress,
                    valueColor: _getStatusColor(progress),
                    backgroundColor: PdfColors.grey,
                  ),
                  if (progress >= 0.8) ...[
                    pw.SizedBox(height: 4),
                    pw.Text(
                      !isOverBudget
                          ? 'Atenção: ${percentage.toStringAsFixed(2)}% do teto atingido.'
                          : 'Atenção: Teto estourado em ${percentage.toStringAsFixed(2)}%.',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(progress),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    ];
  }

  List<pw.Widget> _buildStatementContent(pw.Context context) {
    return [
      pw.Text('Extrato Detalhado'),
      pw.Divider(),

      pw.SizedBox(height: 16),

      pw.Row(
        //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.SizedBox(width: 50, child: pw.Text('DATA')),
          pw.Expanded(child: pw.Text('TÍTULO', textAlign: pw.TextAlign.start)),
          pw.Expanded(
            child: pw.Text('CATEGORIA', textAlign: pw.TextAlign.center),
          ),
          pw.Expanded(child: pw.Text('VALOR', textAlign: pw.TextAlign.end)),
        ],
      ),

      pw.SizedBox(height: 4),
      pw.Divider(height: 2, color: PdfColors.grey),
      pw.SizedBox(height: 4),

      pw.ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (context, index) => pw.Column(
          children: [
            pw.SizedBox(height: 4),
            pw.Divider(height: 2, color: PdfColors.grey),
            pw.SizedBox(height: 4),
          ],
        ),
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          return pw.Row(
            //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.SizedBox(
                width: 50,
                child: pw.Text(transaction.date.toShortDate(locale, false)),
              ),
              pw.Expanded(
                child: pw.Text(
                  transaction.title,
                  textAlign: pw.TextAlign.start,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  transaction.category.name,
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  transaction.amount.toCurrency(
                    code: currency.code,
                    locale: currency.locale,
                  ),
                  textAlign: pw.TextAlign.end,
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  PdfColor _getStatusColor(double val) {
    if (val > 1.0) return PdfColors.red700;
    if (val == 1.0) return PdfColors.orange700;
    if (val >= 0.8) return PdfColors.amber600;

    return PdfColors.green600;
  }
}
