// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Teacher _$TeacherFromJson(Map<String, dynamic> json) {
  return _Teacher.fromJson(json);
}

/// @nodoc
mixin _$Teacher {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get education => throw _privateConstructorUsedError;
  int? get experience => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  List<String>? get groups => throw _privateConstructorUsedError;
  List<String>? get subjects => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Teacher to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Teacher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherCopyWith<Teacher> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherCopyWith<$Res> {
  factory $TeacherCopyWith(Teacher value, $Res Function(Teacher) then) =
      _$TeacherCopyWithImpl<$Res, Teacher>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? education,
    int? experience,
    String? specialization,
    List<String>? groups,
    List<String>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$TeacherCopyWithImpl<$Res, $Val extends Teacher>
    implements $TeacherCopyWith<$Res> {
  _$TeacherCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Teacher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? education = freezed,
    Object? experience = freezed,
    Object? specialization = freezed,
    Object? groups = freezed,
    Object? subjects = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            userId:
                null == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as String,
            education:
                freezed == education
                    ? _value.education
                    : education // ignore: cast_nullable_to_non_nullable
                        as String?,
            experience:
                freezed == experience
                    ? _value.experience
                    : experience // ignore: cast_nullable_to_non_nullable
                        as int?,
            specialization:
                freezed == specialization
                    ? _value.specialization
                    : specialization // ignore: cast_nullable_to_non_nullable
                        as String?,
            groups:
                freezed == groups
                    ? _value.groups
                    : groups // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
            subjects:
                freezed == subjects
                    ? _value.subjects
                    : subjects // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeacherImplCopyWith<$Res> implements $TeacherCopyWith<$Res> {
  factory _$$TeacherImplCopyWith(
    _$TeacherImpl value,
    $Res Function(_$TeacherImpl) then,
  ) = __$$TeacherImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? education,
    int? experience,
    String? specialization,
    List<String>? groups,
    List<String>? subjects,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TeacherImplCopyWithImpl<$Res>
    extends _$TeacherCopyWithImpl<$Res, _$TeacherImpl>
    implements _$$TeacherImplCopyWith<$Res> {
  __$$TeacherImplCopyWithImpl(
    _$TeacherImpl _value,
    $Res Function(_$TeacherImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Teacher
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? education = freezed,
    Object? experience = freezed,
    Object? specialization = freezed,
    Object? groups = freezed,
    Object? subjects = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$TeacherImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        userId:
            null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as String,
        education:
            freezed == education
                ? _value.education
                : education // ignore: cast_nullable_to_non_nullable
                    as String?,
        experience:
            freezed == experience
                ? _value.experience
                : experience // ignore: cast_nullable_to_non_nullable
                    as int?,
        specialization:
            freezed == specialization
                ? _value.specialization
                : specialization // ignore: cast_nullable_to_non_nullable
                    as String?,
        groups:
            freezed == groups
                ? _value._groups
                : groups // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
        subjects:
            freezed == subjects
                ? _value._subjects
                : subjects // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherImpl implements _Teacher {
  const _$TeacherImpl({
    required this.id,
    required this.userId,
    this.education,
    this.experience,
    this.specialization,
    final List<String>? groups,
    final List<String>? subjects,
    this.createdAt,
    this.updatedAt,
  }) : _groups = groups,
       _subjects = subjects;

  factory _$TeacherImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? education;
  @override
  final int? experience;
  @override
  final String? specialization;
  final List<String>? _groups;
  @override
  List<String>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _subjects;
  @override
  List<String>? get subjects {
    final value = _subjects;
    if (value == null) return null;
    if (_subjects is EqualUnmodifiableListView) return _subjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Teacher(id: $id, userId: $userId, education: $education, experience: $experience, specialization: $specialization, groups: $groups, subjects: $subjects, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.education, education) ||
                other.education == education) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            const DeepCollectionEquality().equals(other._subjects, _subjects) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    education,
    experience,
    specialization,
    const DeepCollectionEquality().hash(_groups),
    const DeepCollectionEquality().hash(_subjects),
    createdAt,
    updatedAt,
  );

  /// Create a copy of Teacher
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherImplCopyWith<_$TeacherImpl> get copyWith =>
      __$$TeacherImplCopyWithImpl<_$TeacherImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherImplToJson(this);
  }
}

abstract class _Teacher implements Teacher {
  const factory _Teacher({
    required final String id,
    required final String userId,
    final String? education,
    final int? experience,
    final String? specialization,
    final List<String>? groups,
    final List<String>? subjects,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$TeacherImpl;

  factory _Teacher.fromJson(Map<String, dynamic> json) = _$TeacherImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get education;
  @override
  int? get experience;
  @override
  String? get specialization;
  @override
  List<String>? get groups;
  @override
  List<String>? get subjects;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Teacher
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherImplCopyWith<_$TeacherImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
