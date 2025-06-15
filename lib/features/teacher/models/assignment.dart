import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  final String id;
  final String teacherId;
  final String groupId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String scheduleEntryId;
  final DateTime createdAt;

  Assignment({
    required this.id,
    required this.teacherId,
    required this.groupId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.scheduleEntryId,
    required this.createdAt,
  });

  factory Assignment.fromMap(Map<String, dynamic> map, String id) {
    return Assignment(
      id: id,
      teacherId: map['teacherId'],
      groupId: map['groupId'],
      title: map['title'],
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      scheduleEntryId: map['scheduleEntryId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'groupId': groupId,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'scheduleEntryId': scheduleEntryId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
