// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JournalEntry _$JournalEntryFromJson(Map<String, dynamic> json) {
  return _JournalEntry.fromJson(json);
}

/// @nodoc
mixin _$JournalEntry {
  String get id => throw _privateConstructorUsedError;
  String get journalId => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  String get attendanceStatus =>
      throw _privateConstructorUsedError; // 'present', 'absent', 'late'
  bool get present => throw _privateConstructorUsedError;
  String? get grade =>
      throw _privateConstructorUsedError; // Строка для гибкости (может быть числом или "зачет"/"незачет")
  String get gradeType =>
      throw _privateConstructorUsedError; // 'current', 'midterm', 'final'
  String? get comment => throw _privateConstructorUsedError;
  String? get topicCovered => throw _privateConstructorUsedError;
  String? get lessonId => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this JournalEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryCopyWith<JournalEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryCopyWith<$Res> {
  factory $JournalEntryCopyWith(
    JournalEntry value,
    $Res Function(JournalEntry) then,
  ) = _$JournalEntryCopyWithImpl<$Res, JournalEntry>;
  @useResult
  $Res call({
    String id,
    String journalId,
    String studentId,
    @TimestampConverter() DateTime date,
    String attendanceStatus,
    bool present,
    String? grade,
    String gradeType,
    String? comment,
    String? topicCovered,
    String? lessonId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class _$JournalEntryCopyWithImpl<$Res, $Val extends JournalEntry>
    implements $JournalEntryCopyWith<$Res> {
  _$JournalEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journalId = null,
    Object? studentId = null,
    Object? date = null,
    Object? attendanceStatus = null,
    Object? present = null,
    Object? grade = freezed,
    Object? gradeType = null,
    Object? comment = freezed,
    Object? topicCovered = freezed,
    Object? lessonId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            journalId:
                null == journalId
                    ? _value.journalId
                    : journalId // ignore: cast_nullable_to_non_nullable
                        as String,
            studentId:
                null == studentId
                    ? _value.studentId
                    : studentId // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            attendanceStatus:
                null == attendanceStatus
                    ? _value.attendanceStatus
                    : attendanceStatus // ignore: cast_nullable_to_non_nullable
                        as String,
            present:
                null == present
                    ? _value.present
                    : present // ignore: cast_nullable_to_non_nullable
                        as bool,
            grade:
                freezed == grade
                    ? _value.grade
                    : grade // ignore: cast_nullable_to_non_nullable
                        as String?,
            gradeType:
                null == gradeType
                    ? _value.gradeType
                    : gradeType // ignore: cast_nullable_to_non_nullable
                        as String,
            comment:
                freezed == comment
                    ? _value.comment
                    : comment // ignore: cast_nullable_to_non_nullable
                        as String?,
            topicCovered:
                freezed == topicCovered
                    ? _value.topicCovered
                    : topicCovered // ignore: cast_nullable_to_non_nullable
                        as String?,
            lessonId:
                freezed == lessonId
                    ? _value.lessonId
                    : lessonId // ignore: cast_nullable_to_non_nullable
                        as String?,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JournalEntryImplCopyWith<$Res>
    implements $JournalEntryCopyWith<$Res> {
  factory _$$JournalEntryImplCopyWith(
    _$JournalEntryImpl value,
    $Res Function(_$JournalEntryImpl) then,
  ) = __$$JournalEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String journalId,
    String studentId,
    @TimestampConverter() DateTime date,
    String attendanceStatus,
    bool present,
    String? grade,
    String gradeType,
    String? comment,
    String? topicCovered,
    String? lessonId,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
  });
}

/// @nodoc
class __$$JournalEntryImplCopyWithImpl<$Res>
    extends _$JournalEntryCopyWithImpl<$Res, _$JournalEntryImpl>
    implements _$$JournalEntryImplCopyWith<$Res> {
  __$$JournalEntryImplCopyWithImpl(
    _$JournalEntryImpl _value,
    $Res Function(_$JournalEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? journalId = null,
    Object? studentId = null,
    Object? date = null,
    Object? attendanceStatus = null,
    Object? present = null,
    Object? grade = freezed,
    Object? gradeType = null,
    Object? comment = freezed,
    Object? topicCovered = freezed,
    Object? lessonId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$JournalEntryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        journalId:
            null == journalId
                ? _value.journalId
                : journalId // ignore: cast_nullable_to_non_nullable
                    as String,
        studentId:
            null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        attendanceStatus:
            null == attendanceStatus
                ? _value.attendanceStatus
                : attendanceStatus // ignore: cast_nullable_to_non_nullable
                    as String,
        present:
            null == present
                ? _value.present
                : present // ignore: cast_nullable_to_non_nullable
                    as bool,
        grade:
            freezed == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                    as String?,
        gradeType:
            null == gradeType
                ? _value.gradeType
                : gradeType // ignore: cast_nullable_to_non_nullable
                    as String,
        comment:
            freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                    as String?,
        topicCovered:
            freezed == topicCovered
                ? _value.topicCovered
                : topicCovered // ignore: cast_nullable_to_non_nullable
                    as String?,
        lessonId:
            freezed == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                    as String?,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalEntryImpl implements _JournalEntry {
  const _$JournalEntryImpl({
    required this.id,
    required this.journalId,
    required this.studentId,
    @TimestampConverter() required this.date,
    required this.attendanceStatus,
    required this.present,
    this.grade,
    required this.gradeType,
    this.comment,
    this.topicCovered,
    this.lessonId,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
  });

  factory _$JournalEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String journalId;
  @override
  final String studentId;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  final String attendanceStatus;
  // 'present', 'absent', 'late'
  @override
  final bool present;
  @override
  final String? grade;
  // Строка для гибкости (может быть числом или "зачет"/"незачет")
  @override
  final String gradeType;
  // 'current', 'midterm', 'final'
  @override
  final String? comment;
  @override
  final String? topicCovered;
  @override
  final String? lessonId;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'JournalEntry(id: $id, journalId: $journalId, studentId: $studentId, date: $date, attendanceStatus: $attendanceStatus, present: $present, grade: $grade, gradeType: $gradeType, comment: $comment, topicCovered: $topicCovered, lessonId: $lessonId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.journalId, journalId) ||
                other.journalId == journalId) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.present, present) || other.present == present) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.gradeType, gradeType) ||
                other.gradeType == gradeType) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.topicCovered, topicCovered) ||
                other.topicCovered == topicCovered) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
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
    journalId,
    studentId,
    date,
    attendanceStatus,
    present,
    grade,
    gradeType,
    comment,
    topicCovered,
    lessonId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      __$$JournalEntryImplCopyWithImpl<_$JournalEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryImplToJson(this);
  }
}

abstract class _JournalEntry implements JournalEntry {
  const factory _JournalEntry({
    required final String id,
    required final String journalId,
    required final String studentId,
    @TimestampConverter() required final DateTime date,
    required final String attendanceStatus,
    required final bool present,
    final String? grade,
    required final String gradeType,
    final String? comment,
    final String? topicCovered,
    final String? lessonId,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
  }) = _$JournalEntryImpl;

  factory _JournalEntry.fromJson(Map<String, dynamic> json) =
      _$JournalEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get journalId;
  @override
  String get studentId;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  String get attendanceStatus; // 'present', 'absent', 'late'
  @override
  bool get present;
  @override
  String? get grade; // Строка для гибкости (может быть числом или "зачет"/"незачет")
  @override
  String get gradeType; // 'current', 'midterm', 'final'
  @override
  String? get comment;
  @override
  String? get topicCovered;
  @override
  String? get lessonId;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of JournalEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryImplCopyWith<_$JournalEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
