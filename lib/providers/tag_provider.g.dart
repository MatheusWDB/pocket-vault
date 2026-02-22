// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tagService)
final tagServiceProvider = TagServiceProvider._();

final class TagServiceProvider
    extends $FunctionalProvider<TagService, TagService, TagService>
    with $Provider<TagService> {
  TagServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagServiceHash();

  @$internal
  @override
  $ProviderElement<TagService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TagService create(Ref ref) {
    return tagService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagService>(value),
    );
  }
}

String _$tagServiceHash() => r'07a6f29f6d45e310c647f1cdf8e138e8f14ed497';

@ProviderFor(TagList)
final tagListProvider = TagListProvider._();

final class TagListProvider extends $AsyncNotifierProvider<TagList, List<Tag>> {
  TagListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagListHash();

  @$internal
  @override
  TagList create() => TagList();
}

String _$tagListHash() => r'b767a4ad2c6f55c7c17253f3be30a8302baeaaa9';

abstract class _$TagList extends $AsyncNotifier<List<Tag>> {
  FutureOr<List<Tag>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Tag>>, List<Tag>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Tag>>, List<Tag>>,
              AsyncValue<List<Tag>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
