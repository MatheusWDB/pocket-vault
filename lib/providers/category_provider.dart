import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/providers/database_provider.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@riverpod
CategoryService categoryService(Ref ref) =>
    CategoryService(dbHelper: ref.watch(databaseHelperProvider));

@Riverpod(keepAlive: true)
class CategoryList extends _$CategoryList {
  @override
  Future<List<Category>> build() async {
    final service = ref.watch(categoryServiceProvider);

    return await service.getAllCategories();
  }

  Future<void> upsertCategory(Category category) async {
    final service = ref.read(categoryServiceProvider);

    state = await AsyncValue.guard(() async {
      await service.upsertCategory(category);

      ref.invalidate(transactionListProvider);

      ref.invalidateSelf();

      return await future;
    });
  }

  Future<void> deleteCategory(int id) async {
    final service = ref.read(categoryServiceProvider);
    final current = state.value ?? [];

    state = await AsyncValue.guard(() async {
      await service.deleteCategory(id);

      current.removeWhere((c) => c.id == id);

      return current;
    });
  }
}

@riverpod
Map<Category, double> totalSpentByCategory(Ref ref) {
  final transactions = ref.watch(transactionListProvider).value ?? [];

  final Map<Category, double> totals = {};
  for (final t in transactions) {
    if (t.amount < 0.0) {
      totals[t.category] = (totals[t.category] ?? 0.0) + t.amount.abs();
    }
  }
  final sortedEntries = totals.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));

  return Map.fromEntries(sortedEntries);
}

@riverpod
List<Category> categoriesWithoutBudget(Ref ref) {
  final categoriesAsync = ref.watch(categoryListProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories
        .where((c) => c.budgetLimit == null || c.budgetLimit == 0.0)
        .toList(),
    orElse: () => [],
  );
}
