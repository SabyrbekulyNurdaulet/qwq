import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import 'chat_profile_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String currentUserId;
  final String chatName;
  const ChatScreen({
    required this.chatId,
    required this.currentUserId,
    required this.chatName,
    super.key,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Отмечаем сообщения как прочитанные при открытии чата
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(
        markMessagesAsReadProvider((
          chatId: widget.chatId,
          userId: widget.currentUserId,
        )).future,
      );
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await ref.read(
      sendMessageProvider((
        chatId: widget.chatId,
        senderId: widget.currentUserId,
        text: text,
      )).future,
    );
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _deleteMessage(String messageId) async {
    await ref.read(
      deleteMessageProvider((
        chatId: widget.chatId,
        messageId: messageId,
      )).future,
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final chatAsync = ref.watch(chatByIdProvider(widget.chatId));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatProfileScreen(chatId: widget.chatId),
                ),
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Ошибка: $e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('Нет сообщений'));
                }
                return chatAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Ошибка чата: $e')),
                  data: (chat) {
                    if (chat == null) {
                      return const Center(child: Text('Чат не найден'));
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isMe = msg.senderId == widget.currentUserId;
                        final readBy = msg.readBy ?? [];
                        final allRead = chat.participantIds
                            .where((id) => id != msg.senderId)
                            .every((id) => readBy.contains(id));
                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: GestureDetector(
                            onLongPress:
                                isMe
                                    ? () => showDialog(
                                      context: context,
                                      builder:
                                          (ctx) => AlertDialog(
                                            title: const Text(
                                              'Удалить сообщение?',
                                            ),
                                            content: const Text(
                                              'Вы уверены, что хотите удалить это сообщение?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(ctx),
                                                child: const Text('Отмена'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(ctx);
                                                  _deleteMessage(msg.id);
                                                },
                                                child: const Text(
                                                  'Удалить',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    )
                                    : null,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                left: isMe ? 40 : 0,
                                right: isMe ? 0 : 40,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isMe
                                        ? colorScheme.primary
                                        : colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg.text,
                                    style: TextStyle(
                                      color:
                                          isMe
                                              ? colorScheme.onPrimary
                                              : colorScheme.onSurface,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        msg.sentAt != null
                                            ? TimeOfDay.fromDateTime(
                                              msg.sentAt!,
                                            ).format(context)
                                            : '',
                                        style: TextStyle(
                                          color:
                                              isMe
                                                  ? colorScheme.onPrimary
                                                      .withValues(
                                                        alpha: 0.7 * 255,
                                                      )
                                                  : colorScheme.onSurface,
                                          fontSize: 11,
                                        ),
                                      ),
                                      if (isMe && msg.readBy != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          child: Icon(
                                            allRead
                                                ? Icons.done_all
                                                : Icons.done,
                                            size: 16,
                                            color:
                                                allRead
                                                    ? Colors.blue
                                                    : colorScheme.onPrimary
                                                        .withOpacity(0.7),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Сообщение...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
