// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return _Lesson.fromJson(json);
}

/// @nodoc
mixin _$Lesson {
  String get id => throw _privateConstructorUsedError;
  int get dayOfWeek => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  bool get isFloating => throw _privateConstructorUsedError;
  String get room => throw _privateConstructorUsedError;
  String get semesterId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get weekType => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
    fromJson: _nullableDateTimeFromTimestamp,
    toJson: _nullableDateTimeToTimestamp,
  )
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Lesson to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LessonCopyWith<Lesson> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res, Lesson>;
  @useResult
  $Res call({
    String id,
    int dayOfWeek,
    int duration,
    String endTime,
    String groupId,
    bool isFloating,
    String room,
    String semesterId,
    String startTime,
    String subjectId,
    String teacherId,
    String type,
    String weekType,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _nullableDateTimeToTimestamp,
    )
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$LessonCopyWithImpl<$Res, $Val extends Lesson>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? duration = null,
    Object? endTime = null,
    Object? groupId = null,
    Object? isFloating = null,
    Object? room = null,
    Object? semesterId = null,
    Object? startTime = null,
    Object? subjectId = null,
    Object? teacherId = null,
    Object? type = null,
    Object? weekType = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            dayOfWeek:
                null == dayOfWeek
                    ? _value.dayOfWeek
                    : dayOfWeek // ignore: cast_nullable_to_non_nullable
                        as int,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as int,
            endTime:
                null == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as String,
            groupId:
                null == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String,
            isFloating:
                null == isFloating
                    ? _value.isFloating
                    : isFloating // ignore: cast_nullable_to_non_nullable
                        as bool,
            room:
                null == room
                    ? _value.room
                    : room // ignore: cast_nullable_to_non_nullable
                        as String,
            semesterId:
                null == semesterId
                    ? _value.semesterId
                    : semesterId // ignore: cast_nullable_to_non_nullable
                        as String,
            startTime:
                null == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as String,
            subjectId:
                null == subjectId
                    ? _value.subjectId
                    : subjectId // ignore: cast_nullable_to_non_nullable
                        as String,
            teacherId:
                null == teacherId
                    ? _value.teacherId
                    : teacherId // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            weekType:
                null == weekType
                    ? _value.weekType
                    : weekType // ignore: cast_nullable_to_non_nullable
                        as String,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
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
abstract class _$$LessonImplCopyWith<$Res> implements $LessonCopyWith<$Res> {
  factory _$$LessonImplCopyWith(
    _$LessonImpl value,
    $Res Function(_$LessonImpl) then,
  ) = __$$LessonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int dayOfWeek,
    int duration,
    String endTime,
    String groupId,
    bool isFloating,
    String room,
    String semesterId,
    String startTime,
    String subjectId,
    String teacherId,
    String type,
    String weekType,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _nullableDateTimeToTimestamp,
    )
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$LessonImplCopyWithImpl<$Res>
    extends _$LessonCopyWithImpl<$Res, _$LessonImpl>
    implements _$$LessonImplCopyWith<$Res> {
  __$$LessonImplCopyWithImpl(
    _$LessonImpl _value,
    $Res Function(_$LessonImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dayOfWeek = null,
    Object? duration = null,
    Object? endTime = null,
    Object? groupId = null,
    Object? isFloating = null,
    Object? room = null,
    Object? semesterId = null,
    Object? startTime = null,
    Object? subjectId = null,
    Object? teacherId = null,
    Object? type = null,
    Object? weekType = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LessonImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        dayOfWeek:
            null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                    as int,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as int,
        endTime:
            null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as String,
        groupId:
            null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String,
        isFloating:
            null == isFloating
                ? _value.isFloating
                : isFloating // ignore: cast_nullable_to_non_nullable
                    as bool,
        room:
            null == room
                ? _value.room
                : room // ignore: cast_nullable_to_non_nullable
                    as String,
        semesterId:
            null == semesterId
                ? _value.semesterId
                : semesterId // ignore: cast_nullable_to_non_nullable
                    as String,
        startTime:
            null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as String,
        subjectId:
            null == subjectId
                ? _value.subjectId
                : subjectId // ignore: cast_nullable_to_non_nullable
                    as String,
        teacherId:
            null == teacherId
                ? _value.teacherId
                : teacherId // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        weekType:
            null == weekType
                ? _value.weekType
                : weekType // ignore: cast_nullable_to_non_nullable
                    as String,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
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
class _$LessonImpl implements _Lesson {
  const _$LessonImpl({
    required this.id,
    required this.dayOfWeek,
    required this.duration,
    required this.endTime,
    required this.groupId,
    required this.isFloating,
    required this.room,
    required this.semesterId,
    required this.startTime,
    required this.subjectId,
    required this.teacherId,
    required this.type,
    required this.weekType,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required this.createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _nullableDateTimeToTimestamp,
    )
    this.updatedAt,
  });

  factory _$LessonImpl.fromJson(Map<String, dynamic> json) =>
      _$$LessonImplFromJson(json);

  @override
  final String id;
  @override
  final int dayOfWeek;
  @override
  final int duration;
  @override
  final String endTime;
  @override
  final String groupId;
  @override
  final bool isFloating;
  @override
  final String room;
  @override
  final String semesterId;
  @override
  final String startTime;
  @override
  final String subjectId;
  @override
  final String teacherId;
  @override
  final String type;
  @override
  final String weekType;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(
    fromJson: _nullableDateTimeFromTimestamp,
    toJson: _nullableDateTimeToTimestamp,
  )
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Lesson(id: $id, dayOfWeek: $dayOfWeek, duration: $duration, endTime: $endTime, groupId: $groupId, isFloating: $isFloating, room: $room, semesterId: $semesterId, startTime: $startTime, subjectId: $subjectId, teacherId: $teacherId, type: $type, weekType: $weekType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LessonImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.isFloating, isFloating) ||
                other.isFloating == isFloating) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.semesterId, semesterId) ||
                other.semesterId == semesterId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.weekType, weekType) ||
                other.weekType == weekType) &&
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
    dayOfWeek,
    duration,
    endTime,
    groupId,
    isFloating,
    room,
    semesterId,
    startTime,
    subjectId,
    teacherId,
    type,
    weekType,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      __$$LessonImplCopyWithImpl<_$LessonImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LessonImplToJson(this);
  }
}

abstract class _Lesson implements Lesson {
  const factory _Lesson({
    required final String id,
    required final int dayOfWeek,
    required final int duration,
    required final String endTime,
    required final String groupId,
    required final bool isFloating,
    required final String room,
    required final String semesterId,
    required final String startTime,
    required final String subjectId,
    required final String teacherId,
    required final String type,
    required final String weekType,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required final DateTime createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _nullableDateTimeToTimestamp,
    )
    final DateTime? updatedAt,
  }) = _$LessonImpl;

  factory _Lesson.fromJson(Map<String, dynamic> json) = _$LessonImpl.fromJson;

  @override
  String get id;
  @override
  int get dayOfWeek;
  @override
  int get duration;
  @override
  String get endTime;
  @override
  String get groupId;
  @override
  bool get isFloating;
  @override
  String get room;
  @override
  String get semesterId;
  @override
  String get startTime;
  @override
  String get subjectId;
  @override
  String get teacherId;
  @override
  String get type;
  @override
  String get weekType;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  @JsonKey(
    fromJson: _nullableDateTimeFromTimestamp,
    toJson: _nullableDateTimeToTimestamp,
  )
  DateTime? get updatedAt;

  /// Create a copy of Lesson
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LessonImplCopyWith<_$LessonImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
