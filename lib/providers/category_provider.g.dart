// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryService)
final categoryServiceProvider = CategoryServiceProvider._();

final class CategoryServiceProvider
    extends
        $FunctionalProvider<CategoryService, CategoryService, CategoryService>
    with $Provider<CategoryService> {
  CategoryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryServiceHash();

  @$internal
  @override
  $ProviderElement<CategoryService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CategoryService create(Ref ref) {
    return categoryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryService>(value),
    );
  }
}

String _$categoryServiceHash() => r'1b40a60d62f07f1e6dc53e9ec533964035b1e63e';

@ProviderFor(CategoryList)
final categoryListProvider = CategoryListProvider._();

final class CategoryListProvider
    extends $AsyncNotifierProvider<CategoryList, List<Category>> {
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  CategoryList create() => CategoryList();
}

String _$categoryListHash() => r'c9f9f757f237ea6967ad7eaa970c69093da02ad7';

abstract class _$CategoryList extends $AsyncNotifier<List<Category>> {
  FutureOr<List<Category>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(totalSpentByCategory)
final totalSpentByCategoryProvider = TotalSpentByCategoryProvider._();

final class TotalSpentByCategoryProvider
    extends
        $FunctionalProvider<
          Map<Category, double>,
          Map<Category, double>,
          Map<Category, double>
        >
    with $Provider<Map<Category, double>> {
  TotalSpentByCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalSpentByCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalSpentByCategoryHash();

  @$internal
  @override
  $ProviderElement<Map<Category, double>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<Category, double> create(Ref ref) {
    return totalSpentByCategory(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<Category, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<Category, double>>(value),
    );
  }
}

String _$totalSpentByCategoryHash() =>
    r'58e2d77e905b92a320042c4d7d778e4e9fc67942';

@ProviderFor(categoriesWithoutBudget)
final categoriesWithoutBudgetProvider = CategoriesWithoutBudgetProvider._();

final class CategoriesWithoutBudgetProvider
    extends $FunctionalProvider<List<Category>, List<Category>, List<Category>>
    with $Provider<List<Category>> {
  CategoriesWithoutBudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesWithoutBudgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesWithoutBudgetHash();

  @$internal
  @override
  $ProviderElement<List<Category>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Category> create(Ref ref) {
    return categoriesWithoutBudget(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Category> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Category>>(value),
    );
  }
}

String _$categoriesWithoutBudgetHash() =>
    r'c0fc9253f0b6e229de9429a5deb35eb4be3784a8';
