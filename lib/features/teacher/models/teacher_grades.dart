// lib/features/teacher/models/teacher_grade.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherGrade {
  final String id;
  final String studentId;
  final String teacherId;
  final String teacherName;
  final String groupId;
  final String subject;
  final String? subjectId;
  final int score;
  final String gradeSystem; // '100' или 'pass_fail'
  final String gradeType; // 'numeric' или 'pass_fail'
  final bool? passed; // для зачет/незачет
  final String? comment;
  final DateTime timestamp;
  final DateTime createdAt;

  TeacherGrade({
    required this.id,
    required this.studentId,
    required this.teacherId,
    required this.teacherName,
    required this.groupId,
    required this.subject,
    this.subjectId,
    required this.score,
    required this.gradeSystem,
    this.gradeType = 'numeric',
    this.passed,
    this.comment,
    required this.timestamp,
    required this.createdAt,
  });

  factory TeacherGrade.fromMap(Map<String, dynamic> map, String id) {
    return TeacherGrade(
      id: id,
      studentId: map['studentId'] ?? '',
      teacherId: map['teacherId'] ?? '',
      teacherName: map['teacherName'] ?? 'Без имени',
      groupId: map['groupId'] ?? '',
      subject: map['subject'] ?? '',
      subjectId: map['subjectId'],
      score: (map['score'] as num?)?.toInt() ?? 0,
      gradeSystem: map['gradeSystem'] ?? '100',
      gradeType: map['gradeType'] ?? 'numeric',
      passed: map['passed'],
      comment: map['comment'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'groupId': groupId,
      'subject': subject,
      'subjectId': subjectId,
      'score': score,
      'gradeSystem': gradeSystem,
      'gradeType': gradeType,
      'passed': passed,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Получить отображаемое значение оценки
  String get displayValue {
    if (gradeType == 'pass_fail' || gradeSystem == 'pass_fail') {
      return passed == true ? 'Зачет' : 'Незачет';
    }
    return '$score/100';
  }

  // Получить цвет для оценки
  Color getColor() {
    if (gradeType == 'pass_fail' || gradeSystem == 'pass_fail') {
      return passed == true
          ? const Color(0xFF4CAF50) // Зеленый для зачета
          : const Color(0xFFF44336); // Красный для незачета
    }

    // Для 100-балльной системы
    if (score >= 90) return const Color(0xFF4CAF50); // Зеленый
    if (score >= 75) return const Color(0xFF8BC34A); // Светло-зеленый
    if (score >= 60) return const Color(0xFFFF9800); // Оранжевый
    if (score >= 40) return const Color(0xFFFF5722); // Красно-оранжевый
    return const Color(0xFFF44336); // Красный
  }

  // Получить описание качества оценки
  String get qualityDescription {
    if (gradeType == 'pass_fail' || gradeSystem == 'pass_fail') {
      return passed == true ? 'Зачтено' : 'Не зачтено';
    }

    // Для 100-балльной системы
    if (score >= 90) return 'Отлично';
    if (score >= 75) return 'Хорошо';
    if (score >= 60) return 'Удовлетворительно';
    if (score >= 40) return 'Слабо';
    return 'Неудовлетворительно';
  }

  @override
  String toString() {
    return 'TeacherGrade(id: $id, student: $studentId, subject: $subject, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherGrade && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
