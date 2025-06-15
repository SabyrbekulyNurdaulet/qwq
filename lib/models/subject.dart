import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String id;
  final String name;
  final String? description;
  final String shortName;
  final String? department;
  final bool isActive;
  final int credits;
  final int hours;
  final int hoursPerSemester;
  final int hoursPerWeek;
  final String teacherId;
  final String type;
  final List<String> groups;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subject({
    required this.id,
    required this.name,
    this.description,
    this.shortName = '',
    this.department,
    this.isActive = false,
    this.credits = 0,
    this.hours = 0,
    this.hoursPerSemester = 0,
    this.hoursPerWeek = 0,
    this.teacherId = '',
    this.type = '',
    this.groups = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      shortName: json['shortName'] ?? '',
      department: json['department'],
      isActive: json['isActive'] ?? false,
      credits: _safeInt(json['credits']),
      hours: _safeInt(json['hours']),
      hoursPerSemester: _safeInt(json['hoursPerSemester']),
      hoursPerWeek: _safeInt(json['hoursPerWeek']),
      teacherId: json['teacherId'] ?? '',
      type: json['type'] ?? '',
      groups:
          (json['groups'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'shortName': shortName,
      'department': department,
      'isActive': isActive,
      'credits': credits,
      'hours': hours,
      'hoursPerSemester': hoursPerSemester,
      'hoursPerWeek': hoursPerWeek,
      'teacherId': teacherId,
      'type': type,
      'groups': groups,
      'createdAt': _timestampToJson(createdAt),
      'updatedAt': _timestampToJson(updatedAt),
    };
  }

  Subject copyWith({
    String? id,
    String? name,
    String? description,
    String? shortName,
    String? department,
    bool? isActive,
    int? credits,
    int? hours,
    int? hoursPerSemester,
    int? hoursPerWeek,
    String? teacherId,
    String? type,
    List<String>? groups,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortName: shortName ?? this.shortName,
      department: department ?? this.department,
      isActive: isActive ?? this.isActive,
      credits: credits ?? this.credits,
      hours: hours ?? this.hours,
      hoursPerSemester: hoursPerSemester ?? this.hoursPerSemester,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      teacherId: teacherId ?? this.teacherId,
      type: type ?? this.type,
      groups: groups ?? this.groups,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, teacherId: $teacherId)';
  }
}

// Безопасное преобразование в int
int _safeInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// Конвертеры для DateTime
DateTime _timestampFromJson(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}

dynamic _timestampToJson(DateTime date) => date.toIso8601String();
