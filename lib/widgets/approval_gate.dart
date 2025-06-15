import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class ApprovalGate extends ConsumerWidget {
  final Widget child;
  final Widget? loadingWidget;
  final Widget? pendingWidget;
  final Widget? rejectedWidget;

  const ApprovalGate({
    super.key,
    required this.child,
    this.loadingWidget,
    this.pendingWidget,
    this.rejectedWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return userProfile.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Пользователь не найден'));
        }

        switch (user.status) {
          case 'active':
            return child;
          case 'pending_approval':
            return pendingWidget ??
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hourglass_empty,
                        size: 64,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ожидание подтверждения',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ваша заявка на регистрацию находится на рассмотрении.\n'
                        'Пожалуйста, ожидайте подтверждения от администратора.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
          case 'rejected':
            return rejectedWidget ??
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Доступ отклонен',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ваша заявка на регистрацию была отклонена.\n'
                        'Пожалуйста, свяжитесь с администратором для уточнения деталей.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Здесь можно добавить логику для выхода из аккаунта
                          // или отправки повторной заявки
                        },
                        child: const Text('Выйти из аккаунта'),
                      ),
                    ],
                  ),
                );
          default:
            return const Center(child: Text('Неизвестный статус пользователя'));
        }
      },
      loading:
          () =>
              loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
    );
  }
}
