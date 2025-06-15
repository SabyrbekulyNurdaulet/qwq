// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JournalEntryImpl _$$JournalEntryImplFromJson(Map<String, dynamic> json) =>
    _$JournalEntryImpl(
      id: json['id'] as String,
      journalId: json['journalId'] as String,
      studentId: json['studentId'] as String,
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      attendanceStatus: json['attendanceStatus'] as String,
      present: json['present'] as bool,
      grade: json['grade'] as String?,
      gradeType: json['gradeType'] as String,
      comment: json['comment'] as String?,
      topicCovered: json['topicCovered'] as String?,
      lessonId: json['lessonId'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$JournalEntryImplToJson(_$JournalEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'journalId': instance.journalId,
      'studentId': instance.studentId,
      'date': const TimestampConverter().toJson(instance.date),
      'attendanceStatus': instance.attendanceStatus,
      'present': instance.present,
      'grade': instance.grade,
      'gradeType': instance.gradeType,
      'comment': instance.comment,
      'topicCovered': instance.topicCovered,
      'lessonId': instance.lessonId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
