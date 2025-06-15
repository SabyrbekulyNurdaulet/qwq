import 'package:flutter/material.dart';
import 'package:mycollege/features/admin/home_screen.dart';
import 'package:mycollege/features/auth/loading_screen.dart';
import 'package:mycollege/features/auth/lock_screen.dart';
import 'package:mycollege/features/settings/pin/change_pin_screen.dart';
import 'package:mycollege/features/settings/pin/pin_setup_screen.dart';
import 'package:mycollege/features/settings/settings_screen.dart';
import 'package:mycollege/features/teacher/home_screen.dart';
import 'package:mycollege/features/student/edit_profile_page.dart';
import 'package:mycollege/models/user.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/auth_service.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/student/home_screen.dart';
import '../features/student/attendance_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/loading',
    redirect: (context, state) {
      final location = state.uri.toString();
      // Следим за AsyncValue<User?>
      final authState = ref.watch(authStateProvider);

      // 1. Если authState еще грузится, остаемся на /loading (если мы там)
      // Или идем на /loading, если еще не там (на случай прямого входа по ссылке)
      if (authState.isLoading) {
        debugPrint('[GoRouter Redirect] Auth state loading...');
        return location == '/loading' ? null : '/loading';
      }

      // 2. Если ошибка загрузки authState
      if (authState.hasError && location != '/login') {
        debugPrint(
          '[GoRouter Redirect] Auth state error, redirecting to /login',
        );
        return '/login';
      }

      // 3. authState загружен (есть данные или null)
      final isLoggedIn = authState.valueOrNull != null;
      final isLoggingArea =
          location == '/login' ||
          location == '/register' ||
          location == '/loading';

      debugPrint(
        '[GoRouter Redirect] Location: $location, isLoggedIn: $isLoggedIn, isLoggingArea: $isLoggingArea',
      );

      // --- НОВАЯ ЛОГИКА ДЛЯ /loading ---
      // 4. Если мы на /loading И пользователь НЕ вошел -> на /login
      if (location == '/loading' && !isLoggedIn) {
        debugPrint(
          '[GoRouter Redirect] Redirecting from /loading to /login (logged out)',
        );
        return '/login';
      }
      // 5. Если мы на /loading И пользователь ВОШЕЛ -> на /home
      if (location == '/loading' && isLoggedIn) {
        debugPrint(
          '[GoRouter Redirect] Redirecting from /loading to /home (logged in)',
        );
        return '/home';
      }
      // ---------------------------------

      // --- Старая логика для других случаев ---
      // 6. Если НЕ вошел И НЕ в зоне входа -> на /login
      if (!isLoggedIn && !isLoggingArea) {
        debugPrint(
          '[GoRouter Redirect] Redirecting to /login (not logged in, outside logging area)',
        );
        return '/login';
      }
      // 7. Если ВОШЕЛ И В зоне входа (кроме /loading, уже обработано) -> на /home
      if (isLoggedIn && (location == '/login' || location == '/register')) {
        debugPrint(
          '[GoRouter Redirect] Redirecting to /home (logged in, tried login/register)',
        );
        return '/home';
      }
      // ---------------------------------------

      // 8. Во всех остальных случаях - разрешаем
      debugPrint('[GoRouter Redirect] No redirection needed.');
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder:
            (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder:
            (BuildContext context, GoRouterState state) =>
                const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          final authState = ref.watch(authStateProvider);

          // Если состояние загрузки, показываем индикатор
          if (authState.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Если ошибка, показываем сообщение
          if (authState.hasError) {
            return Scaffold(
              body: Center(child: Text('Ошибка: ${authState.error}')),
            );
          }

          final user = authState.valueOrNull;
          if (user != null) {
            switch (user.role) {
              case 'student':
                return const StudentHomeScreen();
              case 'teacher':
                return const TeacherHomeScreen();
              case 'admin':
                return const AdminHomeScreen();
              default:
                return Scaffold(
                  body: Center(child: Text("Неизвестная роль: ${user.role}")),
                );
            }
          }

          // Если пользователь null, редиректим на /login
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'profile/edit', // Путь будет /home/profile/edit
            builder: (BuildContext context, GoRouterState state) {
              // Получаем объект User, переданный из ProfilePage
              final user = state.extra as User?;
              if (user != null) {
                return EditProfilePage(initialUser: user);
              } else {
                // Если данные не переданы, можно показать ошибку или вернуться назад
                // Возможно, лучше редиректить на /home или /profile
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'Ошибка: Не переданы данные пользователя для редактирования.',
                    ),
                  ),
                );
              }
            },
          ),
          GoRoute(
            path: 'attendance',
            builder: (context, state) => const AttendancePage(),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'pin/setup', // Относительный путь -> /settings/pin/setup
            builder: (context, state) => PinSetupScreen(),
          ),
          GoRoute(
            path: 'pin/change', // Относительный путь -> /settings/pin/change
            builder: (context, state) => ChangePinScreen(),
          ),
        ],
      ),
      GoRoute(path: '/lock', builder: (context, state) => const LockScreen()),
    ],
  );
});

class AppRouter {
  // --- Метод go() остается ---
  static void go(BuildContext context, String path, {Object? extra}) {
    // Используем GoRouter.of(context) для доступа к роутеру из текущего контекста
    try {
      GoRouter.of(context).go(path, extra: extra);
    } catch (e) {
      debugPrint(
        'GoRouter Error (go): $e. Context might not contain GoRouter.',
      );
      // Возможно, стоит показать SnackBar или залогировать ошибку серьезнее
    }
  }

  // --- ДОБАВЛЯЕМ МЕТОД push() ---
  static Future<T?> push<T extends Object?>(
    BuildContext context,
    String path, {
    Object? extra,
  }) async {
    // Добавляем async и возвращаемый тип Future<T?>
    try {
      // Возвращаем Future, который возвращает GoRouter.push<T>()
      return await GoRouter.of(context).push<T>(path, extra: extra);
    } catch (e) {
      debugPrint(
        'GoRouter Error (push): $e. Context might not contain GoRouter.',
      );
      return null; // Возвращаем null в случае ошибки
    }
  }

  // --- ДОБАВЛЯЕМ МЕТОД pop() ---
  static void pop(BuildContext context) {
    try {
      // Проверяем, можно ли вернуться назад
      if (GoRouter.of(context).canPop()) {
        GoRouter.of(context).pop();
      } else {
        debugPrint(
          'GoRouter Warning (pop): Cannot pop from the current route.',
        );
      }
    } catch (e) {
      debugPrint(
        'GoRouter Error (pop): $e. Context might not contain GoRouter.',
      );
    }
  }
}
