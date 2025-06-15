import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'assignment.freezed.dart';
part 'assignment.g.dart';

@freezed
class Assignment with _$Assignment {
  const factory Assignment({
    required String id,
    required String teacherId,
    required String groupId,
    required String title,
    required String description,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime dueDate,
    String? scheduleEntryId,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime updatedAt,
  }) = _Assignment;

  factory Assignment.fromJson(Map<String, dynamic> json) =>
      _$AssignmentFromJson(json);
}

// Конвертеры для DateTime
DateTime _timestampFromJson(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  return DateTime.parse(value as String);
}

dynamic _timestampToJson(DateTime date) => date.toIso8601String();
