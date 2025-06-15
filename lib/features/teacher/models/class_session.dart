import 'package:cloud_firestore/cloud_firestore.dart';

class ClassSession {
  final String id;
  final String teacherId;
  final String groupId;
  final DateTime date;
  final String subject;

  ClassSession({
    required this.id,
    required this.teacherId,
    required this.groupId,
    required this.date,
    required this.subject,
  });

  factory ClassSession.fromMap(Map<String, dynamic> map, String id) {
    return ClassSession(
      id: id,
      teacherId: map['teacherId'],
      groupId: map['groupId'],
      date: (map['date'] as Timestamp).toDate(),
      subject: map['subject'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'groupId': groupId,
      'date': Timestamp.fromDate(date),
      'subject': subject,
    };
  }
}
