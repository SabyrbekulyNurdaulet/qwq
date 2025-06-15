// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get chatId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;
  List<String>? get readBy => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call({
    String id,
    String chatId,
    String senderId,
    String text,
    DateTime? sentAt,
    List<String>? readBy,
  });
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? text = null,
    Object? sentAt = freezed,
    Object? readBy = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            chatId:
                null == chatId
                    ? _value.chatId
                    : chatId // ignore: cast_nullable_to_non_nullable
                        as String,
            senderId:
                null == senderId
                    ? _value.senderId
                    : senderId // ignore: cast_nullable_to_non_nullable
                        as String,
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
            sentAt:
                freezed == sentAt
                    ? _value.sentAt
                    : sentAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            readBy:
                freezed == readBy
                    ? _value.readBy
                    : readBy // ignore: cast_nullable_to_non_nullable
                        as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
    _$MessageImpl value,
    $Res Function(_$MessageImpl) then,
  ) = __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String chatId,
    String senderId,
    String text,
    DateTime? sentAt,
    List<String>? readBy,
  });
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
    _$MessageImpl _value,
    $Res Function(_$MessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? chatId = null,
    Object? senderId = null,
    Object? text = null,
    Object? sentAt = freezed,
    Object? readBy = freezed,
  }) {
    return _then(
      _$MessageImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        chatId:
            null == chatId
                ? _value.chatId
                : chatId // ignore: cast_nullable_to_non_nullable
                    as String,
        senderId:
            null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                    as String,
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
        sentAt:
            freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        readBy:
            freezed == readBy
                ? _value._readBy
                : readBy // ignore: cast_nullable_to_non_nullable
                    as List<String>?,
      ),
    );
  }
}

/// @nodoc

class _$MessageImpl implements _Message {
  const _$MessageImpl({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    this.sentAt,
    final List<String>? readBy,
  }) : _readBy = readBy;

  @override
  final String id;
  @override
  final String chatId;
  @override
  final String senderId;
  @override
  final String text;
  @override
  final DateTime? sentAt;
  final List<String>? _readBy;
  @override
  List<String>? get readBy {
    final value = _readBy;
    if (value == null) return null;
    if (_readBy is EqualUnmodifiableListView) return _readBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Message(id: $id, chatId: $chatId, senderId: $senderId, text: $text, sentAt: $sentAt, readBy: $readBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            const DeepCollectionEquality().equals(other._readBy, _readBy));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    chatId,
    senderId,
    text,
    sentAt,
    const DeepCollectionEquality().hash(_readBy),
  );

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);
}

abstract class _Message implements Message {
  const factory _Message({
    required final String id,
    required final String chatId,
    required final String senderId,
    required final String text,
    final DateTime? sentAt,
    final List<String>? readBy,
  }) = _$MessageImpl;

  @override
  String get id;
  @override
  String get chatId;
  @override
  String get senderId;
  @override
  String get text;
  @override
  DateTime? get sentAt;
  @override
  List<String>? get readBy;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
