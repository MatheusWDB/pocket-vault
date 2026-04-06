import 'dart:convert';

import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';
import 'package:pocket_vault/models/transaction.dart';

class BackupData {
  final List<Category> categories;
  final List<Transaction> transactions;
  final List<Tag> tags;

  BackupData({
    required this.categories,
    required this.transactions,
    required this.tags,
  });

  BackupData copyWith({
    List<Category>? categories,
    List<Transaction>? transactions,
    List<Tag>? tags,
  }) {
    return BackupData(
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories': categories.map((x) => x.toMap()).toList(),
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'tags': tags.map((x) => x.toMap()).toList(),
    };
  }

  factory BackupData.fromMap(Map<String, dynamic> map) {
    return BackupData(
      categories: List<Category>.from(
        (map['categories'] as List).map<Category>(
          (x) => Category.fromMap(x as Map<String, dynamic>),
        ),
      ),
      transactions: List<Transaction>.from(
        (map['transactions'] as List).map<Transaction>((x) {
          final transactionMap = Map<String, dynamic>.from(x as Map);
          
          transactionMap.putIfAbsent('tags', () => <Object?>[]);
          transactionMap.putIfAbsent(
            'category',
            () => <String, dynamic>{
              'id': transactionMap['categoryId'],
              'name': '',
            },
          );
          return Transaction.fromMap(transactionMap);
        }),
      ),
      tags: List<Tag>.from(
        (map['tags'] as List).map<Tag>(
          (x) => Tag.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BackupData.fromJson(String source) =>
      BackupData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BackupData(categories: $categories, transactions: $transactions, tags: $tags)';
  }
}
