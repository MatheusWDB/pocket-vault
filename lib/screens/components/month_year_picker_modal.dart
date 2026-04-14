import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/utils/string_extensions.dart';

class MonthYearPickerModal extends ConsumerStatefulWidget {
  final bool showAllYearsOption;
  final bool showAllMonthsOption;

  const MonthYearPickerModal({
    super.key,
    this.showAllMonthsOption = true,
    this.showAllYearsOption = true,
  });

  @override
  ConsumerState<MonthYearPickerModal> createState() => _FilterPickerState();
}

class _FilterPickerState extends ConsumerState<MonthYearPickerModal> {
  late int? selectedYear;
  late int? selectedMonth;

  void _onPressedClear() {
    final filterNotifier = ref.read(transactionFilterProvider.notifier);
    filterNotifier.standardFilter();

    Navigator.pop(context);
  }

  void _onPressedConfirm() {
    final filterNotifier = ref.read(transactionFilterProvider.notifier);
    if (selectedYear == null) {
      filterNotifier.clearDateRange();
    } else {
      final int month = selectedMonth ?? 1;
      final startDate = DateTime(selectedYear!, month);

      final endDate = selectedMonth == null
          ? DateTime(selectedYear!, 12, 31, 23, 59, 59)
          : DateTime(selectedYear!, month + 1, 0, 23, 59, 59);

      filterNotifier.setDateRange(startDate, endDate);
    }

    Navigator.pop(context);
  }

  void _onSelectedItemChangedMonth(int index) {
    setState(() {
      (widget.showAllMonthsOption)
          ? selectedMonth = index == 0 ? null : index
          : selectedMonth = index + 1;
    });
  }

  void _onSelectedItemChangedYear(int index, DateTime now) {
    setState(() {
      (widget.showAllYearsOption)
          ? selectedYear = index == 0 ? null : now.year - (index - 1)
          : selectedYear = now.year - index;

      if (selectedYear == null) selectedMonth = null;

      if (selectedYear == now.year &&
          selectedMonth != null &&
          selectedMonth! > now.month) {
        selectedMonth = now.month;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(transactionFilterProvider);
    final now = DateTime.now();

    selectedYear = currentFilter.start?.year;
    if (!widget.showAllYearsOption && selectedYear == null) {
      selectedYear = now.year;
    }

    final startMonth = currentFilter.start?.month;
    final endMonth = currentFilter.end?.month;

    final bool isFullYear =
        (startMonth == 1 && endMonth == 12 && currentFilter.end?.day == 31);

    selectedMonth = (widget.showAllMonthsOption)
        ? isFullYear
              ? null
              : startMonth
        : startMonth ?? now.month;
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final int initialYearIndex = (widget.showAllYearsOption)
        ? selectedYear == null
              ? 0
              : (now.year - selectedYear! + 1)
        : now.year - (selectedYear ?? now.year);

    final int initialMonthIndex = (widget.showAllMonthsOption)
        ? selectedMonth ?? 0
        : (selectedMonth ?? now.month) - 1;

    final List<Widget> monthWidgets = [];
    if (widget.showAllMonthsOption) {
      monthWidgets.add(const Center(child: Text('Todos')));
    }

    if (selectedYear != null) {
      final int monthsToGenerate = selectedYear! < now.year ? 12 : now.month;

      monthWidgets.addAll(
        List.generate(
          monthsToGenerate,
          (i) => Center(
            child: Text(
              DateFormat(
                'MMMM',
                '$myLocale',
              ).format(DateTime(2024, i + 1)).capitalize(),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(t.selectPeriod, style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => _onPressedClear(),
                child: Text(t.clearFilter),
              ),
              TextButton(
                onPressed: () => _onPressedConfirm(),
                child: Text(t.confirm),
              ),
            ],
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    key: ValueKey(selectedYear),
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialMonthIndex,
                    ),
                    onSelectedItemChanged: (index) =>
                        _onSelectedItemChangedMonth(index),
                    children: monthWidgets,
                  ),
                ),

                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialYearIndex,
                    ),
                    onSelectedItemChanged: (index) =>
                        _onSelectedItemChangedYear(index, now),
                    children: [
                      if (widget.showAllYearsOption) Center(child: Text(t.all)),
                      ...List.generate(
                        10,
                        // Aqui vai mudar para (now.year - ano da primeira transação)
                        (i) => Center(child: Text('${now.year - i}')),
                      ),
                    ],
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
