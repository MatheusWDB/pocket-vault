import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filter_provider.g.dart';

typedef TransactionFilters = ({
  int? categoryId,
  DateTime? start,
  DateTime? end,
});

@riverpod
class TransactionFilter extends _$TransactionFilter {
  @override
  TransactionFilters build() {
    final now = DateTime.now();

    return (
      categoryId: null,
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );
  }

  void setCategory(int? id) {
    state = (categoryId: id, start: state.start, end: state.end);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = (categoryId: state.categoryId, start: start, end: end);
  }

  void clear() {
    final now = DateTime.now();

    state = (
      categoryId: null,
      start: DateTime(now.year, now.month),
      end: DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    );
  }
}
