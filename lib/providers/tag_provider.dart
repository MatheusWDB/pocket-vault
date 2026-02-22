import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/services/tag_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tag_provider.g.dart';

@riverpod
TagService tagService(Ref ref) {
  return TagService();
}

@riverpod
class TagList extends _$TagList {
  @override
  Future<List<Tag>> build() async {
    final service = ref.watch(tagServiceProvider);

    return await service.getAllTags();
  }

  Future<void> addTag(String name) async {
    final service = ref.read(tagServiceProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.ensureTagExists(name);
      return await future;
    });
  }
}
