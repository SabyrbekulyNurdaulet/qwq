// lib/features/auth/account_status_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth_service.dart';
import '../../widgets/account_status_widget.dart';

class AccountStatusScreen extends ConsumerWidget {
  const AccountStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статус аккаунта'),
      ),
      body: authStateAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('Пользователь не найден'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Информация о пользователе
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Информация о пользователе',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('ФИО', '${user.lastName} ${user.firstName} ${user.middleName ?? ''}'),
                        _buildInfoRow('Email', user.email),
                        _buildInfoRow('Роль', _getRoleDisplayName(user.role)),
                        _buildInfoRow('Статус', _getStatusDisplayName(user.status)),
                        if (user.createdAt != null)
                          _buildInfoRow('Дата регистрации', _formatDate(user.createdAt!)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Статус аккаунта
                const AccountStatusWidget(),
                
                const SizedBox(height: 16),
                
                // Дополнительная информация в зависимости от статуса
                _buildStatusSpecificInfo(context, user.status),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки: $error'),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'student':
        return 'Студент';
      case 'teacher':
        return 'Преподаватель';
      case 'admin':
        return 'Администратор';
      case 'pending_approval':
        return 'Ожидает подтверждения';
      default:
        return role;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'approved':
        return 'Одобрен';
      case 'pending_approval':
        return 'Ожидает подтверждения';
      case 'rejected':
        return 'Отклонен';
      case 'blocked':
        return 'Заблокирован';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Widget _buildStatusSpecificInfo(BuildContext context, String status) {
    switch (status) {
      case 'pending_approval':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Что происходит?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Ваша заявка на регистрацию отправлена администратору\n'
                  '• Администратор рассмотрит вашу заявку и примет решение\n'
                  '• Вы получите push-уведомление о результате рассмотрения\n'
                  '• После одобрения вы сможете полноценно пользоваться приложением',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Обычно рассмотрение заявки занимает 1-2 рабочих дня',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        
      case 'rejected':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Заявка отклонена',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ваша заявка на регистрацию была отклонена администратором. '
                  'Возможные причины:\n\n'
                  '• Неполная или некорректная информация\n'
                  '• Вы не являетесь студентом или сотрудником учебного заведения\n'
                  '• Нарушение правил регистрации',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Здесь можно добавить логику для связи с поддержкой
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Функция обращения в поддержку будет добавлена'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Обратиться в поддержку'),
                  ),
                ),
              ],
            ),
          ),
        );
        
      case 'blocked':
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Аккаунт заблокирован',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ваш аккаунт был заблокирован администратором. '
                  'Это могло произойти по следующим причинам:\n\n'
                  '• Нарушение правил использования приложения\n'
                  '• Подозрительная активность\n'
                  '• Жалобы от других пользователей\n'
                  '• Технические причины',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Здесь можно добавить логику для связи с поддержкой
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Функция обращения в поддержку будет добавлена'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Обратиться в поддержку'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        
      default:
        return const SizedBox.shrink();
    }
  }
}

