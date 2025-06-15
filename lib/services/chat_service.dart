import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatService {
  final _db = FirebaseFirestore.instance;

  // Получить список чатов пользователя
  Stream<List<Chat>> getUserChats(String userId) {
    return _db
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
                  .toList(),
        );
  }

  // Получить сообщения чата
  Stream<List<Message>> getChatMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
                  .toList(),
        );
  }

  // Отправить сообщение
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    final now = DateTime.now();
    final messageRef =
        _db.collection('chats').doc(chatId).collection('messages').doc();
    await messageRef.set({
      'id': messageRef.id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'sentAt': now,
      'readBy': [senderId],
    });

    // Получаем чат для обновления
    final chatDoc = await _db.collection('chats').doc(chatId).get();
    final chatData = chatDoc.data();
    final participantIds = List<String>.from(chatData?['participantIds'] ?? []);

    // Увеличиваем счетчик только для других участников
    final otherParticipants =
        participantIds.where((id) => id != senderId).length;

    // Обновляем чат
    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastMessageAt': now,
      'updatedAt': now,
      'unreadCount': FieldValue.increment(otherParticipants),
      'lastMessageSenderId': senderId,
    });
  }

  // Создать новый чат
  Future<String> createChat({
    required List<String> participantIds,
    String? name,
    String type = 'private',
  }) async {
    final now = DateTime.now();
    final chatRef = _db.collection('chats').doc();
    await chatRef.set({
      'id': chatRef.id,
      'type': type,
      'name': name,
      'participantIds': participantIds,
      'createdAt': now,
      'updatedAt': now,
      'lastMessage': null,
      'lastMessageAt': null,
      'unreadCount': 0,
    });
    return chatRef.id;
  }

  // Удалить сообщение
  Future<void> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    final messagesRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    final chatRef = _db.collection('chats').doc(chatId);

    // Получаем сообщение, которое удаляем
    final msgDoc = await messagesRef.doc(messageId).get();
    if (!msgDoc.exists) {
      await messagesRef.doc(messageId).delete();
      return;
    }
    final msgData = msgDoc.data();
    final msgSentAt = msgData?['sentAt'];

    // Удаляем сообщение
    await messagesRef.doc(messageId).delete();

    // Проверяем, было ли оно последним (по времени)
    final lastMsgSnap =
        await messagesRef.orderBy('sentAt', descending: true).limit(1).get();
    if (lastMsgSnap.docs.isEmpty) {
      // Сообщений больше нет, сбрасываем lastMessage и lastMessageAt
      await chatRef.update({
        'lastMessage': null,
        'lastMessageAt': null,
        'updatedAt': DateTime.now(),
        'unreadCount': 0,
      });
    } else {
      final lastMsg = lastMsgSnap.docs.first.data();
      await chatRef.update({
        'lastMessage': lastMsg['text'],
        'lastMessageAt': lastMsg['sentAt'],
        'updatedAt': DateTime.now(),
        'unreadCount': FieldValue.increment(-1),
      });
    }
  }

  // Отметить сообщения как прочитанные
  Future<void> markMessagesAsRead({
    required String chatId,
    required String userId,
  }) async {
    final batch = _db.batch();
    final chatRef = _db.collection('chats').doc(chatId);
    final messagesRef = chatRef.collection('messages');

    // Получаем все сообщения, где readBy не содержит userId
    final unreadMessages =
        await messagesRef
            .where(
              'readBy',
              whereNotIn: [
                [userId],
              ],
            )
            .get();

    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'readBy': FieldValue.arrayUnion([userId]),
      });
    }

    // Сбрасываем счетчик непрочитанных сообщений
    batch.update(chatRef, {'unreadCount': 0});

    await batch.commit();
  }

  // Получить чат по chatId
  Stream<Chat?> getChatById(String chatId) {
    return _db.collection('chats').doc(chatId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Chat.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  // Удалить чат и все его сообщения
  Future<void> deleteChat(String chatId) async {
    final chatRef = _db.collection('chats').doc(chatId);
    final messagesRef = chatRef.collection('messages');
    final batch = _db.batch();

    // Получаем все сообщения
    final messages = await messagesRef.get();
    for (final doc in messages.docs) {
      batch.delete(doc.reference);
    }
    // Удаляем сам чат
    batch.delete(chatRef);
    await batch.commit();
  }
}
