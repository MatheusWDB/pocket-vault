import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/providers/transaction_provider.dart';
import 'package:pocket_vault/services/category_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@riverpod
CategoryService categoryService(Ref ref) {
  return CategoryService();
}

@riverpod
class CategoryList extends _$CategoryList {
  @override
  Future<List<Category>> build() async {
    final service = ref.watch(categoryServiceProvider);

    return await service.getAllCategories();
  }

  Future<void> upsertCategory(Category category) async {
    final service = ref.read(categoryServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.saveCategory(category);

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
Map<int, double> categoriesTotalSpent(Ref ref) {
  final transactions = ref.watch(transactionListProvider).value ?? [];

  final Map<int, double> totals = {};
  for (final t in transactions) {
    if (t.amount < 0) {
      totals[t.category.id!] = (totals[t.category.id!] ?? 0) + t.amount.abs();
    }
  }
  return totals;
}

@riverpod
List<Category> categoriesAvailableForBudget(Ref ref) {
  final categoriesAsync = ref.watch(categoryListProvider);

  return categoriesAsync.maybeWhen(
    data: (categories) => categories
        .where((c) => c.budgetLimit == null || c.budgetLimit == 0.0)
        .toList(),
    orElse: () => [],
  );
}
