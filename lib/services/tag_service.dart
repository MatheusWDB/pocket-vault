import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/mock/mock_tag.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/repositories/tag_repository.dart';
import 'package:pocket_vault/repositories/transaction_tags_repository.dart';
import 'package:sqflite/sqflite.dart';

class TagService {
  final _dbHelper = DatabaseHelper.instance;
  final _repo = TagRepository(DatabaseHelper.instance);
  final _repoTransactionTags = TransactionTagsRepository(
    DatabaseHelper.instance,
  );

  Future<List<Tag>> getAllTags() async {
    final result = await _repo.findAll();

    // ---------------Remover Mock---------------
    if (result.isEmpty) {
      return mockTags;
    }
    // ------------------------------------------

    return result.map((t) => Tag.fromMap(t)).toList();
  }

  Future<Tag?> getTagByName(String name) async {
    final result = await _repo.findByName(name);

    if (result == null || result.isEmpty) return null;

    return Tag.fromMap(result);
  }

  Future<Tag> ensureTagExists(String name, {DatabaseExecutor? executor}) async {
    final db = executor ?? await _dbHelper.database;
    final result = await _repo.findByName(name, executor: db);

    if (result == null || result.isEmpty) {
      final tag = Tag(name: name);
      return tag.copyWith(id: await _repo.insert(tag.toMap(), executor: db));
    }

    return Tag.fromMap(result);
  }

  Future<void> linkTagsToTransaction(
    int transactionId,
    List<Tag> tags, {
    DatabaseExecutor? executor,
  }) async {
    final db = executor ?? await _dbHelper.database;

    for (Tag tag in tags) {
      final existingTag = await _repo.findByName(tag.name, executor: db);

      final int tagId = (existingTag == null)
          ? await _repo.insert(tag.toMap(), executor: db)
          : existingTag['id'];

      await _repoTransactionTags.insert(transactionId, tagId, executor: db);
    }
  }
}
