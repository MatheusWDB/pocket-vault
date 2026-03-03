import 'dart:convert';

import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/tag.dart';

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String? description;
  final Category category;
  final bool isRecurring;
  final List<Tag> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isRecurring,
    this.id,
    this.description,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    String? description,
    Category? category,
    bool? isRecurring,
    List<Tag>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      category: category ?? this.category,
      isRecurring: isRecurring ?? this.isRecurring,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'categoryId': category.id,
      'isRecurring': isRecurring ? 1 : 0,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Transaction.fromMap(
    Map<String, dynamic> map, {
    List<Tag>? tagsFromDb,
  }) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date']),
      description: map['description'] as String?,
      category: Category(id: map['categoryId'], name: map['category_name']),
      isRecurring: map['isRecurring'] == 1,
      tags: tagsFromDb ?? [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, date: $date, description: "${description ?? 'N/A'}", category: ${category.toString()}, isRecurring: $isRecurring, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
