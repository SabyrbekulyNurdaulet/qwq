// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScheduleEntry _$ScheduleEntryFromJson(Map<String, dynamic> json) {
  return _ScheduleEntry.fromJson(json);
}

/// @nodoc
mixin _$ScheduleEntry {
  // Обязательные поля, которые ДОЛЖНЫ быть в базе
  String get id => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get semesterId => throw _privateConstructorUsedError;
  String get subjectId => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime =>
      throw _privateConstructorUsedError; // Необязательные поля со значениями ПО УМОЛЧАНИЮ
  // Если этих полей не будет в базе, подставятся эти значения
  int get dayOfWeek => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get weekType => throw _privateConstructorUsedError;
  String get room => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  bool get isFloating =>
      throw _privateConstructorUsedError; // Поля с датой, которые могут быть null
  @TimestampConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ScheduleEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleEntryCopyWith<ScheduleEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleEntryCopyWith<$Res> {
  factory $ScheduleEntryCopyWith(
    ScheduleEntry value,
    $Res Function(ScheduleEntry) then,
  ) = _$ScheduleEntryCopyWithImpl<$Res, ScheduleEntry>;
  @useResult
  $Res call({
    String id,
    String groupId,
    String semesterId,
    String subjectId,
    String teacherId,
    String startTime,
    String endTime,
    int dayOfWeek,
    String type,
    String weekType,
    String room,
    int duration,
    bool isFloating,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class _$ScheduleEntryCopyWithImpl<$Res, $Val extends ScheduleEntry>
    implements $ScheduleEntryCopyWith<$Res> {
  _$ScheduleEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? semesterId = null,
    Object? subjectId = null,
    Object? teacherId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? dayOfWeek = null,
    Object? type = null,
    Object? weekType = null,
    Object? room = null,
    Object? duration = null,
    Object? isFloating = null,
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
            groupId:
                null == groupId
                    ? _value.groupId
                    : groupId // ignore: cast_nullable_to_non_nullable
                        as String,
            semesterId:
                null == semesterId
                    ? _value.semesterId
                    : semesterId // ignore: cast_nullable_to_non_nullable
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
            startTime:
                null == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as String,
            endTime:
                null == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as String,
            dayOfWeek:
                null == dayOfWeek
                    ? _value.dayOfWeek
                    : dayOfWeek // ignore: cast_nullable_to_non_nullable
                        as int,
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
            room:
                null == room
                    ? _value.room
                    : room // ignore: cast_nullable_to_non_nullable
                        as String,
            duration:
                null == duration
                    ? _value.duration
                    : duration // ignore: cast_nullable_to_non_nullable
                        as int,
            isFloating:
                null == isFloating
                    ? _value.isFloating
                    : isFloating // ignore: cast_nullable_to_non_nullable
                        as bool,
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
abstract class _$$ScheduleEntryImplCopyWith<$Res>
    implements $ScheduleEntryCopyWith<$Res> {
  factory _$$ScheduleEntryImplCopyWith(
    _$ScheduleEntryImpl value,
    $Res Function(_$ScheduleEntryImpl) then,
  ) = __$$ScheduleEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String groupId,
    String semesterId,
    String subjectId,
    String teacherId,
    String startTime,
    String endTime,
    int dayOfWeek,
    String type,
    String weekType,
    String room,
    int duration,
    bool isFloating,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ScheduleEntryImplCopyWithImpl<$Res>
    extends _$ScheduleEntryCopyWithImpl<$Res, _$ScheduleEntryImpl>
    implements _$$ScheduleEntryImplCopyWith<$Res> {
  __$$ScheduleEntryImplCopyWithImpl(
    _$ScheduleEntryImpl _value,
    $Res Function(_$ScheduleEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? semesterId = null,
    Object? subjectId = null,
    Object? teacherId = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? dayOfWeek = null,
    Object? type = null,
    Object? weekType = null,
    Object? room = null,
    Object? duration = null,
    Object? isFloating = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ScheduleEntryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        groupId:
            null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                    as String,
        semesterId:
            null == semesterId
                ? _value.semesterId
                : semesterId // ignore: cast_nullable_to_non_nullable
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
        startTime:
            null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as String,
        endTime:
            null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as String,
        dayOfWeek:
            null == dayOfWeek
                ? _value.dayOfWeek
                : dayOfWeek // ignore: cast_nullable_to_non_nullable
                    as int,
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
        room:
            null == room
                ? _value.room
                : room // ignore: cast_nullable_to_non_nullable
                    as String,
        duration:
            null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                    as int,
        isFloating:
            null == isFloating
                ? _value.isFloating
                : isFloating // ignore: cast_nullable_to_non_nullable
                    as bool,
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
class _$ScheduleEntryImpl implements _ScheduleEntry {
  const _$ScheduleEntryImpl({
    required this.id,
    required this.groupId,
    required this.semesterId,
    required this.subjectId,
    required this.teacherId,
    required this.startTime,
    required this.endTime,
    this.dayOfWeek = 1,
    this.type = 'lecture',
    this.weekType = 'all',
    this.room = '',
    this.duration = 90,
    this.isFloating = false,
    @TimestampConverter() this.createdAt,
    @TimestampConverter() this.updatedAt,
  });

  factory _$ScheduleEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleEntryImplFromJson(json);

  // Обязательные поля, которые ДОЛЖНЫ быть в базе
  @override
  final String id;
  @override
  final String groupId;
  @override
  final String semesterId;
  @override
  final String subjectId;
  @override
  final String teacherId;
  @override
  final String startTime;
  @override
  final String endTime;
  // Необязательные поля со значениями ПО УМОЛЧАНИЮ
  // Если этих полей не будет в базе, подставятся эти значения
  @override
  @JsonKey()
  final int dayOfWeek;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String weekType;
  @override
  @JsonKey()
  final String room;
  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey()
  final bool isFloating;
  // Поля с датой, которые могут быть null
  @override
  @TimestampConverter()
  final DateTime? createdAt;
  @override
  @TimestampConverter()
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ScheduleEntry(id: $id, groupId: $groupId, semesterId: $semesterId, subjectId: $subjectId, teacherId: $teacherId, startTime: $startTime, endTime: $endTime, dayOfWeek: $dayOfWeek, type: $type, weekType: $weekType, room: $room, duration: $duration, isFloating: $isFloating, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.semesterId, semesterId) ||
                other.semesterId == semesterId) &&
            (identical(other.subjectId, subjectId) ||
                other.subjectId == subjectId) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.dayOfWeek, dayOfWeek) ||
                other.dayOfWeek == dayOfWeek) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.weekType, weekType) ||
                other.weekType == weekType) &&
            (identical(other.room, room) || other.room == room) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isFloating, isFloating) ||
                other.isFloating == isFloating) &&
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
    groupId,
    semesterId,
    subjectId,
    teacherId,
    startTime,
    endTime,
    dayOfWeek,
    type,
    weekType,
    room,
    duration,
    isFloating,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ScheduleEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleEntryImplCopyWith<_$ScheduleEntryImpl> get copyWith =>
      __$$ScheduleEntryImplCopyWithImpl<_$ScheduleEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleEntryImplToJson(this);
  }
}

abstract class _ScheduleEntry implements ScheduleEntry {
  const factory _ScheduleEntry({
    required final String id,
    required final String groupId,
    required final String semesterId,
    required final String subjectId,
    required final String teacherId,
    required final String startTime,
    required final String endTime,
    final int dayOfWeek,
    final String type,
    final String weekType,
    final String room,
    final int duration,
    final bool isFloating,
    @TimestampConverter() final DateTime? createdAt,
    @TimestampConverter() final DateTime? updatedAt,
  }) = _$ScheduleEntryImpl;

  factory _ScheduleEntry.fromJson(Map<String, dynamic> json) =
      _$ScheduleEntryImpl.fromJson;

  // Обязательные поля, которые ДОЛЖНЫ быть в базе
  @override
  String get id;
  @override
  String get groupId;
  @override
  String get semesterId;
  @override
  String get subjectId;
  @override
  String get teacherId;
  @override
  String get startTime;
  @override
  String get endTime; // Необязательные поля со значениями ПО УМОЛЧАНИЮ
  // Если этих полей не будет в базе, подставятся эти значения
  @override
  int get dayOfWeek;
  @override
  String get type;
  @override
  String get weekType;
  @override
  String get room;
  @override
  int get duration;
  @override
  bool get isFloating; // Поля с датой, которые могут быть null
  @override
  @TimestampConverter()
  DateTime? get createdAt;
  @override
  @TimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of ScheduleEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleEntryImplCopyWith<_$ScheduleEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
