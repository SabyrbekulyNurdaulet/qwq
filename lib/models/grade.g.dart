// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeImpl _$$GradeImplFromJson(Map<String, dynamic> json) => _$GradeImpl(
  id: json['id'] as String,
  subject: json['subject'] as String,
  teacher: json['teacher'] as String,
  date: DateTime.parse(json['date'] as String),
  value: (json['value'] as num).toDouble(),
  semester: (json['semester'] as num).toInt(),
  isNumeric: json['isNumeric'] as bool,
  isPassFail: json['isPassFail'] as bool? ?? false,
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$$GradeImplToJson(_$GradeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subject': instance.subject,
      'teacher': instance.teacher,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'semester': instance.semester,
      'isNumeric': instance.isNumeric,
      'isPassFail': instance.isPassFail,
      'comment': instance.comment,
    };
