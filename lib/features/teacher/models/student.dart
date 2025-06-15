class Student {
  final String id;
  final String name;
  final String email;
  final String groupId;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.groupId,
  });

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    return Student(
      id: id,
      name: map['name'],
      email: map['email'],
      groupId: map['groupId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'groupId': groupId,
    };
  }
}
