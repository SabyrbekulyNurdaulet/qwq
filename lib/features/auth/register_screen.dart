// lib/features/auth/register_screen.dart (ИСПРАВЛЕННЫЙ И ОБНОВЛЕННЫЙ)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// --- ДОБАВЛЕНО ---: Импорт для работы с Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../routes/app_router.dart'; // Используется для навигации

// Используем ConsumerStatefulWidget для будущего расширения, хотя ref здесь не используется
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController(); // Отчество

  // --- ДОБАВЛЕНО ---: Контроллеры для опциональных полей
  final _iinController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _iinController.dispose(); // --- ДОБАВЛЕНО ---
    _phoneController.dispose(); // --- ДОБАВЛЕНО ---
    super.dispose();
  }

  // --- ИЗМЕНЕНО ---: Полностью переписана логика регистрации
  Future<void> _register() async {
    // 1. Валидация формы
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ШАГ 1: Создание пользователя в Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      final user = userCredential.user;
      if (user == null) {
        // Это маловероятно, но лучше проверить
        throw Exception('Не удалось создать пользователя, user is null.');
      }
      final String uid = user.uid;

      // ШАГ 2: Создание документа пользователя в Firestore со статусом "ожидает подтверждения"

      // Готовим данные для Firestore
      final userData = {
        'uid': uid,
        'email': _emailController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'middleName':
            _middleNameController.text.trim().isNotEmpty
                ? _middleNameController.text.trim()
                : null,
        'iin':
            _iinController.text.trim().isNotEmpty
                ? _iinController.text.trim()
                : null,
        'phone':
            _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
        'role': 'pending_approval', // <-- КЛЮЧЕВОЙ МОМЕНТ
        'status': 'pending_approval', // <-- КЛЮЧЕВОЙ МОМЕНТ
        'photoURL': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Записываем данные в Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);

      // ШАГ 3: Обратная связь пользователю и навигация
      if (mounted) {
        // Показываем диалог об успешной отправке заявки
        await showDialog(
          context: context,
          barrierDismissible: false, // Пользователь должен нажать "ОК"
          builder:
              (context) => AlertDialog(
                title: const Text('Регистрация завершена'),
                content: const Text(
                  'Ваша заявка отправлена на рассмотрение администратору. Вы сможете войти в аккаунт после одобрения.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрыть диалог
                    },
                    child: const Text('ОК'),
                  ),
                ],
              ),
        );

        // Перенаправляем на экран входа
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Регистрация прошла успешно. Ожидайте активации аккаунта администратором.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          AppRouter.go(context, '/login');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _mapFirebaseAuthExceptionMessage(e.code);
        });
      }
    } catch (e) {
      // Обработка других ошибок (например, при записи в Firestore)
      // ВАЖНО: Если здесь произошла ошибка, пользователь уже может быть создан в Auth.
      // В идеале, нужно реализовать механизм отката (удаление пользователя из Auth),
      // но для начала покажем общую ошибку.
      debugPrint('Ошибка при регистрации или записи в Firestore: $e');
      if (mounted) {
        setState(() {
          _errorMessage =
              'Произошла непредвиденная ошибка. Пожалуйста, попробуйте снова.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _mapFirebaseAuthExceptionMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Пароль слишком слабый.';
      case 'email-already-in-use':
        return 'Этот email уже используется.';
      case 'invalid-email':
        return 'Некорректный формат email.';
      default:
        return 'Ошибка регистрации. Попробуйте позже.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Поля для ФИО ---
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Фамилия'),
                  textCapitalization: TextCapitalization.words,
                  validator:
                      (value) =>
                          (value?.trim().isEmpty ?? true)
                              ? 'Пожалуйста, введите фамилию'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                  textCapitalization: TextCapitalization.words,
                  validator:
                      (value) =>
                          (value?.trim().isEmpty ?? true)
                              ? 'Пожалуйста, введите имя'
                              : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Отчество (если есть)',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // --- ДОБАВЛЕНО: Поля для ИИН и Телефона (опциональные) ---
                TextFormField(
                  controller: _iinController,
                  decoration: const InputDecoration(
                    labelText: 'ИИН (если есть)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Телефон (если есть)',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // --- Поля для Email и Пароля ---
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Пароль'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Подтвердите пароль',
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Пароли не совпадают';
                    }
                    return null;
                  },
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child:
                      _isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text('Отправить заявку'), // --- ИЗМЕНЕНО ---
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed:
                      _isLoading ? null : () => AppRouter.go(context, '/login'),
                  child: const Text('Уже есть аккаунт? Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
