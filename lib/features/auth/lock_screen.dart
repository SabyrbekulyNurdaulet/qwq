// lib/features/auth/lock_screen.dart
import 'dart:async';
import 'dart:convert'; // Для utf8
import 'dart:math'; // Для Random в анимации
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart'; // Для sha256
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Для HapticFeedback
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart'; // Для context.pop()
// Импортируем сервис аутентификации для выхода
import '../../core/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Для доступа к сервису через Consumer

// Используем ConsumerStatefulWidget для доступа к ref (для logout)
class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  final _userId =
      FirebaseAuth
          .instance
          .currentUser
          ?.uid; // Получаем ID текущего пользователя

  String _enteredPin = "";
  String? _errorMessage;
  bool _checkingPin = false;
  bool _canUseBiometrics = false;
  bool _isBioEnabledForUser = false; // Включена ли биометрия в настройках

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  final int _pinLength = 4;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1)
      .chain(CurveTween(curve: Curves.elasticIn))
      .animate(_shakeController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) _shakeController.reset();
    });
    _initialize(); // Загружаем настройки биометрии
  }

  // Загрузка настроек биометрии
  Future<void> _initialize() async {
    bool canCheck = false;
    bool bioEnabled = false;
    List<BiometricType> availableBiometrics = [];

    try {
      canCheck =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
      if (canCheck) {
        availableBiometrics = await _localAuth.getAvailableBiometrics();
      }
      if (canCheck && _userId != null) {
        bioEnabled = await _storage.read(key: 'bio_enabled_$_userId') == 'true';
      }
    } catch (e) {
      debugPrint("Error checking biometrics availability on lock screen: $e");
      canCheck = false;
    }
    if (mounted) {
      setState(() {
        _canUseBiometrics = canCheck && availableBiometrics.isNotEmpty;
        _isBioEnabledForUser = bioEnabled;
      });
      // Сразу пытаемся вызвать биометрию, если она включена
      if (_isBioEnabledForUser && _canUseBiometrics) {
        _authenticateWithBiometrics();
      }
    }
  }

  // Хеширование (идентично другим экранам)
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Аутентификация по биометрии
  Future<void> _authenticateWithBiometrics() async {
    if (!_canUseBiometrics || !_isBioEnabledForUser) return;
    try {
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Войдите для доступа к приложению',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      // Если успешно, закрываем LockScreen и возвращаем true
      if (didAuthenticate && mounted) context.pop(true);
    } on PlatformException catch (e) {
      // Ловим ошибки платформы (например, пользователь отменил)
      debugPrint(
        "Biometric Auth Error (PlatformException): ${e.code} - ${e.message}",
      );
      if (mounted) {
        // Не показываем ошибку, если пользователь сам отменил
        if (e.code != 'auth_in_progress' &&
            e.code != 'user_cancel' &&
            e.code != 'passcode_not_set' /* и другие коды отмены */ ) {
          setState(
            () =>
                _errorMessage =
                    'Ошибка биометрии (${e.code}). Попробуйте ПИН-код.',
          );
        }
      }
    } catch (e) {
      debugPrint("Biometric Auth Error (Other): $e");
      if (mounted) {
        setState(() => _errorMessage = 'Ошибка биометрии. Попробуйте ПИН-код.');
      }
    }
  }

  // Проверка ПИН-кода
  Future<void> _verifyPin() async {
    if (_enteredPin.length != _pinLength || _userId == null) return;
    setState(() {
      _checkingPin = true;
      _errorMessage = null;
    });

    final storedPinHash = await _storage.read(key: 'pin_hash_$_userId');
    final enteredPinHash = _hashPin(_enteredPin);

    await Future.delayed(
      const Duration(milliseconds: 150),
    ); // Имитация проверки

    if (enteredPinHash == storedPinHash) {
      // Успех! Закрываем экран и возвращаем true
      if (mounted) context.pop(true);
    } else {
      // Неверный ПИН
      _shakeController.forward(from: 0); // Запускаем анимацию тряски
      HapticFeedback.vibrate(); // Вибрация
      if (mounted) {
        setState(() {
          _errorMessage = "Неверный ПИН-код";
          _checkingPin = false;
          _enteredPin = ""; // Очищаем введенный ПИН
        });
        // TODO: Добавить счетчик попыток и возможно блокировку
      }
    }
  }

  // Нажатие на цифру
  void _onNumpadTap(String digit) {
    if (_checkingPin || _enteredPin.length >= _pinLength) return;
    setState(() {
      _errorMessage = null;
      _enteredPin += digit;
      if (_enteredPin.length == _pinLength) {
        _verifyPin(); // Проверяем сразу после ввода последней цифры
      }
    });
  }

  // Нажатие Backspace
  void _onBackspaceTap() {
    if (_checkingPin || _enteredPin.isEmpty) return;
    setState(() {
      _errorMessage = null;
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
    });
  }

  // Выход из аккаунта
  Future<void> _logout() async {
    // Используем ref для доступа к сервису
    await ref.read(authServiceProvider).signOut();
    // Закрываем LockScreen и возвращаем false (сигнал, что пользователь вышел)
    if (mounted) context.pop(false);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // --- UI Виджеты (взяты из старого кода с небольшими адаптациями) ---
  Widget _buildPinDots() {
    /* ... код виджета точек ... */
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder:
          (context, child) => Transform.translate(
            offset: Offset(_shakeAnimation.value * 15, 0),
            child: child,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_pinLength, (index) {
          bool isActive = index < _enteredPin.length;
          // Используем Animate для появления/исчезновения заливки
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
              border: Border.all(
                color:
                    isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withAlpha(100),
                width: 1.5,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNumpad() {
    /* ... код цифровой клавиатуры ... */
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(18), // Немного уменьшим паддинг
      textStyle: Theme.of(context).textTheme.headlineSmall, // Чуть меньше шрифт
    );
    final emptyButton = const SizedBox(width: 72, height: 72);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 5, // Уменьшим отступы
      crossAxisSpacing: 5,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ), // Добавим боковые отступы для Grid
      children: [
        ...List.generate(9, (index) {
          final digit = '${index + 1}';
          return TextButton(
            style: buttonStyle,
            onPressed: () => _onNumpadTap(digit),
            child: Text(digit),
          ).animate().fadeIn(
            delay: (Random().nextDouble() * 80).ms,
          ); // Уменьшим задержку анимации
        }),
        // Кнопка биометрии или пустое место
        (_canUseBiometrics && _isBioEnabledForUser)
            ? IconButton(
              icon: const Icon(Icons.fingerprint),
              iconSize: 30,
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              tooltip: "Использовать биометрию",
              onPressed:
                  _checkingPin
                      ? null
                      : _authenticateWithBiometrics, // Блокируем во время проверки
            ).animate().fadeIn(delay: (Random().nextDouble() * 80).ms)
            : emptyButton,
        // Кнопка 0
        TextButton(
          style: buttonStyle,
          onPressed: () => _onNumpadTap('0'),
          child: const Text('0'),
        ).animate().fadeIn(delay: (Random().nextDouble() * 80).ms),
        // Кнопка Backspace
        IconButton(
          style: IconButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          icon: const Icon(Icons.backspace_outlined),
          iconSize: 28,
          tooltip: "Стереть",
          onPressed: _onBackspaceTap,
        ).animate().fadeIn(delay: (Random().nextDouble() * 80).ms),
      ],
    );
  }
  // ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Используем PopScope для предотвращения случайного закрытия кнопкой "назад"
    return PopScope(
      canPop: false, // Нельзя уйти системной кнопкой "назад"
      onPopInvoked: (didPop) {
        if (didPop) return; // Если система все же смогла закрыть (маловероятно)
        // Можно показать диалог или просто игнорировать
        debugPrint("Attempted to pop LockScreen with system back gesture.");
      },
      child: Scaffold(
        // Можно добавить AppBar или оставить чистым
        // appBar: AppBar(title: Text("Разблокировка"), automaticallyImplyLeading: false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Верхняя часть
                Column(
                  children: [
                    const SizedBox(height: 40), // Добавим отступ сверху
                    Icon(
                      Icons.lock_person_outlined,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Введите ПИН-код',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 30),
                    _buildPinDots(), // Точки для ПИН
                    SizedBox(
                      height: 20,
                      child: // Займем место под ошибку
                          _errorMessage != null
                              ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : null,
                    ),
                  ],
                ),

                // Нижняя часть
                Column(
                  children: [
                    _buildNumpad(), // Клавиатура
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: _logout, // Вызываем наш метод выхода
                      child: Text(
                        "Выйти из аккаунта",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
