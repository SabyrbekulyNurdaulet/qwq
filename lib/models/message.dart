import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message.freezed.dart';
// part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String text,
    DateTime? sentAt,
    List<String>? readBy,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      sentAt: _parseTimestamp(json['sentAt']),
      readBy: (json['readBy'] as List<dynamic>?)?.cast<String>(),
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
