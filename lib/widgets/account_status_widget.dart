// lib/widgets/account_status_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth_service.dart';

class AccountStatusWidget extends ConsumerWidget {
  const AccountStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        // Показываем статус только если он не "approved"
        if (user.status == 'approved') {
          return const SizedBox.shrink();
        }

        return _buildStatusBanner(context, user.status);
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatusBanner(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String title;
    String message;

    switch (status) {
      case 'pending_approval':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.hourglass_empty;
        title = 'Аккаунт ожидает подтверждения';
        message = 'Ваша заявка рассматривается администратором. Вы получите уведомление после одобрения.';
        break;
      case 'rejected':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel_outlined;
        title = 'Аккаунт отклонен';
        message = 'Ваша заявка была отклонена администратором. Обратитесь в службу поддержки для получения дополнительной информации.';
        break;
      case 'blocked':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.block;
        title = 'Аккаунт заблокирован';
        message = 'Ваш аккаунт был заблокирован администратором. Обратитесь в службу поддержки.';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        icon = Icons.info_outline;
        title = 'Неизвестный статус аккаунта';
        message = 'Статус вашего аккаунта неопределен. Обратитесь в службу поддержки.';
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Виджет для отображения статуса в AppBar
class AccountStatusAppBarWidget extends ConsumerWidget {
  const AccountStatusAppBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (user) {
        if (user == null || user.status == 'approved') {
          return const SizedBox.shrink();
        }

        Color color;
        IconData icon;

        switch (user.status) {
          case 'pending_approval':
            color = Colors.orange;
            icon = Icons.hourglass_empty;
            break;
          case 'rejected':
            color = Colors.red;
            icon = Icons.cancel_outlined;
            break;
          case 'blocked':
            color = Colors.red;
            icon = Icons.block;
            break;
          default:
            color = Colors.grey;
            icon = Icons.info_outline;
        }

        return IconButton(
          onPressed: () => _showStatusDialog(context, user.status),
          icon: Icon(icon, color: color),
          tooltip: 'Статус аккаунта',
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  void _showStatusDialog(BuildContext context, String status) {
    String title;
    String message;

    switch (status) {
      case 'pending_approval':
        title = 'Аккаунт ожидает подтверждения';
        message = 'Ваша заявка рассматривается администратором. Вы получите push-уведомление после одобрения аккаунта.';
        break;
      case 'rejected':
        title = 'Аккаунт отклонен';
        message = 'Ваша заявка была отклонена администратором. Для получения дополнительной информации обратитесь в службу поддержки.';
        break;
      case 'blocked':
        title = 'Аккаунт заблокирован';
        message = 'Ваш аккаунт был заблокирован администратором. Обратитесь в службу поддержки для разрешения ситуации.';
        break;
      default:
        title = 'Неизвестный статус';
        message = 'Статус вашего аккаунта неопределен. Обратитесь в службу поддержки.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Понятно'),
          ),
        ],
      ),
    );
  }
}

// Виджет для отображения ограниченного функционала
class RestrictedAccessWidget extends StatelessWidget {
  final String feature;
  final String? customMessage;

  const RestrictedAccessWidget({
    super.key,
    required this.feature,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Доступ ограничен',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            customMessage ?? 
            'Функция "$feature" недоступна до подтверждения аккаунта администратором.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ожидайте подтверждения аккаунта администратором'),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            label: const Text('Подробнее'),
          ),
        ],
      ),
    );
  }
}

