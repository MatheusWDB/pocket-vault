import 'package:pocket_vault/models/category.dart';
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

  Future<void> saveCategory(Category c) async {
    final service = ref.read(categoryServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.saveCategory(c);
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
