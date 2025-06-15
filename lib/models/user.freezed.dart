// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String? get photoURL => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get iin => throw _privateConstructorUsedError;
  String? get studentIdNumber => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get enrollmentDate => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isActivated => throw _privateConstructorUsedError;
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String uid,
    String email,
    String firstName,
    String lastName,
    String? middleName,
    String role,
    String? photoURL,
    String? groupId,
    String? iin,
    String? studentIdNumber,
    String? phone,
    String status,
    @TimestampConverter() DateTime? dateOfBirth,
    @TimestampConverter() DateTime? enrollmentDate,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    bool isActivated,
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? role = null,
    Object? photoURL = freezed,
    Object? groupId = freezed,
    Object? iin = freezed,
    Object? studentIdNumber = freezed,
    Object? phone = freezed,
    Object? status = null,
    Object? dateOfBirth = freezed,
    Object? enrollmentDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActivated = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            uid:
                null == uid
                    ? _value.uid
                    : uid // ignore: cast_nullable_to_non_nullable
                        as String,
            email:
                null == email
                    ? _value.email
                    : email // ignore: cast_nullable_to_non_nullable
                        as String,
            firstName:
                null == firstName
                    ? _value.firstName
                    : firstName // ignore: cast_nullable_to_non_nullable
                        as String,
            lastName:
                null == lastName
                    ? _value.lastName
                    : lastName // ignore: cast_nullable_to_non_nullable
                        as String,
            middleName:
                freezed == middleName
                    ? _value.middleName
                    : middleName // ignore: cast_nullable_to_non_nullable
                        as String?,
            role:
                null == role
                    ? _value.role
                    : role // ignore: cast_nullable_to_non_nullable
                        as String,
            photoURL:
                freezed == photoURL
                    ? _value.photoURL
                    : photoURL // ignore: cast_nullable_to_non_nullable
                        as String?,
            groupId:
                freezed == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String?,
            iin:
                freezed == iin
                    ? _value.iin
                    : iin // ignore: cast_nullable_to_non_nullable
                        as String?,
            studentIdNumber:
                freezed == studentIdNumber
                    ? _value.studentIdNumber
                    : studentIdNumber // ignore: cast_nullable_to_non_nullable
                        as String?,
            phone:
                freezed == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String?,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            dateOfBirth:
                freezed == dateOfBirth
                    ? _value.dateOfBirth
                    : dateOfBirth // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            enrollmentDate:
                freezed == enrollmentDate
                    ? _value.enrollmentDate
                    : enrollmentDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            isActivated:
                null == isActivated
                    ? _value.isActivated
                    : isActivated // ignore: cast_nullable_to_non_nullable
                        as bool,
            lastLoginAt:
                freezed == lastLoginAt
                    ? _value.lastLoginAt
                    : lastLoginAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String email,
    String firstName,
    String lastName,
    String? middleName,
    String role,
    String? photoURL,
    String? groupId,
    String? iin,
    String? studentIdNumber,
    String? phone,
    String status,
    @TimestampConverter() DateTime? dateOfBirth,
    @TimestampConverter() DateTime? enrollmentDate,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    bool isActivated,
    DateTime? lastLoginAt,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? middleName = freezed,
    Object? role = null,
    Object? photoURL = freezed,
    Object? groupId = freezed,
    Object? iin = freezed,
    Object? studentIdNumber = freezed,
    Object? phone = freezed,
    Object? status = null,
    Object? dateOfBirth = freezed,
    Object? enrollmentDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isActivated = null,
    Object? lastLoginAt = freezed,
  }) {
    return _then(
      _$UserImpl(
        uid:
            null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                    as String,
        email:
            null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                    as String,
        firstName:
            null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                    as String,
        lastName:
            null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                    as String,
        middleName:
            freezed == middleName
                ? _value.middleName
                : middleName // ignore: cast_nullable_to_non_nullable
                    as String?,
        role:
            null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                    as String,
        photoURL:
            freezed == photoURL
                ? _value.photoURL
                : photoURL // ignore: cast_nullable_to_non_nullable
                    as String?,
        groupId:
            freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String?,
        iin:
            freezed == iin
                ? _value.iin
                : iin // ignore: cast_nullable_to_non_nullable
                    as String?,
        studentIdNumber:
            freezed == studentIdNumber
                ? _value.studentIdNumber
                : studentIdNumber // ignore: cast_nullable_to_non_nullable
                    as String?,
        phone:
            freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String?,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        dateOfBirth:
            freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        enrollmentDate:
            freezed == enrollmentDate
                ? _value.enrollmentDate
                : enrollmentDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        isActivated:
            null == isActivated
                ? _value.isActivated
                : isActivated // ignore: cast_nullable_to_non_nullable
                    as bool,
        lastLoginAt:
            freezed == lastLoginAt
                ? _value.lastLoginAt
                : lastLoginAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.role,
    this.photoURL,
    this.groupId,
    this.iin,
    this.studentIdNumber,
    this.phone,
    this.status = 'pending_approval',
    @TimestampConverter() this.dateOfBirth,
    @TimestampConverter() this.enrollmentDate,
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
    this.isActivated = false,
    this.lastLoginAt,
  });

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String? middleName;
  @override
  final String role;
  @override
  final String? photoURL;
  @override
  final String? groupId;
  @override
  final String? iin;
  @override
  final String? studentIdNumber;
  @override
  final String? phone;
  @override
  @JsonKey()
  final String status;
  @override
  @TimestampConverter()
  final DateTime? dateOfBirth;
  @override
  @TimestampConverter()
  final DateTime? enrollmentDate;
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isActivated;
  @override
  final DateTime? lastLoginAt;

  @override
  String toString() {
    return 'User(uid: $uid, email: $email, firstName: $firstName, lastName: $lastName, middleName: $middleName, role: $role, photoURL: $photoURL, groupId: $groupId, iin: $iin, studentIdNumber: $studentIdNumber, phone: $phone, status: $status, dateOfBirth: $dateOfBirth, enrollmentDate: $enrollmentDate, createdAt: $createdAt, updatedAt: $updatedAt, isActivated: $isActivated, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.photoURL, photoURL) ||
                other.photoURL == photoURL) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.iin, iin) || other.iin == iin) &&
            (identical(other.studentIdNumber, studentIdNumber) ||
                other.studentIdNumber == studentIdNumber) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.enrollmentDate, enrollmentDate) ||
                other.enrollmentDate == enrollmentDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActivated, isActivated) ||
                other.isActivated == isActivated) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    email,
    firstName,
    lastName,
    middleName,
    role,
    photoURL,
    groupId,
    iin,
    studentIdNumber,
    phone,
    status,
    dateOfBirth,
    enrollmentDate,
    createdAt,
    updatedAt,
    isActivated,
    lastLoginAt,
  );

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({
    required final String uid,
    required final String email,
    required final String firstName,
    required final String lastName,
    final String? middleName,
    required final String role,
    final String? photoURL,
    final String? groupId,
    final String? iin,
    final String? studentIdNumber,
    final String? phone,
    final String status,
    @TimestampConverter() final DateTime? dateOfBirth,
    @TimestampConverter() final DateTime? enrollmentDate,
    @TimestampConverter() final DateTime? createdAt,
    @TimestampConverter() final DateTime? updatedAt,
    final bool isActivated,
    final DateTime? lastLoginAt,
  }) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String? get middleName;
  @override
  String get role;
  @override
  String? get photoURL;
  @override
  String? get groupId;
  @override
  String? get iin;
  @override
  String? get studentIdNumber;
  @override
  String? get phone;
  @override
  String get status;
  @override
  @TimestampConverter()
  DateTime? get dateOfBirth;
  @override
  @TimestampConverter()
  DateTime? get enrollmentDate;
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;
  @override
  bool get isActivated;
  @override
  DateTime? get lastLoginAt;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
