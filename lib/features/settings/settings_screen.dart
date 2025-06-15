// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide User; // Скрываем User из auth
// import 'package:go_router/go_router.dart'; // Если будешь использовать context.push

import '../../core/providers/theme_provider.dart';
import '../../routes/app_router.dart'; // Для навигации

// --- Виджет настроек ---
// Делаем ConsumerStatefulWidget для локального состояния и доступа к ref
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Используем зависимости из pubspec.yaml
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  // Получаем ID пользователя (лучше из authStateProvider, но FirebaseAuth тоже можно)
  final _userId = FirebaseAuth.instance.currentUser?.uid;

  // Локальное состояние для настроек безопасности
  bool _pinEnabled = false;
  bool _biometricsAvailable = false;
  bool _biometricsEnabled = false;
  bool _isLoadingSettings = true; // Флаг загрузки начальных настроек
  bool _isTogglingBiometrics = false; // Флаг при переключении биометрии

  @override
  void initState() {
    super.initState();
    // Загружаем настройки при инициализации
    _loadSettings();
  }

  // Асинхронная загрузка настроек ПИН/Био
  Future<void> _loadSettings() async {
    setState(() => _isLoadingSettings = true); // Начинаем загрузку
    if (_userId == null) {
      if (mounted) setState(() => _isLoadingSettings = false);
      return; // Выход, если нет пользователя
    }
    try {
      final pinKey = 'pin_enabled_$_userId';
      final bioKey = 'bio_enabled_$_userId';

      // Читаем состояние ПИН и Био
      final pin = await _storage.read(key: pinKey) == 'true';
      final bio = await _storage.read(key: bioKey) == 'true';

      // Проверяем доступность биометрии
      bool canCheckBio = false;
      List<BiometricType> availableBiometrics = [];
      try {
        canCheckBio =
            await _localAuth.canCheckBiometrics ||
            await _localAuth.isDeviceSupported();
        if (canCheckBio) {
          availableBiometrics = await _localAuth.getAvailableBiometrics();
        }
      } catch (e) {
        debugPrint("Error checking biometrics availability: $e");
        canCheckBio = false;
      }

      // Обновляем состояние виджета
      if (mounted) {
        setState(() {
          _pinEnabled = pin;
          _biometricsEnabled = bio;
          _biometricsAvailable =
              canCheckBio &&
              availableBiometrics
                  .isNotEmpty; // Доступна, если можно проверить И есть типы
          _isLoadingSettings = false; // Загрузка завершена
        });
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
      if (mounted) {
        setState(() => _isLoadingSettings = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка загрузки настроек безопасности: $e')),
        );
      }
    }
  }

  // --- Логика переключения биометрии ---
  Future<void> _toggleBiometrics(bool enable) async {
    if (_userId == null || !_biometricsAvailable || _isTogglingBiometrics) {
      return;
    }

    setState(() => _isTogglingBiometrics = true); // Блокируем повторное нажатие

    final bioKey = 'bio_enabled_$_userId';

    if (enable) {
      // Пытаемся аутентифицироваться для подтверждения включения
      try {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Включить вход по биометрии',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
        if (didAuthenticate && mounted) {
          await _storage.write(key: bioKey, value: 'true');
          setState(() => _biometricsEnabled = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вход по биометрии включен'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (mounted) {
          // Пользователь отменил или аутентификация не удалась
          // Switch останется в выключенном состоянии, т.к. setState не вызван для _biometricsEnabled = true
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Включение биометрии отменено'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        debugPrint("Auth error on enabling biometrics: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка биометрии: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Просто отключаем (удаляем ключ)
      await _storage.delete(key: bioKey);
      setState(() => _biometricsEnabled = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вход по биометрии отключен')),
        );
      }
    }
    if (mounted) {
      setState(() => _isTogglingBiometrics = false); // Разблокируем
    }
  }
  // ------------------------------------

  // --- Логика удаления ПИН-кода ---
  Future<void> _removePin() async {
    if (_userId == null) return;
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(/* ... Диалог подтверждения удаления ПИН ... */),
    );

    if (confirmed == true && mounted) {
      final pinHashKey = 'pin_hash_$_userId';
      final pinEnabledKey = 'pin_enabled_$_userId';
      try {
        await _storage.delete(key: pinHashKey);
        await _storage.delete(key: pinEnabledKey);
        // Также отключаем биометрию, т.к. она обычно требует ПИН как запасной вариант
        await _toggleBiometrics(false);
        setState(() => _pinEnabled = false); // Обновляем локальное состояние
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ПИН-код удален'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        debugPrint("Error removing PIN: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось удалить ПИН-код: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // -----------------------------

  @override
  Widget build(BuildContext context) {
    final themeModeAsync = ref.watch(themeNotifierProvider);

    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    final currentThemeMode = themeModeAsync.valueOrSystem;

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          // --- Секция Темы (без изменений) ---
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(
              "Оформление",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Как в системе'),
            value: ThemeMode.system,
            groupValue: currentThemeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Только светлая'),
            value: ThemeMode.light,
            groupValue: currentThemeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Только темная'),
            value: ThemeMode.dark,
            groupValue: currentThemeMode,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                themeNotifier.setThemeMode(value);
              }
            },
          ),
          const Divider(height: 20),

          // --- Секция Безопасности ---
          ListTile(
            leading: const Icon(Icons.security_outlined),
            title: Text(
              "Безопасность",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          // Показываем загрузку настроек
          if (_isLoadingSettings)
            const ListTile(
              leading: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              title: Text('Загрузка настроек...'),
            )
          // Показываем опции ПИН/Био, если загрузка завершена
          else ...[
            // Управление ПИН-кодом
            ListTile(
              title: const Text('ПИН-код'),
              subtitle: Text(_pinEnabled ? 'Установлен' : 'Не установлен'),
              trailing: Icon(
                _pinEnabled ? Icons.lock_outline : Icons.lock_open_outlined,
              ),
              onTap: () {
                if (_pinEnabled) {
                  // Переход на экран смены ПИН
                  // TODO: Определить роут '/settings/pin/change'
                  AppRouter.push(context, '/settings/pin/change');
                } else {
                  // Переход на экран установки ПИН
                  // TODO: Определить роут '/settings/pin/setup'
                  AppRouter.push(context, '/settings/pin/setup').then(
                    (_) => _loadSettings(),
                  ); // Обновляем состояние после возврата
                }
              },
            ),
            // Кнопка удаления ПИН (если он установлен)
            if (_pinEnabled)
              ListTile(
                title: Text(
                  'Удалить ПИН-код',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                onTap: _removePin, // Вызываем удаление
              ),

            // Управление Биометрией
            // Показываем только если биометрия доступна на устройстве
            if (_biometricsAvailable)
              SwitchListTile(
                secondary: Icon(
                  Icons.fingerprint,
                  // Иконка серая, если ПИН не включен (т.к. биометрия без ПИН обычно не работает)
                  color:
                      _pinEnabled
                          ? Theme.of(context).iconTheme.color
                          : Colors.grey,
                ),
                title: const Text('Вход по биометрии'),
                value: _biometricsEnabled,
                // Выключаем переключатель, если ПИН не установлен или идет переключение
                onChanged:
                    (_pinEnabled && !_isTogglingBiometrics)
                        ? (value) => _toggleBiometrics(value)
                        : null,
                // Показываем подсказку, если ПИН не включен
                subtitle:
                    !_pinEnabled
                        ? const Text('Сначала установите ПИН-код')
                        : null,
              )
            // Если биометрия недоступна
            else
              const ListTile(
                leading: Icon(Icons.fingerprint, color: Colors.grey),
                title: Text('Вход по биометрии'),
                subtitle: Text('Биометрия недоступна на этом устройстве'),
              ),
          ], // Конец секции безопасности
          // ------------------------------------------
          const Divider(height: 20),
          // --- Другие настройки ---
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            onTap: () {
              // Показываем стандартный диалог "О приложении"
              showAboutDialog(
                context: context,
                applicationName: 'myCollege App', // Название из main.dart
                applicationVersion: '1.0.0', // Версия из pubspec.yaml
                applicationLegalese:
                    '© 2025 4Agroup/MyCollege', // Авторские права
                // applicationIcon: Image.asset('assets/icons/app_icon.png', width: 40), // Иконка приложения
                children: [
                  // Дополнительная информация
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Студенческий портал.'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
