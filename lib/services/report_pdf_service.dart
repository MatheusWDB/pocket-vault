import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/utils/date_time_extension.dart';
import 'package:pocket_vault/utils/double_extensions.dart';
import 'package:printing/printing.dart';

enum ReportPageType { summary, charts, statement }

class ReportPdfService {
  final List<Transaction> transactions;
  final Map<Category, double> totalExpenses;
  final CurrencySymbolEnum currency;
  final Locale locale;
  final AppLocalizations t;

  // ── Paleta ────────────────────────────────────────────────
  static const _primary = PdfColor.fromInt(0xFF1E3A5F);
  static const _income = PdfColor.fromInt(0xFF16A34A);
  static const _expense = PdfColor.fromInt(0xFFDC2626);
  static const _surface = PdfColor.fromInt(0xFFF8FAFC);
  static const _border = PdfColor.fromInt(0xFFE2E8F0);
  static const _textPrimary = PdfColor.fromInt(0xFF0F172A);
  static const _textMuted = PdfColor.fromInt(0xFF64748B);
  static const _white = PdfColors.white;

  ReportPdfService({
    required this.t,
    required this.transactions,
    required this.totalExpenses,
    required this.locale,
    required this.currency,
  });

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    final robotoRegular = await PdfGoogleFonts.robotoRegular();
    final robotoBold = await PdfGoogleFonts.robotoBold();

    final theme = pw.ThemeData.withFont(base: robotoRegular, bold: robotoBold);

    pdf.addPage(
      index: 0,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        header: (context) => _buildHeader(context, ReportPageType.summary),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildSummaryContent(context),
      ),
    );

    pdf.addPage(
      index: 1,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        header: (context) => _buildHeader(
          context,
          ReportPageType.charts,
          t.visualBudgetAnalysis,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildChartsContent(context),
      ),
    );

    pdf.addPage(
      index: 2,
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        header: (context) => _buildHeader(
          context,
          ReportPageType.statement,
          t.transactionHistory,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => _buildStatementContent(context),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // ── Header ────────────────────────────────────────────────
  pw.Widget _buildHeader(pw.Context _, ReportPageType type, [String? title]) {
    final now = DateTime.now();
    final monthYear = now.toMonthYear(locale).toUpperCase();

    final fontWeitgh = pw.FontWeight.bold;
    final spacing = pw.SizedBox(height: 8);

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Container(
                  width: 6,
                  height: 32,
                  decoration: pw.BoxDecoration(
                    color: _primary,
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      t.pocketVault,
                      style: pw.TextStyle(
                        fontWeight: fontWeitgh,
                        fontSize: type == ReportPageType.summary ? 22 : 16,
                        color: _primary,
                      ),
                    ),
                    pw.Text(
                      t.personalFinancialSovereignty,
                      style: pw.TextStyle(fontSize: 9, color: _textMuted),
                    ),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  type == ReportPageType.summary
                      ? t.monthlyReport
                      : title!.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: fontWeitgh,
                    color: _textMuted,
                    letterSpacing: 1,
                  ),
                ),
                pw.Text(
                  monthYear,
                  style: pw.TextStyle(
                    fontSize: type == ReportPageType.summary ? 18 : 13,
                    fontWeight: fontWeitgh,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
        spacing,
        pw.Divider(color: _border, thickness: 1),
        spacing,
      ],
    );
  }

  // ── Footer ────────────────────────────────────────────────
  pw.Widget _buildFooter(pw.Context context) {
    final style = pw.TextStyle(fontSize: 8, color: _textMuted);

    return pw.Column(
      children: [
        pw.Divider(color: _border, thickness: 1),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Row(
              children: [
                pw.Container(
                  width: 6,
                  height: 6,
                  decoration: pw.BoxDecoration(
                    color: _income,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 4),
                pw.Text(t.offlineDataProcessing, style: style),
              ],
            ),
            pw.Text(
              t.pdfFooter(
                context.pageNumber,
                context.pagesCount,
                DateTime.now().toFullDateNumeric(locale),
              ),
              style: style,
            ),
          ],
        ),
      ],
    );
  }

  // ── Página 1: Resumo ──────────────────────────────────────
  List<pw.Widget> _buildSummaryContent(pw.Context _) {
    double expense = 0.0;
    double income = 0.0;
    for (final t in transactions) {
      t.amount < 0 ? expense += t.amount.abs() : income += t.amount.abs();
    }
    final double balance = income - expense;

    final budgetCategories = totalExpenses.keys
        .where((c) => c.budgetLimit != null && c.budgetLimit! > 0)
        .where((c) => (totalExpenses[c] ?? 0.0) / c.budgetLimit! >= 0.8)
        .toList();

    String fmt(double v) =>
        v.toCurrency(code: currency.code, locale: currency.locale);

    final color = _white.flatten();

    return [
      // Cards de entradas / saídas
      pw.Row(
        children: [
          pw.Expanded(
            child: _summaryCard(
              t.entries.toUpperCase(),
              fmt(income),
              _income,
              isIncome: true,
            ),
          ),
          pw.SizedBox(width: 12),
          pw.Expanded(
            child: _summaryCard(
              t.outputs.toUpperCase(),
              fmt(expense),
              _expense,
              isIncome: false,
            ),
          ),
        ],
      ),

      pw.SizedBox(height: 12),

      // Card de saldo
      pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: pw.BoxDecoration(
          color: _primary,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              t.monthlyBalance,
              style: pw.TextStyle(fontSize: 10, color: color, letterSpacing: 1),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              fmt(balance),
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 24),

      // Destaques
      if (budgetCategories.isNotEmpty) ...[
        _sectionTitle(t.budgetAlerts),
        pw.SizedBox(height: 8),
        ...budgetCategories.map((category) {
          final spent = totalExpenses[category] ?? 0.0;
          final limit = category.budgetLimit!;
          final progress = spent / limit;
          final isOver = progress > 1.0;
          final pct = isOver
              ? '${((progress - 1.0) * 100).toStringAsFixed(2)}%'
              : '${(progress * 100).toStringAsFixed(2)}%';

          final alertText = isOver
              ? t.limitExceededBy(pct)
              : progress == 1.0
              ? t.limitReached
              : t.limitPercentageReached(pct);

          final color = _getStatusColor(progress);

          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 8),
            decoration: pw.BoxDecoration(
              color: _surface,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: _border),
            ),
            child: pw.ClipRRect(
              horizontalRadius: 6,
              verticalRadius: 6,
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(12),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  category.name,
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    color: _textPrimary,
                                  ),
                                ),
                                pw.Text(
                                  alertText,
                                  style: pw.TextStyle(
                                    fontSize: 11,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          pw.Text(
                            t.spentOverLimit(fmt(spent), fmt(limit)),
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: color,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ];
  }

  // ── Página 2: Gráficos / Orçamentos ──────────────────────
  List<pw.Widget> _buildChartsContent(pw.Context _) {
    final budgetCategories = totalExpenses.keys
        .where((c) => c.budgetLimit != null && c.budgetLimit! > 0)
        .toList();

    String fmt(double v) =>
        v.toCurrency(code: currency.code, locale: currency.locale);

    return [
      _sectionTitle(t.budgetControl),
      pw.SizedBox(height: 12),

      if (budgetCategories.isEmpty)
        pw.Center(
          child: pw.Text(
            t.noBudgetsConfigured,
            style: pw.TextStyle(color: _textMuted),
          ),
        )
      else
        pw.ListView.builder(
          itemCount: budgetCategories.length,
          spacing: 12,
          itemBuilder: (context, index) {
            final category = budgetCategories[index];
            final spent = totalExpenses[category] ?? 0.0;
            final limit = category.budgetLimit!;
            final progress = spent / limit;
            final color = _getStatusColor(progress);
            final isOver = progress > 1.0;
            final pct = isOver
                ? ((progress - 1.0) * 100).toStringAsFixed(1)
                : (progress * 100).toStringAsFixed(1);
            final fontWeight = pw.FontWeight.bold;

            return pw.Container(
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: _surface,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: _border),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        category.name,
                        style: pw.TextStyle(
                          fontWeight: fontWeight,
                          fontSize: 12,
                          color: _textPrimary,
                        ),
                      ),
                      pw.Text(
                        t.spentOfLimit(fmt(spent), fmt(limit)),
                        style: pw.TextStyle(fontSize: 11, color: color),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.LinearProgressIndicator(
                    minHeight: 8,
                    value: progress.clamp(0.0, 1.0),
                    valueColor: color,
                    backgroundColor: _border,
                  ),
                  if (progress >= 0.8) ...[
                    pw.SizedBox(height: 6),
                    pw.Text(
                      isOver ? t.budgetExceeded(pct) : t.budgetWarning(pct),
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
    ];
  }

  // ── Página 3: Extrato ─────────────────────────────────────
  List<pw.Widget> _buildStatementContent(pw.Context _) {
    final style = pw.TextStyle(
      fontSize: 9,
      fontWeight: pw.FontWeight.bold,
      color: _white.flatten(),
      letterSpacing: 0.5,
    );

    return [
      _sectionTitle(t.detailedStatement),
      pw.SizedBox(height: 12),

      // Cabeçalho da tabela
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: pw.BoxDecoration(
          color: _primary,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Row(
          children: [
            pw.SizedBox(
              width: 55,
              child: pw.Text(t.date.toUpperCase(), style: style),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Text(t.title.toUpperCase(), style: style),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                t.category.toUpperCase(),
                textAlign: pw.TextAlign.center,
                style: style,
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                t.value.toUpperCase(),
                textAlign: pw.TextAlign.right,
                style: style,
              ),
            ),
          ],
        ),
      ),

      pw.SizedBox(height: 4),

      pw.ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final isIncome = transaction.amount > 0;
          final isEven = index % 2 == 0;
          final style = pw.TextStyle(fontSize: 10, color: _textMuted);
          final fontWeight = pw.FontWeight.bold;

          return pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 12),
            decoration: pw.BoxDecoration(
              color: isEven ? _white.flatten() : _surface,
              border: pw.Border(
                bottom: pw.BorderSide(color: _border, width: 0.5),
              ),
            ),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 55,
                  child: pw.Text(
                    transaction.date.toShortDate(locale, null, false),
                    style: style,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    transaction.title,
                    style: pw.TextStyle(
                      fontSize: 10,
                      color: _textPrimary,
                      fontWeight: fontWeight,
                    ),
                    overflow: pw.TextOverflow.clip,
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    transaction.category.name,
                    textAlign: pw.TextAlign.center,
                    style: style,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    transaction.amount.toCurrency(
                      code: currency.code,
                      locale: currency.locale,
                    ),
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: fontWeight,
                      color: isIncome ? _income : _expense,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  pw.Widget _summaryCard(
    String label,
    String value,
    PdfColor color, {
    required bool isIncome,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: _surface,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: _border),
      ),
      child: pw.ClipRRect(
        horizontalRadius: 10,
        verticalRadius: 10,
        child: pw.Row(
          children: [
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      label,
                      style: pw.TextStyle(
                        fontSize: 9,
                        color: _textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      t.transactionValue(isIncome ? '+' : '-', value),
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _sectionTitle(String text) {
    return pw.Row(
      children: [
        pw.Container(
          width: 4,
          height: 16,
          decoration: pw.BoxDecoration(
            color: _primary,
            borderRadius: pw.BorderRadius.circular(2),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: _primary,
          ),
        ),
      ],
    );
  }

  PdfColor _getStatusColor(double val) {
    if (val > 1.0) return PdfColors.red700;
    if (val == 1.0) return PdfColors.orange700;
    if (val >= 0.8) return PdfColors.amber600;
    return PdfColors.green600;
  }
}
