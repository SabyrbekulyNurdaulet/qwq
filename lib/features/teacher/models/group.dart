class Group {
  final String id;
  final String name;

  Group({
    required this.id,
    required this.name,
  });

  // Для работы с DropdownButton — сравнение по id
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Для загрузки из Firestore
  factory Group.fromMap(Map<String, dynamic> map, String docId) {
    return Group(
      id: docId,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
