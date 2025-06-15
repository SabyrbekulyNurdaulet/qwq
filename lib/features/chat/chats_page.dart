import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import '../../services/user_service.dart';
import '../../models/chat.dart';
import 'chat_screen.dart';
import 'new_chat_screen.dart';

class ChatsPage extends ConsumerStatefulWidget {
  final String currentUserId;
  final bool showAppBar;
  final bool showAddButton;
  const ChatsPage({
    required this.currentUserId,
    this.showAppBar = true,
    this.showAddButton = true,
    super.key,
  });

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final _searchController = TextEditingController();
  final _userService = UserService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<String> _getChatName(Chat chat) async {
    if (chat.type == 'group') {
      return chat.name ?? 'Групповой чат';
    }

    // Для приватного чата получаем имя собеседника
    final otherUserId = chat.participantIds.firstWhere(
      (id) => id != widget.currentUserId,
    );
    final user = await _userService.getUserById(otherUserId);
    return user != null ? '${user.firstName} ${user.lastName}' : 'Пользователь';
  }

  @override
  Widget build(BuildContext context) {
    final chatsAsync = ref.watch(userChatsProvider(widget.currentUserId));
    final searchQuery = _searchController.text.toLowerCase();

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск чатов...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                      : null,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: chatsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Ошибка: $e')),
            data: (chats) {
              if (chats.isEmpty) {
                return const Center(child: Text('Нет чатов'));
              }

              final filteredChats =
                  chats.where((chat) {
                    final name = (chat.name ?? '').toLowerCase();
                    final lastMessage = (chat.lastMessage ?? '').toLowerCase();
                    return name.contains(searchQuery) ||
                        lastMessage.contains(searchQuery);
                  }).toList();

              if (filteredChats.isEmpty) {
                return const Center(child: Text('Чаты не найдены'));
              }

              return ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  return FutureBuilder<String>(
                    future: _getChatName(chat),
                    builder: (context, snapshot) {
                      final chatName = snapshot.data ?? 'Загрузка...';
                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              child:
                                  chat.type == 'group'
                                      ? const Icon(Icons.group)
                                      : const Icon(Icons.person),
                            ),
                            if (chat.unreadCount > 0 &&
                                chat.lastMessageSenderId !=
                                    widget.currentUserId)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    chat.unreadCount.toString(),
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(chatName),
                        subtitle: Text(chat.lastMessage ?? 'Нет сообщений'),
                        trailing:
                            chat.lastMessageAt != null
                                ? Text(
                                  TimeOfDay.fromDateTime(
                                    chat.lastMessageAt!,
                                  ).format(context),
                                  style: const TextStyle(fontSize: 12),
                                )
                                : null,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => ChatScreen(
                                    chatId: chat.id,
                                    currentUserId: widget.currentUserId,
                                    chatName: chatName,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Чаты'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            NewChatScreen(currentUserId: widget.currentUserId),
                  ),
                );
              },
            ),
          ],
        ),
        body: content,
      );
    } else {
      return Stack(
        children: [
          content,
          if (widget.showAddButton)
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => NewChatScreen(
                            currentUserId: widget.currentUserId,
                          ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
                tooltip: 'Новый чат',
              ),
            ),
        ],
      );
    }
  }
}
