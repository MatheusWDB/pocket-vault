import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

class DatabaseHelper {
  static const String tableTransaction = 'transaction';
  static const String tableCategory = 'category';
  static const String tableTag = 'tag';
  static const String tableTransactionTags = 'transaction_tags';

  static const String columnTransactionId = 'id';
  static const String columnTransactionTitle = 'title';
  static const String columnTransactionAmount = 'amount';
  static const String columnTransactionDate = 'date';
  static const String columnTransactionDescription = 'description';
  static const String columnTransactionCategoryId = 'categoryId';
  static const String columnTransactionIsRecurring = 'isRecurring';
  static const String columnTransactionCreatedAt = 'createdAt';
  static const String columnTransactionUpdatedAt = 'updatedAt';

  static const String columnCategoryId = 'id';
  static const String columnCategoryName = 'name';
  static const String columnCategoryBudgetLimit = 'budgetLimit';
  static const String columnCategoryCreatedAt = 'createdAt';

  static const String columnTagId = 'id';
  static const String columnTagName = 'name';

  static const String columnRelTransactionId = 'transactionId';
  static const String columnRelTagId = 'tagId';

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'pocket_vault.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(_categoryTable);
    await db.execute(_transactionTable);
    await db.execute(_tagTable);
    await db.execute(_transactionTagsTable);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  String get _categoryTable =>
      '''
        CREATE TABLE $tableCategory (
          $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnCategoryName TEXT NOT NULL,
          $columnCategoryBudgetLimit REAL,
          $columnCategoryCreatedAt TEXT NOT NULL
        );
      ''';

  String get _transactionTable =>
      '''
        CREATE TABLE $tableTransaction (
          $columnTransactionId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTransactionTitle TEXT NOT NULL,
          $columnTransactionAmount REAL NOT NULL,
          $columnTransactionDate TEXT NOT NULL,
          $columnTransactionDescription TEXT,
          $columnTransactionCategoryId INTEGER NOT NULL,
          $columnTransactionIsRecurring INTEGER NOT NULL,          
          $columnTransactionCreatedAt TEXT NOT NULL,
          $columnTransactionUpdatedAt TEXT,
          FOREIGN KEY ($columnTransactionCategoryId) REFERENCES $tableCategory($columnCategoryId) ON DELETE CASCADE ON UPDATE CASCADE
        );
      ''';

  String get _tagTable =>
      '''
        CREATE TABLE $tableTag (
          $columnTagId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnTagName TEXT NOT NULL UNIQUE
        );
      ''';

  String get _transactionTagsTable =>
      '''
        CREATE TABLE $tableTransactionTags (
          $columnRelTransactionId INTEGER NOT NULL,
          $columnRelTagId INTEGER NOT NULL,
          FOREIGN KEY ($columnRelTransactionId) REFERENCES $tableTransaction($columnTransactionId) ON DELETE CASCADE ON UPDATE CASCADE,
          FOREIGN KEY ($columnRelTagId) REFERENCES $tableTag($columnTagId) ON DELETE CASCADE ON UPDATE CASCADE,
          PRIMARY KEY ($columnRelTransactionId, $columnRelTagId)
        );
      ''';
}
