import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class ApprovalStatusMessage extends ConsumerWidget {
  const ApprovalStatusMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        switch (user.status) {
          case 'pending_approval':
            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange[100],
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ваша заявка на регистрацию находится на рассмотрении. '
                      'Пожалуйста, ожидайте подтверждения от администратора.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            );
          case 'rejected':
            return Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red[100],
              child: const Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ваша заявка на регистрацию была отклонена. '
                      'Пожалуйста, свяжитесь с администратором для уточнения деталей.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          case 'active':
            return const SizedBox.shrink();
          default:
            return const SizedBox.shrink();
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stack) => Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red[100],
            child: Text('Ошибка загрузки статуса: $error'),
          ),
    );
  }
}
