import 'dart:convert';

class Category {
  final int id;
  final String name;
  final double? budgetLimit;

  Category({required this.id, required this.name, this.budgetLimit});

  Category copyWith({int? id, String? name, double? budgetLimit}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetLimit: budgetLimit ?? this.budgetLimit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'budgetLimit': budgetLimit,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      budgetLimit: map['budgetLimit'] != null
          ? map['budgetLimit'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Category(id: $id, name: $name, budgetLimit: $budgetLimit)';
}
