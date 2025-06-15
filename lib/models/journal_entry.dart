// lib/models/journal_entry.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'journal_entry.freezed.dart';
part 'journal_entry.g.dart';

// Конвертер для Firestore Timestamp <-> DateTime
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class JournalEntry with _$JournalEntry {
  const factory JournalEntry({
    required String id,
    required String journalId,
    required String studentId,
    @TimestampConverter() required DateTime date,
    required String attendanceStatus, // 'present', 'absent', 'late'
    required bool present,
    String?
    grade, // Строка для гибкости (может быть числом или "зачет"/"незачет")
    required String gradeType, // 'current', 'midterm', 'final'
    String? comment,
    String? topicCovered,
    String? lessonId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _JournalEntry;

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);
}

// Расширения для удобной работы с оценками
extension JournalEntryExtensions on JournalEntry {
  // Проверка, является ли оценка числовой
  bool get hasNumericGrade {
    if (grade == null) return false;
    return double.tryParse(grade!) != null;
  }

  // Получение числового значения оценки
  double? get numericGradeValue {
    if (grade == null) return null;
    return double.tryParse(grade!);
  }

  // Проверка, является ли это зачетом
  bool get isPass {
    if (grade == null) return false;
    final lowerGrade = grade!.toLowerCase();
    return lowerGrade == 'зачет' ||
        lowerGrade == 'pass' ||
        lowerGrade == 'зачтено';
  }

  // Получение отображаемого текста оценки
  String get displayGrade {
    if (grade == null || grade!.isEmpty) return 'Не оценено';

    if (hasNumericGrade) {
      return '$grade/100';
    }

    return grade!;
  }

  // Получение цвета для отображения оценки
  Color getGradeColor() {
    if (grade == null || grade!.isEmpty) return Colors.grey;

    if (hasNumericGrade) {
      final numValue = numericGradeValue!;
      if (numValue >= 90) return Colors.green;
      if (numValue >= 75) return Colors.lightGreen;
      if (numValue >= 60) return Colors.orange;
      return Colors.red;
    }

    // Для зачет/незачет
    return isPass ? Colors.green : Colors.red;
  }

  // Получение иконки для типа оценки
  IconData getGradeTypeIcon() {
    switch (gradeType) {
      case 'current':
        return Icons.assignment;
      case 'midterm':
        return Icons.assessment;
      case 'final':
        return Icons.school;
      default:
        return Icons.grade;
    }
  }

  // Получение отображаемого названия типа оценки
  String getGradeTypeName() {
    switch (gradeType) {
      case 'current':
        return 'Текущая';
      case 'midterm':
        return 'Рубежная';
      case 'final':
        return 'Итоговая';
      default:
        return gradeType;
    }
  }

  // Получение иконки для статуса посещаемости
  IconData getAttendanceIcon() {
    switch (attendanceStatus) {
      case 'present':
        return Icons.check_circle_outline;
      case 'absent':
        return Icons.cancel_outlined;
      case 'late':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }

  // Получение цвета для статуса посещаемости
  Color getAttendanceColor() {
    switch (attendanceStatus) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Получение отображаемого текста статуса посещаемости
  String getAttendanceDisplayName() {
    switch (attendanceStatus) {
      case 'present':
        return 'Присутствовал';
      case 'absent':
        return 'Отсутствовал';
      case 'late':
        return 'Опоздал';
      default:
        return attendanceStatus;
    }
  }
}
