// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionService)
final transactionServiceProvider = TransactionServiceProvider._();

final class TransactionServiceProvider
    extends
        $FunctionalProvider<
          TransactionService,
          TransactionService,
          TransactionService
        >
    with $Provider<TransactionService> {
  TransactionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionServiceHash();

  @$internal
  @override
  $ProviderElement<TransactionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionService create(Ref ref) {
    return transactionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionService>(value),
    );
  }
}

String _$transactionServiceHash() =>
    r'7a9788e70aaf181aebc912728165dcad3b345e6c';

@ProviderFor(TransactionList)
final transactionListProvider = TransactionListProvider._();

final class TransactionListProvider
    extends $AsyncNotifierProvider<TransactionList, List<Transaction>> {
  TransactionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionListHash();

  @$internal
  @override
  TransactionList create() => TransactionList();
}

String _$transactionListHash() => r'cf96b1490504d9109712f2fd0667d8ddbcad1ef4';

abstract class _$TransactionList extends $AsyncNotifier<List<Transaction>> {
  FutureOr<List<Transaction>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Transaction>>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Transaction>>, List<Transaction>>,
              AsyncValue<List<Transaction>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(transactionSummary)
final transactionSummaryProvider = TransactionSummaryProvider._();

final class TransactionSummaryProvider
    extends
        $FunctionalProvider<
          TransactionSummary,
          TransactionSummary,
          TransactionSummary
        >
    with $Provider<TransactionSummary> {
  TransactionSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionSummaryHash();

  @$internal
  @override
  $ProviderElement<TransactionSummary> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionSummary create(Ref ref) {
    return transactionSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionSummary>(value),
    );
  }
}

String _$transactionSummaryHash() =>
    r'be3f91129b769d9912ed878539d1fc7c1d1a901a';

@ProviderFor(transactionTitles)
final transactionTitlesProvider = TransactionTitlesProvider._();

final class TransactionTitlesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  TransactionTitlesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionTitlesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionTitlesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return transactionTitles(ref);
  }
}

String _$transactionTitlesHash() => r'b3eeb5642bb9d2259672033257ebd346b3a8fc66';

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transaction?>,
          Transaction?,
          FutureOr<Transaction?>
        >
    with $FutureModifier<Transaction?>, $FutureProvider<Transaction?> {
  TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Transaction?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Transaction?> create(Ref ref) {
    final argument = this.argument as int?;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'c2b0bd046a120d911bfe5c58d9ce0c03c378956e';

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Transaction?>, int?> {
  TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionByIdProvider call(int? id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}

@ProviderFor(minYear)
final minYearProvider = MinYearProvider._();

final class MinYearProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  MinYearProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'minYearProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$minYearHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return minYear(ref);
  }
}

String _$minYearHash() => r'1d0974c70a3a10b5d59a47288a98f35ffacc59b6';
