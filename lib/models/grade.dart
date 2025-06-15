// lib/models/grade.dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'grade.freezed.dart';
part 'grade.g.dart';

@freezed
class Grade with _$Grade {
  const factory Grade({
    required String id,
    required String subject,
    required String teacher,
    required DateTime date,
    required double value,
    required int semester,
    required bool isNumeric,
    @Default(false) bool isPassFail,
    String? comment,
  }) = _Grade;

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
}

// Конвертер для Firestore Timestamp <-> DateTime
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

extension GradeDisplay on Grade {
  String get displayValue {
    if (isPassFail) {
      return value >= 60 ? 'Зачет' : 'Незачет';
    }
    if (!isNumeric) {
      return value == 1 ? 'Зачет' : 'Незачет';
    }
    return value.toStringAsFixed(0);
  }
}

// Вспомогательный extension для получения числового значения оценки (если возможно)
extension GradeValue on Grade {
  double? get numericGrade {
    // Пытаемся преобразовать строку в число
    // Поддерживаем оценки по 5-балльной или 100-балльной системе
    // Можно добавить логику для буквенных оценок (A=5, B=4 и т.д.)
    final numValue = double.tryParse(
      value.toString(),
    ); // Заменяем запятую на точку, если нужно

    // Проверяем стандартные текстовые оценки
    if (numValue == null) {
      if (value >= 60) {
        return 1.0; // Условно 1 для зачета (для расчета типа "сдал/не сдал")
      }
      return 0.0; // Условно 0 для незачета
    }
    return numValue;
  }

  // Цвет для оценки (пример)
  Color getColor(BuildContext context) {
    final numeric = numericGrade;
    if (numeric == null) {
      return Colors.grey.shade600; // Для нечисловых/неизвестных
    }

    // Примерная логика для 5-балльной системы (можно адаптировать)
    // Либо использовать процентную систему, если оценки до 100
    final colorScheme = Theme.of(context).colorScheme;
    if (numeric >= 4.5) return Colors.green.shade600; // Отлично
    if (numeric >= 3.5) return Colors.orange.shade700; // Хорошо
    if (numeric >= 2.5) return colorScheme.primary; // Удовл.
    return colorScheme.error; // Неудовл. / Незачет
  }
}
