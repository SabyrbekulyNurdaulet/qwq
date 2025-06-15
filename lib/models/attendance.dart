import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required String id,
    required String subject,
    required String teacher,
    required DateTime date,
    required bool isPresent,
    String? comment,
    String? reason,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}

// Конвертер для Firestore Timestamp <-> DateTime
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

// Расширение для получения цвета статуса
extension AttendanceStatusColor on Attendance {
  Color getColor(BuildContext context) {
    if (isPresent) return Colors.green;
    if (reason != null) return Colors.orange;
    return Colors.red;
  }

  String getDisplayName() {
    if (isPresent) return 'Присутствовал';
    if (reason != null) return 'Отсутствовал (${reason})';
    return 'Отсутствовал';
  }

  IconData getIcon() {
    if (isPresent) return Icons.check_circle_outline;
    return Icons.cancel_outlined;
  }
}
