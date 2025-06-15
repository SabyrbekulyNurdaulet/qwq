import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

@freezed
class Lesson with _$Lesson {
  const factory Lesson({
    required String id,
    required int dayOfWeek,
    required int duration,
    required String endTime,
    required String groupId,
    required bool isFloating,
    required String room,
    required String semesterId,
    required String startTime,
    required String subjectId,
    required String teacherId,
    required String type,
    required String weekType,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _nullableDateTimeToTimestamp,
    )
    DateTime? updatedAt,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
}

// Конвертеры для обязательных полей DateTime
DateTime _dateTimeFromTimestamp(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) =>
    Timestamp.fromDate(dateTime);

// Конвертеры для необязательных полей DateTime?
DateTime? _nullableDateTimeFromTimestamp(Timestamp? timestamp) =>
    timestamp?.toDate();
Timestamp? _nullableDateTimeToTimestamp(DateTime? dateTime) =>
    dateTime == null ? null : Timestamp.fromDate(dateTime);
