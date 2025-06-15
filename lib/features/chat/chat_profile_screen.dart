import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/chat.dart';

class ChatProfileScreen extends ConsumerWidget {
  final String chatId;
  const ChatProfileScreen({required this.chatId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatAsync = ref.watch(chatByIdProvider(chatId));

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль чата')),
      body: chatAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Ошибка: $e')),
        data: (chat) {
          if (chat == null) {
            return const Center(child: Text('Чат не найден'));
          }
          return Column(
            children: [
              Expanded(child: _ChatProfileBody(chat: chat)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить чат'),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('Удалить чат?'),
                            content: const Text(
                              'Вы уверены, что хотите удалить этот чат? Все сообщения будут удалены безвозвратно.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      try {
                        await ref.read(chatServiceProvider).deleteChat(chat.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Чат успешно удалён!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context)
                            ..pop()
                            ..pop(); // Вернуться на список чатов
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ошибка при удалении чата: $e'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChatProfileBody extends ConsumerWidget {
  final Chat chat;
  const _ChatProfileBody({required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    return usersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Ошибка: $e')),
      data: (users) {
        final chatUsers =
            users.where((u) => chat.participantIds.contains(u.uid)).toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              chat.name ?? (chat.type == 'group' ? 'Групповой чат' : 'Чат'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Тип: ${chat.type == 'group' ? 'Групповой' : 'Личный'}'),
            const SizedBox(height: 16),
            Text('Участники:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...chatUsers.map(
              (user) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('${user.lastName} ${user.firstName}'),
                subtitle: Text(
                  '${_roleToRu(user.role)}${user.groupId != null ? ' • ${user.groupId}' : ''}',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _roleToRu(String role) {
    switch (role) {
      case 'student':
        return 'Студент';
      case 'teacher':
        return 'Преподаватель';
      case 'admin':
        return 'Администратор';
      default:
        return role;
    }
  }
}
