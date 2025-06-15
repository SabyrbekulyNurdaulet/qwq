// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Chat {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'group' или 'private'
  String? get name => throw _privateConstructorUsedError; // для группового чата
  List<String> get participantIds => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get unreadCount =>
      throw _privateConstructorUsedError; // количество непрочитанных сообщений
  String? get lastMessageSenderId => throw _privateConstructorUsedError;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatCopyWith<Chat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCopyWith<$Res> {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) then) =
      _$ChatCopyWithImpl<$Res, Chat>;
  @useResult
  $Res call({
    String id,
    String type,
    String? name,
    List<String> participantIds,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int unreadCount,
    String? lastMessageSenderId,
  });
}

/// @nodoc
class _$ChatCopyWithImpl<$Res, $Val extends Chat>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? participantIds = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? unreadCount = null,
    Object? lastMessageSenderId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                freezed == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String?,
            participantIds:
                null == participantIds
                    ? _value.participantIds
                    : participantIds // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            lastMessage:
                freezed == lastMessage
                    ? _value.lastMessage
                    : lastMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastMessageAt:
                freezed == lastMessageAt
                    ? _value.lastMessageAt
                    : lastMessageAt // ignore: cast_nullable_to_non_nullable
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
            unreadCount:
                null == unreadCount
                    ? _value.unreadCount
                    : unreadCount // ignore: cast_nullable_to_non_nullable
                        as int,
            lastMessageSenderId:
                freezed == lastMessageSenderId
                    ? _value.lastMessageSenderId
                    : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatImplCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$$ChatImplCopyWith(
    _$ChatImpl value,
    $Res Function(_$ChatImpl) then,
  ) = __$$ChatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String? name,
    List<String> participantIds,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    int unreadCount,
    String? lastMessageSenderId,
  });
}

/// @nodoc
class __$$ChatImplCopyWithImpl<$Res>
    extends _$ChatCopyWithImpl<$Res, _$ChatImpl>
    implements _$$ChatImplCopyWith<$Res> {
  __$$ChatImplCopyWithImpl(_$ChatImpl _value, $Res Function(_$ChatImpl) _then)
    : super(_value, _then);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = freezed,
    Object? participantIds = null,
    Object? lastMessage = freezed,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? unreadCount = null,
    Object? lastMessageSenderId = freezed,
  }) {
    return _then(
      _$ChatImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String?,
        participantIds:
            null == participantIds
                ? _value._participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        lastMessage:
            freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastMessageAt:
            freezed == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
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
        unreadCount:
            null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                    as int,
        lastMessageSenderId:
            freezed == lastMessageSenderId
                ? _value.lastMessageSenderId
                : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$ChatImpl implements _Chat {
  const _$ChatImpl({
    required this.id,
    required this.type,
    this.name,
    required final List<String> participantIds,
    this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.unreadCount = 0,
    this.lastMessageSenderId,
  }) : _participantIds = participantIds;

  @override
  final String id;
  @override
  final String type;
  // 'group' или 'private'
  @override
  final String? name;
  // для группового чата
  final List<String> _participantIds;
  // для группового чата
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final int unreadCount;
  // количество непрочитанных сообщений
  @override
  final String? lastMessageSenderId;

  @override
  String toString() {
    return 'Chat(id: $id, type: $type, name: $name, participantIds: $participantIds, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, createdAt: $createdAt, updatedAt: $updatedAt, unreadCount: $unreadCount, lastMessageSenderId: $lastMessageSenderId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    name,
    const DeepCollectionEquality().hash(_participantIds),
    lastMessage,
    lastMessageAt,
    createdAt,
    updatedAt,
    unreadCount,
    lastMessageSenderId,
  );

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      __$$ChatImplCopyWithImpl<_$ChatImpl>(this, _$identity);
}

abstract class _Chat implements Chat {
  const factory _Chat({
    required final String id,
    required final String type,
    final String? name,
    required final List<String> participantIds,
    final String? lastMessage,
    final DateTime? lastMessageAt,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final int unreadCount,
    final String? lastMessageSenderId,
  }) = _$ChatImpl;

  @override
  String get id;
  @override
  String get type; // 'group' или 'private'
  @override
  String? get name; // для группового чата
  @override
  List<String> get participantIds;
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int get unreadCount; // количество непрочитанных сообщений
  @override
  String? get lastMessageSenderId;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
