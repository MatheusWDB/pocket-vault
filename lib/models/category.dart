import 'dart:convert';

class Category {
  final int? id;
  final String name;
  final double? budgetLimit;
  final DateTime? createdAt;

  Category({
    required this.name,
    this.id,
    this.budgetLimit = 0.0,
    this.createdAt,
  });

  Category copyWith({
    int? id,
    String? name,
    double? budgetLimit,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'budgetLimit': budgetLimit,
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      budgetLimit: map['budgetLimit'] != null
          ? map['budgetLimit'] as double
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Category(id: $id, name: $name, budgetLimit: $budgetLimit, createdAt: $createdAt)';
}
