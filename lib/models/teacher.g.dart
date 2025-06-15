// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherImpl _$$TeacherImplFromJson(
  Map<String, dynamic> json,
) => _$TeacherImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  education: json['education'] as String?,
  experience: (json['experience'] as num?)?.toInt(),
  specialization: json['specialization'] as String?,
  groups: (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
  subjects:
      (json['subjects'] as List<dynamic>?)?.map((e) => e as String).toList(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$TeacherImplToJson(_$TeacherImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'education': instance.education,
      'experience': instance.experience,
      'specialization': instance.specialization,
      'groups': instance.groups,
      'subjects': instance.subjects,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
