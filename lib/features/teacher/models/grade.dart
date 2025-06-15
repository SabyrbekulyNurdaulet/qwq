import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {
  final String id;
  final String studentId;
  final String teacherId;
  final String teacherName;
  final String groupId;
  final String subject;
  final int score;
  final DateTime timestamp;

  Grade({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.teacherName,
    required this.groupId,
    required this.subject,
    required this.score,
    required this.timestamp,
  });

  factory Grade.fromMap(Map<String, dynamic> map, String id) {
    return Grade(
      id: id,
      studentId: map['studentId'],
      teacherId: map['teacherId'],
      teacherName: map['teacherName'] ?? 'Без имени',
      groupId: map['groupId'],
      subject: map['subject'],
      score: map['score'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'groupId': groupId,
      'subject': subject,
      'score': score,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
