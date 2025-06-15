// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceImpl _$$AttendanceImplFromJson(Map<String, dynamic> json) =>
    _$AttendanceImpl(
      id: json['id'] as String,
      subject: json['subject'] as String,
      teacher: json['teacher'] as String,
      date: DateTime.parse(json['date'] as String),
      isPresent: json['isPresent'] as bool,
      comment: json['comment'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$AttendanceImplToJson(_$AttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'teacher': instance.teacher,
      'date': instance.date.toIso8601String(),
      'isPresent': instance.isPresent,
      'comment': instance.comment,
      'reason': instance.reason,
    };
