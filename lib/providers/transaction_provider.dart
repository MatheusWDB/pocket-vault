import 'package:pocket_vault/models/transaction.dart';
import 'package:pocket_vault/providers/transaction_filter_provider.dart';
import 'package:pocket_vault/services/transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
TransactionService transactionService(Ref ref) {
  return TransactionService();
}

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<Transaction>> build() async {
    final service = ref.watch(transactionServiceProvider);
    final filter = ref.watch(transactionFilterProvider);

    return await service.getTransactionsByFilter(
      categoryId: filter.categoryId,
      start: filter.start,
      end: filter.end,
    );
  }

  Future<void> addTransaction(Transaction t) async {
    final service = ref.read(transactionServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.createTransaction(t);
      return await future;
    });
  }

  Future<void> updateTransaction(Transaction t) async {
    final service = ref.read(transactionServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.updateTransaction(t);
      return await future;
    });
  }

  Future<void> removeTransaction(int id) async {
    final service = ref.read(transactionServiceProvider);
    final current = state.value ?? [];

    state = await AsyncValue.guard(() async {
      await service.deleteTransaction(id);

      current.removeWhere((t) => t.id == id);

      return current;
    });
  }
}

typedef TransactionSummary = ({
  double totalIncomes,
  double totalExpenses,
  double balance,
});

@riverpod
TransactionSummary transactionSummary(Ref ref) {
  final transactionsValue = ref.watch(transactionListProvider);

  final transactions = transactionsValue.value ?? [];

  double incomes = 0;
  double expenses = 0;

  for (final t in transactions) {
    if (t.amount > 0) {
      incomes += t.amount;
    } else {
      expenses += t.amount.abs();
    }
  }

  return (
    totalIncomes: incomes,
    totalExpenses: expenses,
    balance: incomes - expenses,
  );
}
