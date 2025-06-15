// lib/models/schedule_entry.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'schedule_entry.freezed.dart';
part 'schedule_entry.g.dart';

// Этот конвертер нужен для правильной работы с датой из Firestore.
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
class ScheduleEntry with _$ScheduleEntry {
  const factory ScheduleEntry({
    // Обязательные поля, которые ДОЛЖНЫ быть в базе
    required String id,
    required String groupId,
    required String semesterId,
    required String subjectId,
    required String teacherId,
    required String startTime,
    required String endTime,

    // Необязательные поля со значениями ПО УМОЛЧАНИЮ
    // Если этих полей не будет в базе, подставятся эти значения
    @Default(1) int dayOfWeek,
    @Default('lecture') String type,
    @Default('all') String weekType,
    @Default('') String room,
    @Default(90) int duration,
    @Default(false) bool isFloating,

    // Поля с датой, которые могут быть null
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _ScheduleEntry;

  /// ВАЖНО!
  /// Эта фабрика ДОЛЖНА быть такой.
  /// НЕ добавляйте сюда никакую логику.
  /// Генератор кода сделает всю работу за вас, основываясь на аннотациях @Default выше.
  factory ScheduleEntry.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEntryFromJson(json);
}

// --- Вспомогательные методы ---
extension ScheduleEntryX on ScheduleEntry {
  // Парсинг времени начала (может вернуть null при ошибке формата)
  TimeOfDay? get startTimeOfDay {
    try {
      final parts = startTime.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  // Парсинг времени конца
  TimeOfDay? get endTimeOfDay {
    try {
      final parts = endTime.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  // Проверка, идет ли эта пара прямо сейчас
  bool isCurrentLesson() {
    final now = DateTime.now();
    final currentDay = now.weekday;
    if (currentDay != dayOfWeek) return false;

    final start = startTimeOfDay;
    final end = endTimeOfDay;
    if (start == null || end == null) return false;

    final nowTime = TimeOfDay.fromDateTime(now);

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final nowMinutes = nowTime.hour * 60 + nowTime.minute;

    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  // Получение названия дня недели
  String get dayName {
    const days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    if (dayOfWeek >= 1 && dayOfWeek <= 7) {
      return days[dayOfWeek - 1];
    }
    return '??';
  }
}
