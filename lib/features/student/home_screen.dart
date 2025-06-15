// lib/features/student/home_screen.dart
import 'dart:async'; // Для Timer/Duration
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Для получения пользователя
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Для проверки флагов
// Для WidgetsBindingObserver и HapticFeedback

// Импорты наших экранов и виджетов
import '../auth/lock_screen.dart'; // Экран блокировки
// import '../../routes/app_router.dart'; // Не используется напрямую в этом файле

// Импорты страниц разделов
import 'profile_page.dart';
import 'schedule_page.dart';
import 'grades_page.dart';
import 'performance_page.dart';
import '../chat/chats_page.dart';
import '../news/news_feed_page.dart';
import 'attendance_page.dart';
// import 'activities_page.dart'; // Если нужен раздел активностей

// --- Виджет для сохранения состояния вкладки ---
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});
  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context); // Важно вызвать super.build
    return widget.child;
  }

  // Возвращаем true, чтобы сохранить состояние
  @override
  bool get wantKeepAlive => true;
}
// ---------------------------------------------

// --- StudentHomeScreen ---
// Используем ConsumerStatefulWidget и добавляем WidgetsBindingObserver
class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});
  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen>
    with WidgetsBindingObserver {
  // --- Состояние навигации ---
  int _selectedIndex = 0;
  late PageController _pageController;

  // --- Состояние и настройки блокировки ---
  final _storage = const FlutterSecureStorage();
  bool _isLockScreenVisible = false; // Флаг, показан ли экран блокировки
  DateTime? _pausedTime; // Время паузы приложения
  final Duration _lockTimeout = const Duration(
    minutes: 1,
  ); // Таймаут блокировки после сворачивания
  DateTime? _lastUnlockTime; // Время последней успешной разблокировки
  Timer? _lockTimer; // Таймер для блокировки по неактивности
  final Duration _inactiveLockTimeout = const Duration(
    minutes: 5,
  ); // Таймаут неактивности
  String? _userId; // ID текущего пользователя
  bool _wasResumed = true; // Флаг, что приложение было активно перед паузой

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    _pageController = PageController(initialPage: _selectedIndex);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Проверяем блокировку при старте СНАЧАЛА
      _checkLockOnStart().then((didShowLock) {
        // Запускаем таймер неактивности ТОЛЬКО если экран не заблокировался сразу
        if (!didShowLock && mounted) {
          _resetInactiveTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this); // Удаляем наблюдатель
    _lockTimer?.cancel(); // Отменяем таймер
    super.dispose();
  }

  // --- Логика Блокировки ---

  // Сброс и запуск таймера неактивности
  void _resetInactiveTimer() {
    _lockTimer?.cancel();
    // Запускаем таймер только если пользователь вошел, ПИН/Био включены,
    // виджет активен И экран блокировки НЕ показан
    if (_userId != null && mounted && !_isLockScreenVisible) {
      _checkPinBioStatus().then((isEnabled) {
        if (isEnabled && mounted && !_isLockScreenVisible) {
          // Повторная проверка флага
          _lockTimer = Timer(_inactiveLockTimeout, () {
            debugPrint("[HomeScreen] Inactive timeout reached.");
            // Проверяем еще раз перед показом, вдруг виджет удалили
            if (mounted) {
              _showLockScreen();
            }
          });
          // debugPrint("[HomeScreen] Inactivity timer reset and started.");
        } else {
          // debugPrint("[HomeScreen] Inactivity timer not started (PIN/Bio disabled or lock visible).");
        }
      });
    } else {
      // debugPrint("[HomeScreen] Inactivity timer not started (user null or unmounted or lock visible).");
    }
  }

  // Проверка, включен ли ПИН или Биометрия
  Future<bool> _checkPinBioStatus() async {
    if (_userId == null) return false; // Используем _userId из состояния
    try {
      final pinEnabled =
          await _storage.read(key: 'pin_enabled_$_userId') == 'true';
      final bioEnabled =
          await _storage.read(key: 'bio_enabled_$_userId') == 'true';
      return pinEnabled || bioEnabled;
    } catch (e) {
      debugPrint("Error reading PIN/Bio status: $e");
      return false;
    }
  }

  // Обработчик взаимодействия пользователя (сброс таймера)
  void _handleUserInteraction([_]) {
    // Эта функция вызывается часто, можно убрать print для чистоты логов
    // debugPrint("User interaction detected. Resetting inactive timer.");
    _resetInactiveTimer();
  }

  // Возвращает true, если LockScreen был показан
  Future<bool> _checkLockOnStart() async {
    bool isEnabled = await _checkPinBioStatus();
    if (isEnabled && mounted) {
      debugPrint("[HomeScreen] PIN/Bio enabled. Showing lock screen on start.");
      await _showLockScreen(); // Ждем завершения показа
      return true; // Сообщаем, что экран был показан
    } else {
      debugPrint("[HomeScreen] Lock screen on start skipped.");
      return false;
    }
  }

  // Отслеживание состояния приложения
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint(
      "[HomeScreen] App Lifecycle State: $state, _wasResumed: $_wasResumed",
    );

    switch (state) {
      case AppLifecycleState.resumed:
        final resumeTime = DateTime.now();
        debugPrint("[HomeScreen] App Resumed at: $resumeTime");
        _wasResumed = true; // Ставим флаг, что приложение активно

        // Перезапускаем таймер неактивности при возвращении
        _resetInactiveTimer();

        // Защита от зацикливания
        if (_lastUnlockTime != null &&
            resumeTime.difference(_lastUnlockTime!) <
                const Duration(seconds: 2)) {
          debugPrint(
            "[HomeScreen] Ignoring resume event shortly after unlock.",
          );
          _pausedTime = null;
          return;
        }

        // Проверка таймаута ПОСЛЕ СВОРАЧИВАНИЯ
        bool requireLockDueToTimeout = false;
        if (_pausedTime != null) {
          // Проверяем, было ли время паузы записано
          final durationInBackground = resumeTime.difference(_pausedTime!);
          if (durationInBackground >= _lockTimeout) {
            requireLockDueToTimeout = true;
            debugPrint(
              "[HomeScreen] Lock timeout exceeded (${durationInBackground.inSeconds}s >= ${_lockTimeout.inSeconds}s). Lock screen required.",
            );
          } else {
            debugPrint(
              "[HomeScreen] Resume within timeout (${durationInBackground.inSeconds}s < ${_lockTimeout.inSeconds}s). No timeout lock needed.",
            );
          }
          _pausedTime = null; // Сбрасываем время паузы ПОСЛЕ проверки
        } else {
          debugPrint(
            "[HomeScreen] App Resumed (no pause time recorded). No timeout lock needed.",
          );
        }

        // Показываем LockScreen по таймауту ПОСЛЕ СВОРАЧИВАНИЯ
        if (requireLockDueToTimeout) {
          _showLockScreen();
        }
        break; // Конец case resumed

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden: // Добавим hidden для полноты
        // --- ИСПРАВЛЕНО: Запоминаем время паузы только один раз при переходе из resumed ---
        if (_wasResumed && !_isLockScreenVisible) {
          _pausedTime = DateTime.now();
          debugPrint(
            "[HomeScreen] App Paused/Inactive at: $_pausedTime (state: $state)",
          );
        } else if (_isLockScreenVisible) {
          debugPrint(
            "[HomeScreen] App Paused/Inactive, but lock screen is visible. Ignoring pause time update.",
          );
        } else {
          // Это может быть несколько событий паузы/неактивности подряд, игнорируем
          debugPrint(
            "[HomeScreen] App Paused/Inactive again, ignoring pause time update. (state: $state)",
          );
        }
        // --- ИСПРАВЛЕНО: Отменяем таймер неактивности при паузе ---
        _lockTimer?.cancel();
        // -------------------------------------------------------
        _wasResumed = false; // Сбрасываем флаг активности
        break; // Конец case paused/inactive/detached/hidden
    }
  }

  // Показ экрана блокировки
  Future<void> _showLockScreen() async {
    if (_isLockScreenVisible || _userId == null || !mounted) {
      debugPrint(
        "[HomeScreen] Skipping _showLockScreen: visible=$_isLockScreenVisible, userId=$_userId, mounted=$mounted",
      );
      return;
    }

    // --- ИСПРАВЛЕНО: Отменяем таймер неактивности ПЕРЕД показом LockScreen ---
    _lockTimer?.cancel();
    // -------------------------------------------------------------------

    bool isEnabled = await _checkPinBioStatus();
    if (!mounted) return;

    if (!isEnabled) {
      debugPrint(
        "[HomeScreen] Lock screen presentation skipped (PIN/Bio disabled).",
      );
      _resetInactiveTimer(); // Перезапустим таймер на случай включения настроек
      return;
    }

    debugPrint("[HomeScreen] Showing lock screen modally...");
    setState(() => _isLockScreenVisible = true);

    bool? unlocked = await Navigator.of(
      context,
      rootNavigator: true,
    ).push<bool>(
      MaterialPageRoute(
        builder: (context) => const LockScreen(),
        fullscreenDialog: true,
      ),
    );

    debugPrint("[HomeScreen] Lock screen result: $unlocked");
    if (!mounted) return;

    _lastUnlockTime =
        DateTime.now(); // Запоминаем время попытки разблокировки/выхода

    if (unlocked == true) {
      // Успешно разблокировано
      debugPrint("[HomeScreen] Screen unlocked successfully.");
      _resetInactiveTimer(); // Перезапускаем таймер неактивности ПОСЛЕ успешной разблокировки
    } else {
      // Пользователь вышел ИЛИ закрыл окно иначе
      debugPrint(
        "[HomeScreen] User did not unlock or logged out from LockScreen.",
      );
      // Ничего не делаем, выход уже произошел в LockScreen, GoRouter перенаправит
    }

    // Сбрасываем флаг ПОСЛЕ закрытия и обработки
    setState(() => _isLockScreenVisible = false);
  }
  // ------------------------

  // --- Логика Навигации ---
  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    // _resetInactiveTimer(); // Сброс таймера уже включен в _onPageChanged
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _resetInactiveTimer(); // Сбрасываем таймер и при свайпе
  }
  // ------------------------

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Список страниц для PageView
    final pages = [
      const KeepAliveWrapper(child: SchedulePage()), // 0. Расписание
      const KeepAliveWrapper(child: GradesPage()), // 1. Оценки
      const KeepAliveWrapper(child: AttendancePage()), // 2. Посещаемость
      _userId != null
          ? KeepAliveWrapper(child: ChatsPage(currentUserId: _userId!))
          : const SizedBox.shrink(), // 3. Чаты (или заглушка)
      const KeepAliveWrapper(child: NewsFeedPage()), // 4. Новости
      const KeepAliveWrapper(child: ProfilePage()), // 5. Профиль
    ];

    // Список элементов нижней навигации
    final bottomNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
      BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Оценки'),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_available),
        label: 'Посещаемость',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чаты'),
      BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Новости'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
    ];

    return Listener(
      onPointerDown: _handleUserInteraction, // Сброс таймера при касании
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged, // Вызывает setState и сброс таймера
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: bottomNavItems,
        ),
        drawer: _buildDrawer(context),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.onPrimary,
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Иванов Иван',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'П2Г',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Расписание'),
            onTap: () {
              Navigator.pop(context);
              _pageController.jumpToPage(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.grade_outlined),
            title: const Text('Оценки'),
            onTap: () {
              Navigator.pop(context);
              _pageController.jumpToPage(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Посещаемость'),
            onTap: () {
              Navigator.pop(context);
              _pageController.jumpToPage(2);
            },
          ),
          if (_userId != null)
            ListTile(
              leading: const Icon(Icons.chat_outlined),
              title: const Text('Чаты'),
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(3);
              },
            ),
          ListTile(
            leading: const Icon(Icons.newspaper_outlined),
            title: const Text('Новости'),
            onTap: () {
              Navigator.pop(context);
              _pageController.jumpToPage(4);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Профиль'),
            onTap: () {
              Navigator.pop(context);
              _pageController.jumpToPage(5);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Настройки'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Добавить настройки
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Выйти'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Добавить выход
            },
          ),
        ],
      ),
    );
  }
} // Конец _StudentHomeScreenState
