import 'package:pocket_vault/data/database_helper.dart';
import 'package:pocket_vault/exceptions/database_exception.dart';
import 'package:pocket_vault/exceptions/tag_exception.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/repositories/tag_repository.dart';
import 'package:pocket_vault/repositories/transaction_tags_repository.dart';
import 'package:sqflite/sqflite.dart' hide DatabaseException;

class TagService {
  final DatabaseHelper _dbHelper;
  final TagRepository _repo;
  final TransactionTagsRepository _transactionTagsRepo;

  TagService({
    DatabaseHelper? dbHelper,
    TagRepository? repo,
    TransactionTagsRepository? repoTransactionTags,
  }) : _dbHelper = dbHelper ?? DatabaseHelper.instance,
       _repo = repo ?? TagRepository(dbHelper ?? DatabaseHelper.instance),
       _transactionTagsRepo =
           repoTransactionTags ??
           TransactionTagsRepository(dbHelper ?? DatabaseHelper.instance);

  Future<List<Tag>> getAllTags() async {
    final result = await _repo.findAll();
    return result.map((t) => Tag.fromMap(t)).toList();
  }

  Future<Tag> getTagByName(String name) async {
    final result = await _repo.findByName(name);
    if (result == null) throw const TagNotFoundException();
    return Tag.fromMap(result);
  }

  Future<Tag> ensureTagExists(String name, {DatabaseExecutor? executor}) async {
    try {
      final db = executor ?? await _dbHelper.database;
      final result = await _repo.findByName(name, executor: db);

      if (result == null) {
        final tag = Tag(name: name);
        final id = await _repo.insert(tag.toMap(), executor: db);
        return tag.copyWith(id: id);
      }

      return Tag.fromMap(result);
    } on DatabaseException catch (_) {
      throw TagSaveException();
    }
  }

  Future<void> linkTagsToTransaction(
    int transactionId,
    List<Tag> tags, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;

      for (final tag in tags) {
        final existing = await _repo.findByName(tag.name, executor: db);
        final tagId = existing != null
            ? existing['id'] as int
            : await _repo.insert(tag.toMap(), executor: db);

        await _transactionTagsRepo.insert(transactionId, tagId, executor: db);
      }
    } on DatabaseException catch (_) {
      throw TagSaveException();
    }
  }

  Future<void> syncTagsForTransaction(
    int transactionId,
    List<Tag> tags, {
    DatabaseExecutor? executor,
  }) async {
    try {
      final db = executor ?? await _dbHelper.database;
      await _transactionTagsRepo.deleteAllByTransaction(
        transactionId,
        executor: db,
      );
      for (final tag in tags) {
        final existing = await _repo.findByName(tag.name, executor: db);
        final tagId = existing != null
            ? existing['id'] as int
            : await _repo.insert(tag.toMap(), executor: db);
        await _transactionTagsRepo.insert(transactionId, tagId, executor: db);
      }
    } on DatabaseException catch (_) {
      throw TagSaveException();
    }
  }
}
