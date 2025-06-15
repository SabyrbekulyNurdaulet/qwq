// lib/models/group.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'group.freezed.dart';
part 'group.g.dart';

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
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required String specialization,
    required int year,
    String? curatorId,
    String? description,
    @Default([]) List<String> subjectIds, // Изменено с studentIds на subjectIds
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    String?
    curatorName, // Оставляем для совместимости, но может не использоваться
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

// Добавляем расширение для получения полного названия группы
extension GroupExtension on Group {
  String get fullName {
    return '$specialization $year курс, группа $name';
  }

  String get shortName {
    return '$name ($year курс)';
  }
}
