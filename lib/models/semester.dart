import 'package:cloud_firestore/cloud_firestore.dart';

class Semester {
  final String id;
  final String name;
  final String academicYear;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Semester({
    required this.id,
    required this.name,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'] as String,
      name: json['name'] as String,
      academicYear: json['academicYear'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      status: json['status'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'academicYear': academicYear,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isActive => status == 'active';
  bool get isPlanning => status == 'planning';
  bool get isArchived => status == 'archive';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Semester && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
