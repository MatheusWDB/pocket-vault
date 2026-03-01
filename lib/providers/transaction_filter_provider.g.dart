// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionFilter)
final transactionFilterProvider = TransactionFilterProvider._();

final class TransactionFilterProvider
    extends $NotifierProvider<TransactionFilter, TransactionFilters> {
  TransactionFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFilterHash();

  @$internal
  @override
  TransactionFilter create() => TransactionFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFilters>(value),
    );
  }
}

String _$transactionFilterHash() => r'af815cc32a7f2aab0c6eea4734b57f348c5fdb0e';

abstract class _$TransactionFilter extends $Notifier<TransactionFilters> {
  TransactionFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TransactionFilters, TransactionFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFilters, TransactionFilters>,
              TransactionFilters,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
