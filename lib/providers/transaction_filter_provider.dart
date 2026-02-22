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
    return (categoryId: null, start: null, end: null);
  }

  void setCategory(int? id) {
    state = (categoryId: id, start: state.start, end: state.end);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = (categoryId: state.categoryId, start: start, end: end);
  }

  void clear() {
    state = (categoryId: null, start: null, end: null);
  }
}
