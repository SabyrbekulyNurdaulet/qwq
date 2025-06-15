// lib/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user.freezed.dart';
part 'user.g.dart';

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class User with _$User {
  const factory User({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    String? middleName,
    required String role,
    String? photoURL,
    String? groupId,
    String? iin,
    String? studentIdNumber,
    String? phone,
    @Default('pending_approval') String status,
    @TimestampConverter() DateTime? dateOfBirth,
    @TimestampConverter() DateTime? enrollmentDate,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(false) bool isActivated,
    DateTime? lastLoginAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

extension UserFullNameGetter on User {
  /// Возвращает полное имя в формате "Фамилия Имя Отчество"
  String get fullName {
    final parts = [lastName, firstName, middleName];
    return parts.where((part) => part != null && part.isNotEmpty).join(' ');
  }

  /// Возвращает имя в формате "И. О. Фамилия"
  String get shortName {
    final initialFirstName = firstName.isNotEmpty ? '${firstName[0]}.' : '';
    final initialMiddleName =
        (middleName != null && middleName!.isNotEmpty)
            ? '${middleName![0]}.'
            : '';
    return '$initialFirstName $initialMiddleName $lastName'.trim();
  }
}
