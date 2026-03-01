import 'package:pocket_vault/models/transaction.dart';

extension TransactionGrouping on List<Transaction> {
  Map<int, Map<DateTime, List<Transaction>>> groupByYearAndDate() {
    final Map<int, Map<DateTime, List<Transaction>>> yearGrouped = {};

    for (final t in this) {
      final year = t.date.year;
      final date = DateTime(t.date.year, t.date.month, t.date.day);

      // Garante que o mapa do ano existe
      yearGrouped.putIfAbsent(year, () => {});

      // Garante que a lista do dia existe dentro daquele ano
      yearGrouped[year]!.putIfAbsent(date, () => []).add(t);
    }
    return yearGrouped;
  }

  Map<DateTime, List<Transaction>> groupByDate() {
    final Map<DateTime, List<Transaction>> grouped = {};

    for (final t in this) {
      final date = DateTime(t.date.year, t.date.month, t.date.day);

      grouped.putIfAbsent(date, () => []).add(t);
    }

    return grouped;
  }
}
