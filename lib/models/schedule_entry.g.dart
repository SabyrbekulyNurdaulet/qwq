// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleEntryImpl _$$ScheduleEntryImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleEntryImpl(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      semesterId: json['semesterId'] as String,
      subjectId: json['subjectId'] as String,
      teacherId: json['teacherId'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 1,
      type: json['type'] as String? ?? 'lecture',
      weekType: json['weekType'] as String? ?? 'all',
      room: json['room'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 90,
      isFloating: json['isFloating'] as bool? ?? false,
      createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['createdAt'],
        const TimestampConverter().fromJson,
      ),
      updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
        json['updatedAt'],
        const TimestampConverter().fromJson,
      ),
    );

Map<String, dynamic> _$$ScheduleEntryImplToJson(_$ScheduleEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'semesterId': instance.semesterId,
      'subjectId': instance.subjectId,
      'teacherId': instance.teacherId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'dayOfWeek': instance.dayOfWeek,
      'type': instance.type,
      'weekType': instance.weekType,
      'room': instance.room,
      'duration': instance.duration,
      'isFloating': instance.isFloating,
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
