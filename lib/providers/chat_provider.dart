import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/chat_service.dart';
import '../models/chat.dart';
import '../models/message.dart';

// Провайдер сервиса чатов
final chatServiceProvider = Provider((ref) => ChatService());

// Провайдер списка чатов пользователя
final userChatsProvider = StreamProvider.family<List<Chat>, String>((
  ref,
  userId,
) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getUserChats(userId);
});

// Провайдер сообщений в чате
final chatMessagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  chatId,
) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getChatMessages(chatId);
});

// Провайдер для отправки сообщения
final sendMessageProvider = FutureProvider.family
    .autoDispose<void, ({String chatId, String senderId, String text})>((
      ref,
      params,
    ) async {
      final chatService = ref.read(chatServiceProvider);
      await chatService.sendMessage(
        chatId: params.chatId,
        senderId: params.senderId,
        text: params.text,
      );
    });

// Провайдер для удаления сообщения
final deleteMessageProvider = FutureProvider.family
    .autoDispose<void, ({String chatId, String messageId})>((
      ref,
      params,
    ) async {
      final chatService = ref.read(chatServiceProvider);
      await chatService.deleteMessage(
        chatId: params.chatId,
        messageId: params.messageId,
      );
    });

// Провайдер для создания чата
final createChatProvider = FutureProvider.family.autoDispose<
  String,
  ({List<String> participantIds, String? name, String type})
>((ref, params) async {
  final chatService = ref.read(chatServiceProvider);
  return chatService.createChat(
    participantIds: params.participantIds,
    name: params.name,
    type: params.type,
  );
});

// Провайдер для отметки сообщений как прочитанных
final markMessagesAsReadProvider = FutureProvider.family
    .autoDispose<void, ({String chatId, String userId})>((ref, params) async {
      final chatService = ref.read(chatServiceProvider);
      await chatService.markMessagesAsRead(
        chatId: params.chatId,
        userId: params.userId,
      );
    });

// Провайдер для получения чата по chatId
final chatByIdProvider = StreamProvider.family<Chat?, String>((ref, chatId) {
  final chatService = ref.watch(chatServiceProvider);
  return chatService.getChatById(chatId);
});
