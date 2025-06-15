// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  uid: json['uid'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  middleName: json['middleName'] as String?,
  role: json['role'] as String,
  photoURL: json['photoURL'] as String?,
  groupId: json['groupId'] as String?,
  iin: json['iin'] as String?,
  studentIdNumber: json['studentIdNumber'] as String?,
  phone: json['phone'] as String?,
  status: json['status'] as String? ?? 'pending_approval',
  dateOfBirth: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['dateOfBirth'],
    const TimestampConverter().fromJson,
  ),
  enrollmentDate: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['enrollmentDate'],
    const TimestampConverter().fromJson,
  ),
  createdAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['createdAt'],
    const TimestampConverter().fromJson,
  ),
  updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['updatedAt'],
    const TimestampConverter().fromJson,
  ),
  isActivated: json['isActivated'] as bool? ?? false,
  lastLoginAt:
      json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'role': instance.role,
      'photoURL': instance.photoURL,
      'groupId': instance.groupId,
      'iin': instance.iin,
      'studentIdNumber': instance.studentIdNumber,
      'phone': instance.phone,
      'status': instance.status,
      'dateOfBirth': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.dateOfBirth,
        const TimestampConverter().toJson,
      ),
      'enrollmentDate': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.enrollmentDate,
        const TimestampConverter().toJson,
      ),
      'createdAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
      'isActivated': instance.isActivated,
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
