// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignmentImpl _$$AssignmentImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentImpl(
      id: json['id'] as String,
      teacherId: json['teacherId'] as String,
      groupId: json['groupId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: _timestampFromJson(json['dueDate']),
      scheduleEntryId: json['scheduleEntryId'] as String?,
      createdAt: _timestampFromJson(json['createdAt']),
      updatedAt: _timestampFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$AssignmentImplToJson(_$AssignmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teacherId': instance.teacherId,
      'groupId': instance.groupId,
      'title': instance.title,
      'description': instance.description,
      'dueDate': _timestampToJson(instance.dueDate),
      'scheduleEntryId': instance.scheduleEntryId,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
