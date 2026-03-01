import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/utils/string_extensions.dart';

class MonthYearPickerModal extends ConsumerStatefulWidget {
  final bool showAllYearsOption;

  const MonthYearPickerModal({super.key, this.showAllYearsOption = true});

  @override
  ConsumerState<MonthYearPickerModal> createState() => _FilterPickerState();
}

class _FilterPickerState extends ConsumerState<MonthYearPickerModal> {
  late int? selectedYear;
  late int? selectedMonth;

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(transactionFilterProvider);

    selectedYear = currentFilter.start?.year;
    if (!widget.showAllYearsOption && selectedYear == null) {
      selectedYear = DateTime.now().year;
    }

    final startMonth = currentFilter.start?.month;
    final endMonth = currentFilter.end?.month;

    selectedMonth =
        (startMonth == 1 && endMonth == 12 && currentFilter.end?.day == 31)
        ? null
        : startMonth;
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final filterNotifier = ref.read(transactionFilterProvider.notifier);

    final now = DateTime.now();
    final int initialYearIndex;
    if (widget.showAllYearsOption) {
      initialYearIndex = selectedYear == null
          ? 0
          : (now.year - selectedYear! + 1);
    } else {
      initialYearIndex = now.year - (selectedYear ?? now.year);
    }

    final initialMonthIndex = selectedMonth ?? 0;

    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Selecionar Período',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  filterNotifier.standardFilter();

                  Navigator.pop(context);
                },
                child: const Text('Limpar Filtro'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedYear == null) {
                    filterNotifier.clearDateRange();
                  } else {
                    final startDate = DateTime(
                      selectedYear!,
                      selectedMonth ?? 1,
                    );

                    final endDate = DateTime(
                      selectedYear!,
                      selectedMonth == null ? 12 : selectedMonth! + 1,
                      selectedMonth == null ? 31 : 0,
                      23,
                      59,
                      59,
                    );

                    filterNotifier.setDateRange(startDate, endDate);
                  }

                  Navigator.pop(context);
                },
                child: const Text('Confirmar'),
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
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMonth = index == 0 ? null : index;
                      });
                    },
                    children: [
                      const Center(child: Text('Todos')),
                      if (selectedYear != null)
                        ...List.generate(
                          selectedYear! < now.year ? 12 : now.month,
                          (i) => Center(
                            child: Text(
                              DateFormat(
                                'MMMM',
                                '$myLocale',
                              ).format(DateTime(2024, i + 1)).capitalize(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: initialYearIndex,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        (widget.showAllYearsOption)
                            ? selectedYear = index == 0
                                  ? null
                                  : now.year - (index - 1)
                            : selectedYear = now.year - index;

                        if (selectedYear == null) {
                          selectedMonth = null;
                        }

                        if (selectedYear == now.year &&
                            selectedMonth != null &&
                            selectedMonth! > now.month) {
                          selectedMonth = now.month;
                        }
                      });
                    },
                    children: [
                      if (widget.showAllYearsOption)
                        const Center(child: Text('Todos')),
                      ...List.generate(
                        10, // Aqui vai mudar para (now.year - ano da primeira transação)
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
