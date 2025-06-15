import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat.freezed.dart';
// part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String type, // 'group' или 'private'
    String? name, // для группового чата
    required List<String> participantIds,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int unreadCount, // количество непрочитанных сообщений
    String? lastMessageSenderId, // id отправителя последнего сообщения
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String?,
      participantIds: (json['participantIds'] as List<dynamic>).cast<String>(),
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: _parseTimestamp(json['lastMessageAt']),
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is Timestamp) return value.toDate();
    return null;
  }
}
