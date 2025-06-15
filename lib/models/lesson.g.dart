// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonImpl _$$LessonImplFromJson(Map<String, dynamic> json) => _$LessonImpl(
  id: json['id'] as String,
  dayOfWeek: (json['dayOfWeek'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  endTime: json['endTime'] as String,
  groupId: json['groupId'] as String,
  isFloating: json['isFloating'] as bool,
  room: json['room'] as String,
  semesterId: json['semesterId'] as String,
  startTime: json['startTime'] as String,
  subjectId: json['subjectId'] as String,
  teacherId: json['teacherId'] as String,
  type: json['type'] as String,
  weekType: json['weekType'] as String,
  createdAt: _dateTimeFromTimestamp(json['createdAt'] as Timestamp),
  updatedAt: _nullableDateTimeFromTimestamp(json['updatedAt'] as Timestamp?),
);

Map<String, dynamic> _$$LessonImplToJson(_$LessonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dayOfWeek': instance.dayOfWeek,
      'duration': instance.duration,
      'endTime': instance.endTime,
      'groupId': instance.groupId,
      'isFloating': instance.isFloating,
      'room': instance.room,
      'semesterId': instance.semesterId,
      'startTime': instance.startTime,
      'subjectId': instance.subjectId,
      'teacherId': instance.teacherId,
      'type': instance.type,
      'weekType': instance.weekType,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _nullableDateTimeToTimestamp(instance.updatedAt),
    };
