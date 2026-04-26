import 'dart:convert';

import 'package:pocket_vault/models/category.dart';
import 'package:pocket_vault/models/nullable.dart';
import 'package:pocket_vault/models/tag.dart';

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String? description;
  final Category category;
  final List<Tag> tags;
  final int? totalInstallments;
  final int? currentInstallment;
  final bool isRecurring;
  final bool isTemplate;
  final int? templateId;
  final String? lastGeneratedMonth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.isRecurring,
    required this.isTemplate,
    this.id,
    this.description,
    this.tags = const [],
    this.totalInstallments,
    this.currentInstallment,
    this.templateId,
    this.lastGeneratedMonth,
    this.createdAt,
    this.updatedAt,
  });

  Transaction copyWith({
    Nullable<int>? id,
    String? title,
    double? amount,
    DateTime? date,
    String? description,
    Category? category,
    bool? isRecurring,
    bool? isTemplate,
    int? templateId,
    int? totalInstallments,
    int? currentInstallment,
    List<Tag>? tags,
    Nullable<String>? lastGeneratedMonth,
    DateTime? createdAt,
    Nullable<DateTime>? updatedAt,
  }) {
    return Transaction(
      id: id != null ? id.value : this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      category: category ?? this.category,
      isRecurring: isRecurring ?? this.isRecurring,
      isTemplate: isTemplate ?? this.isTemplate,
      templateId: templateId ?? this.templateId,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      currentInstallment: currentInstallment ?? this.currentInstallment,
      tags: tags ?? this.tags,
      lastGeneratedMonth: lastGeneratedMonth != null
          ? lastGeneratedMonth.value
          : this.lastGeneratedMonth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null ? updatedAt.value : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'categoryId': category.id,
      'totalInstallments': totalInstallments,
      'currentInstallment': currentInstallment,
      'isRecurring': isRecurring ? 1 : 0,
      'isTemplate': isTemplate ? 1 : 0,
      'templateId': templateId,
      'lastGeneratedMonth': lastGeneratedMonth,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
      category: Category.fromMap(map['category'] as Map<String, dynamic>),
      tags: List<Tag>.from(
        (map['tags'] as List).map<Tag>(
          (x) => Tag.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalInstallments: map['totalInstallments'] as int?,
      currentInstallment: map['currentInstallment'] as int?,
      isRecurring: map['isRecurring'] == 1,
      isTemplate: map['isTemplate'] == 1,
      templateId: map['templateId'] as int?,
      lastGeneratedMonth: map['lastGeneratedMonth'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, date: $date, description: $description, category: $category, tags: $tags, totalInstallments: $totalInstallments, currentInstallment: $currentInstallment, isRecurring: $isRecurring, isTemplate: $isTemplate, lastGeneratedMonth: $lastGeneratedMonth, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
