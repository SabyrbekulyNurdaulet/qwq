// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return _Grade.fromJson(json);
}

/// @nodoc
mixin _$Grade {
  String get id => throw _privateConstructorUsedError;
  String get subject => throw _privateConstructorUsedError;
  String get teacher => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get semester => throw _privateConstructorUsedError;
  bool get isNumeric => throw _privateConstructorUsedError;
  bool get isPassFail => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this Grade to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GradeCopyWith<Grade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeCopyWith<$Res> {
  factory $GradeCopyWith(Grade value, $Res Function(Grade) then) =
      _$GradeCopyWithImpl<$Res, Grade>;
  @useResult
  $Res call({
    String id,
    String subject,
    String teacher,
    DateTime date,
    double value,
    int semester,
    bool isNumeric,
    bool isPassFail,
    String? comment,
  });
}

/// @nodoc
class _$GradeCopyWithImpl<$Res, $Val extends Grade>
    implements $GradeCopyWith<$Res> {
  _$GradeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? teacher = null,
    Object? date = null,
    Object? value = null,
    Object? semester = null,
    Object? isNumeric = null,
    Object? isPassFail = null,
    Object? comment = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            subject:
                null == subject
                    ? _value.subject
                    : subject // ignore: cast_nullable_to_non_nullable
                        as String,
            teacher:
                null == teacher
                    ? _value.teacher
                    : teacher // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            semester:
                null == semester
                    ? _value.semester
                    : semester // ignore: cast_nullable_to_non_nullable
                        as int,
            isNumeric:
                null == isNumeric
                    ? _value.isNumeric
                    : isNumeric // ignore: cast_nullable_to_non_nullable
                        as bool,
            isPassFail:
                null == isPassFail
                    ? _value.isPassFail
                    : isPassFail // ignore: cast_nullable_to_non_nullable
                        as bool,
            comment:
                freezed == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GradeImplCopyWith<$Res> implements $GradeCopyWith<$Res> {
  factory _$$GradeImplCopyWith(
    _$GradeImpl value,
    $Res Function(_$GradeImpl) then,
  ) = __$$GradeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String subject,
    String teacher,
    DateTime date,
    double value,
    int semester,
    bool isNumeric,
    bool isPassFail,
    String? comment,
  });
}

/// @nodoc
class __$$GradeImplCopyWithImpl<$Res>
    extends _$GradeCopyWithImpl<$Res, _$GradeImpl>
    implements _$$GradeImplCopyWith<$Res> {
  __$$GradeImplCopyWithImpl(
    _$GradeImpl _value,
    $Res Function(_$GradeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subject = null,
    Object? teacher = null,
    Object? date = null,
    Object? value = null,
    Object? semester = null,
    Object? isNumeric = null,
    Object? isPassFail = null,
    Object? comment = freezed,
  }) {
    return _then(
      _$GradeImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        subject:
            null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                    as String,
        teacher:
            null == teacher
                ? _value.teacher
                : teacher // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        semester:
            null == semester
                ? _value.semester
                : semester // ignore: cast_nullable_to_non_nullable
                    as int,
        isNumeric:
            null == isNumeric
                ? _value.isNumeric
                : isNumeric // ignore: cast_nullable_to_non_nullable
                    as bool,
        isPassFail:
            null == isPassFail
                ? _value.isPassFail
                : isPassFail // ignore: cast_nullable_to_non_nullable
                    as bool,
        comment:
            freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GradeImpl implements _Grade {
  const _$GradeImpl({
    required this.id,
    required this.subject,
    required this.teacher,
    required this.date,
    required this.value,
    required this.semester,
    required this.isNumeric,
    this.isPassFail = false,
    this.comment,
  });

  factory _$GradeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GradeImplFromJson(json);

  @override
  final String id;
  @override
  final String subject;
  @override
  final String teacher;
  @override
  final DateTime date;
  @override
  final double value;
  @override
  final int semester;
  @override
  final bool isNumeric;
  @override
  @JsonKey()
  final bool isPassFail;
  @override
  final String? comment;

  @override
  String toString() {
    return 'Grade(id: $id, subject: $subject, teacher: $teacher, date: $date, value: $value, semester: $semester, isNumeric: $isNumeric, isPassFail: $isPassFail, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.semester, semester) ||
                other.semester == semester) &&
            (identical(other.isNumeric, isNumeric) ||
                other.isNumeric == isNumeric) &&
            (identical(other.isPassFail, isPassFail) ||
                other.isPassFail == isPassFail) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subject,
    teacher,
    date,
    value,
    semester,
    isNumeric,
    isPassFail,
    comment,
  );

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeImplCopyWith<_$GradeImpl> get copyWith =>
      __$$GradeImplCopyWithImpl<_$GradeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GradeImplToJson(this);
  }
}

abstract class _Grade implements Grade {
  const factory _Grade({
    required final String id,
    required final String subject,
    required final String teacher,
    required final DateTime date,
    required final double value,
    required final int semester,
    required final bool isNumeric,
    final bool isPassFail,
    final String? comment,
  }) = _$GradeImpl;

  factory _Grade.fromJson(Map<String, dynamic> json) = _$GradeImpl.fromJson;

  @override
  String get id;
  @override
  String get subject;
  @override
  String get teacher;
  @override
  DateTime get date;
  @override
  double get value;
  @override
  int get semester;
  @override
  bool get isNumeric;
  @override
  bool get isPassFail;
  @override
  String? get comment;

  /// Create a copy of Grade
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeImplCopyWith<_$GradeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
