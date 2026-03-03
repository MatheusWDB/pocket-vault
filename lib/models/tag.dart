import 'dart:convert';

class Tag {
  final int? id;
  final String name;

  Tag({required this.name, this.id});

  Tag copyWith({int? id, String? name}) {
    return Tag(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {'name': name};

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(id: map['id'] as int?, name: map['name'] as String);
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) =>
      Tag.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tag(id: $id, name: $name)';

  @override
  bool operator ==(covariant Tag other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
