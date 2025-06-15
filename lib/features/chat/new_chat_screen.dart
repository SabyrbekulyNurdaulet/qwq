import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/group_provider.dart'; // Добавляем импорт
import 'chat_screen.dart';
import '../../core/auth_service.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  const NewChatScreen({required this.currentUserId, super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _groupNameController = TextEditingController();
  bool _isGroupChat = false;
  final Set<String> _selectedUserIds = {};

  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupNameController.dispose();
    _tabController.dispose();
    super.dispose();
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

  Future<void> _createChat() async {
    if (_selectedUserIds.isEmpty) return;

    final participants = [..._selectedUserIds, widget.currentUserId];
    String? chatName;

    if (_isGroupChat) {
      chatName = _groupNameController.text.trim();
      if (chatName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите название группы')),
        );
        return;
      }
    }

    try {
      final chatId = await ref.read(
        createChatProvider((
          participantIds: participants,
          name: chatName,
          type: _isGroupChat ? 'group' : 'private',
        )).future,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isGroupChat ? 'Группа успешно создана!' : 'Чат успешно создан!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => ChatScreen(
                chatId: chatId,
                currentUserId: widget.currentUserId,
                chatName: chatName ?? 'Чат',
              ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при создании чата: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final authUserAsync = ref.watch(authStateProvider);
    final searchQuery = _searchController.text.toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isGroupChat ? 'Новая группа' : 'Новый чат'),
        actions: [
          if (_selectedUserIds.isNotEmpty)
            IconButton(icon: const Icon(Icons.check), onPressed: _createChat),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Моя группа'),
            Tab(text: 'Преподаватели'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_isGroupChat)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: 'Название группы',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Поиск пользователей',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.group_add),
                  onPressed: () {
                    setState(() {
                      _isGroupChat = !_isGroupChat;
                      if (!_isGroupChat) {
                        _selectedUserIds.clear();
                      }
                    });
                  },
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Ошибка: $e')),
              data: (users) {
                return authUserAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Ошибка: $e')),
                  data: (authUser) {
                    if (authUser == null) {
                      return const Center(child: Text('Ошибка авторизации'));
                    }
                    // --- Фильтрация пользователей ---
                    List filteredUsers =
                        users.where((user) {
                          if (user.uid == widget.currentUserId)
                            return false; // ИСПРАВЛЕНО: user.uid вместо user.id
                          if (user.role == 'admin') return false;
                          final fullName =
                              '${user.lastName} ${user.firstName} ${user.middleName ?? ''}'
                                  .toLowerCase();
                          if (!fullName.contains(searchQuery)) return false;
                          if (_selectedTab == 1) {
                            // Моя группа
                            return user.role == 'student' &&
                                user.groupId != null &&
                                user.groupId == authUser.groupId;
                          } else if (_selectedTab == 2) {
                            // Преподаватели
                            return user.role == 'teacher';
                          }
                          return true;
                        }).toList();

                    if (filteredUsers.isEmpty) {
                      return const Center(
                        child: Text('Пользователи не найдены'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        final isSelected = _selectedUserIds.contains(
                          user.uid,
                        ); // ИСПРАВЛЕНО: user.uid вместо user.id
                        String subtitle = _roleToRu(user.role);
                        if (user.role == 'student' &&
                            user.groupId != null &&
                            user.groupId!.isNotEmpty) {
                          subtitle +=
                              ' • ${user.groupId}'; // Можно заменить на groupName если нужно
                        }
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              user.firstName.isNotEmpty
                                  ? user.firstName[0]
                                  : '?',
                            ),
                          ),
                          title: Text(
                            '${user.lastName} ${user.firstName} ${user.middleName ?? ''}'
                                .trim(),
                          ),
                          subtitle: Text(
                            subtitle.isNotEmpty ? subtitle : 'Роль не указана',
                          ),
                          trailing:
                              _isGroupChat
                                  ? Checkbox(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedUserIds.add(user.uid);
                                        } else {
                                          _selectedUserIds.remove(user.uid);
                                        }
                                      });
                                    },
                                  )
                                  : null,
                          onTap:
                              _isGroupChat
                                  ? null
                                  : () async {
                                    final context = this.context;
                                    final chatId = await ref.read(
                                      createChatProvider((
                                        participantIds: [
                                          user.uid, // ИСПРАВЛЕНО: user.uid вместо user.id
                                          widget.currentUserId,
                                        ],
                                        name: null,
                                        type: 'private',
                                      )).future,
                                    );

                                    if (!mounted) return;

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => ChatScreen(
                                              chatId: chatId,
                                              currentUserId:
                                                  widget.currentUserId,
                                              chatName:
                                                  '${user.lastName} ${user.firstName}',
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
      ),
    );
  }
}

// Отдельный виджет для отображения пользователя
class _UserListTile extends ConsumerWidget {
  final dynamic user; // User object
  final String currentUserId;
  final bool isGroupChat;
  final bool isSelected;
  final Function(bool) onSelectionChanged;
  final VoidCallback? onTap;

  const _UserListTile(this.onTap, {
    required this.user,
    required this.currentUserId,
    required this.isGroupChat,
    required this.isSelected,
    required this.onSelectionChanged,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String subtitle = _roleToRu(user.role);

    // Если пользователь студент и у него есть группа, показываем название группы
    if (user.role == 'student' &&
        user.groupId != null &&
        user.groupId!.isNotEmpty) {
      final groupNameAsync = ref.watch(groupNameProvider(user.groupId!));

      return groupNameAsync.when(
        data: (groupName) {
          // Извлекаем короткое название группы из полного
          final match = RegExp(r'группа ([^,]+)').firstMatch(groupName);
          final shortGroupName = match?.group(1) ?? user.groupId;
          subtitle += ' • $shortGroupName';

          return _buildListTile(subtitle);
        },
        loading: () => _buildListTile('$subtitle • ${user.groupId}'),
        error: (_, __) => _buildListTile('$subtitle • ${user.groupId}'),
      );
    }

    return _buildListTile(subtitle);
  }

  Widget _buildListTile(String subtitle) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.firstName[0])),
      title: Text(
        '${user.lastName} ${user.firstName} ${user.middleName ?? ''}',
      ),
      subtitle: Text(subtitle),
      trailing:
          isGroupChat
              ? Checkbox(
                value: isSelected,
                onChanged: (value) => onSelectionChanged(value ?? false),
              )
              : null,
      onTap: onTap,
    );
  }
}
