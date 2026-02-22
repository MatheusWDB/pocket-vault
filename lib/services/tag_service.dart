import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/repositories/tag_repository.dart';

class TagService {
  final _repo = TagRepository(DatabaseHelper.instance);

  Future<List<Tag>> getAllTags() async {
    final result = await _repo.findAll();

    return result.map((t) => Tag.fromMap(t)).toList();
  }

  Future<Tag?> getTagByName(String name) async {
    final result = await _repo.findByName(name);

    if (result == null || result.isEmpty) return null;

    return Tag.fromMap(result);
  }

  Future<Tag> ensureTagExists(String name) async {
    final result = await _repo.findByName(name);

    if (result == null || result.isEmpty) {
      final tag = Tag(name: name);
      return tag.copyWith(id: await _repo.insert(tag.toMap()));
    }

    return Tag.fromMap(result);
  }
}
