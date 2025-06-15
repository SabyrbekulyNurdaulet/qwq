// lib/features/student/profile_page.dart (Расширенная версия)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../models/user.dart';
import '../../core/auth_service.dart';
import '../../routes/app_router.dart';
import '../../providers/group_provider.dart'; // Добавляем импорт группового провайдера

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Подтверждение'),
            content: const Text('Вы уверены, что хотите выйти?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Выйти',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      try {
        await ref.read(authServiceProvider).signOut();
      } catch (e) {
        debugPrint("Sign out error: $e");
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка выхода: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return authState.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stackTrace) => Scaffold(
            appBar: AppBar(title: const Text('Ошибка')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки профиля',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(authStateProvider),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Профиль')),
            body: const Center(child: Text('Пользователь не найден.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Редактировать профиль',
                onPressed: () {
                  AppRouter.push(context, '/home/profile/edit', extra: user);
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Настройки',
                onPressed: () {
                  AppRouter.push(context, '/settings');
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(authStateProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Секция профиля пользователя
                  _buildProfileHeader(context, user, colorScheme, textTheme),
                  const SizedBox(height: 24),

                  // Основная информация
                  _buildPersonalInfoSection(
                    context,
                    user,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(height: 16),

                  // Информация об обучении (для студентов)
                  if (user.role == 'student') ...[
                    _buildStudyInfoSection(
                      context,
                      user,
                      colorScheme,
                      textTheme,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Контактная информация
                  _buildContactInfoSection(
                    context,
                    user,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(height: 16),

                  // Системная информация
                  _buildSystemInfoSection(
                    context,
                    user,
                    colorScheme,
                    textTheme,
                  ),
                  const SizedBox(height: 16),

                  // Кнопка выхода
                  _buildLogoutSection(context, ref, colorScheme, textTheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Column(
        children: [
          // Аватар
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.secondaryContainer,
                backgroundImage:
                    (user.photoURL != null && user.photoURL!.isNotEmpty)
                        ? NetworkImage(user.photoURL!)
                        : null,
                child:
                    (user.photoURL == null || user.photoURL!.isEmpty)
                        ? Icon(
                          Icons.person,
                          size: 60,
                          color: colorScheme.onSecondaryContainer,
                        )
                        : null,
              ),
              // Индикатор статуса
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: const SizedBox(width: 12, height: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Имя пользователя
          Text(
            user.fullName,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Роль пользователя
          Text(
            user.role == 'student' ? 'Студент' : 'Преподаватель',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Личная информация',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('ФИО'),
            subtitle: Text(
              user.fullName.isNotEmpty ? user.fullName : 'Не указано',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Дата рождения'),
            subtitle: Text(
              user.dateOfBirth != null
                  ? '${user.dateOfBirth!.day}.${user.dateOfBirth!.month}.${user.dateOfBirth!.year}'
                  : 'Не указано',
            ),
          ),
          if (user.iin != null && user.iin!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('ИИН'),
              subtitle: Text(user.iin!),
            ),
          if (user.studentIdNumber != null && user.studentIdNumber!.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Номер студенческого'),
              subtitle: Text(user.studentIdNumber!),
            ),
        ],
      ),
    );
  }

  Widget _buildStudyInfoSection(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Информация об обучении',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Группа
            Consumer(
              builder: (context, ref, child) {
                final groupNameAsync = ref.watch(
                  groupNameProvider(user.groupId ?? ''),
                );
                return groupNameAsync.when(
                  loading:
                      () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  error:
                      (error, stack) => Text(
                        'Ошибка загрузки группы',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                  data:
                      (groupName) => _buildInfoRow(
                        context,
                        'Группа',
                        groupName,
                        Icons.group_outlined,
                        colorScheme,
                        textTheme,
                      ),
                );
              },
            ),
            if (user.enrollmentDate != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                'Дата зачисления',
                '${user.enrollmentDate!.day}.${user.enrollmentDate!.month}.${user.enrollmentDate!.year}',
                Icons.calendar_today_outlined,
                colorScheme,
                textTheme,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoSection(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final hasContactInfo = (user.phone != null && user.phone!.isNotEmpty);

    if (!hasContactInfo) return const SizedBox.shrink();

    return _buildSection(
      context,
      'Контактная информация',
      Icons.contact_phone_outlined,
      colorScheme,
      textTheme,
      [
        if (user.phone != null && user.phone!.isNotEmpty)
          _buildInfoRow(
            context,
            'Телефон',
            user.phone!,
            Icons.phone_outlined,
            colorScheme,
            textTheme,
          ),
      ],
    );
  }

  Widget _buildSystemInfoSection(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return _buildSection(
      context,
      'Системная информация',
      Icons.info_outline,
      colorScheme,
      textTheme,
      [
        _buildInfoRow(
          context,
          'Статус аккаунта',
          _getStatusDisplayName(user.status),
          Icons.verified_user_outlined,
          colorScheme,
          textTheme,
        ),
        _buildInfoRow(
          context,
          'ID пользователя',
          user.uid,
          Icons.fingerprint,
          colorScheme,
          textTheme,
        ),
      ],
    );
  }

  Widget _buildLogoutSection(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Card(
      color: colorScheme.errorContainer.withOpacity(0.3),
      child: InkWell(
        onTap: () => _signOut(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.logout, color: colorScheme.error),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Выйти из аккаунта',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.error),
            ],
          ),
        ),
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 400.ms);
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<Widget> children,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(value, style: textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending_approval':
        return Colors.orange;
      case 'rejected':
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'pending_approval':
        return Icons.hourglass_empty;
      case 'rejected':
        return Icons.cancel;
      case 'suspended':
        return Icons.block;
      default:
        return Icons.help;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'active':
        return 'Активный';
      case 'pending_approval':
        return 'Ожидает подтверждения';
      case 'rejected':
        return 'Отклонен';
      case 'suspended':
        return 'Заблокирован';
      default:
        return status;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'student':
        return Colors.blue;
      case 'teacher':
        return Colors.green;
      case 'admin':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getRoleDisplayName(String role) {
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
