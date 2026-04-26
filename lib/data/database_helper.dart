import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' hide Transaction;

class DatabaseHelper {
  static const String tableTransaction = 'table_transactions';
  static const String tableCategory = 'table_categories';
  static const String tableTag = 'table_tags';
  static const String tableTransactionTags = 'table_transaction_tags';

  static const String columnTransactionId = 'id';
  static const String columnTransactionTitle = 'title';
  static const String columnTransactionAmount = 'amount';
  static const String columnTransactionDate = 'date';
  static const String columnTransactionDescription = 'description';
  static const String columnTransactionCategoryId = 'categoryId';
  static const String columnTransactionIsRecurring = 'isRecurring';
  static const String columnTransactionIsTemplate = 'isTemplate';
  static const String columnTransactionTemplateId = 'templateId';
  static const String columnTransactionTotalInstallments = 'totalInstallments';
  static const String columnTransactionCurrentInstallment =
      'currentInstallment';
  static const String columnTransactionLastGeneratedMonth =
      'lastGeneratedMonth';
  static const String columnTransactionCreatedAt = 'createdAt';
  static const String columnTransactionUpdatedAt = 'updatedAt';

  static const String columnCategoryId = 'id';
  static const String columnCategoryName = 'name';
  static const String columnCategoryBudgetLimit = 'budgetLimit';
  static const String columnCategoryColor = 'color';
  static const String columnCategoryCreatedAt = 'createdAt';

  static const String columnTagId = 'id';
  static const String columnTagName = 'name';

  static const String columnRelTransactionId = 'transactionId';
  static const String columnRelTagId = 'tagId';

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  static const String _dbName = 'pocket_vault.db';
  static const int _dbVersion = 1;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> closeAndReset() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_categoryTable);
    await db.execute(_transactionTable);
    await db.execute(_tagTable);
    await db.execute(_transactionTagsTable);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Sempre adicione um bloco por versão:
    // if (oldVersion < 2) {
    //   await db.execute(
    //     'ALTER TABLE $tableTransaction ADD COLUMN notes TEXT',
    //   );
    // }
    // if (oldVersion < 3) { ... }
  }

  String get _categoryTable =>
      '''
        CREATE TABLE $tableCategory (
          $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnCategoryName TEXT NOT NULL,
          $columnCategoryBudgetLimit REAL,
          $columnCategoryColor TEXT,
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
          $columnTransactionTotalInstallments INTEGER,
          $columnTransactionCurrentInstallment INTEGER,
          $columnTransactionIsRecurring INTEGER NOT NULL,
          $columnTransactionIsTemplate INTEGER NOT NULL,
          $columnTransactionTemplateId INTEGER,
          $columnTransactionLastGeneratedMonth TEXT,
          $columnTransactionCreatedAt TEXT NOT NULL,
          $columnTransactionUpdatedAt TEXT,
          FOREIGN KEY ($columnTransactionCategoryId) REFERENCES $tableCategory($columnCategoryId) ON UPDATE CASCADE
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
