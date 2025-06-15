// lib/features/settings/pin/pin_setup_screen.dart
import 'dart:convert'; // Для utf8
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart'; // Для SHA256
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // Для context.pop()

class PinSetupScreen extends StatefulWidget {
  // Убрали const, т.к. StatefulWidget не должен быть const по умолчанию
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  final int _pinLength = 4; // Можно вынести в константы приложения

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  // Функция хеширования ПИН-кода (ВАЖНО: должна быть одинаковой во всех файлах, где используется)
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Функция сохранения ПИН-кода
  Future<void> _savePin() async {
    // Проверяем валидность формы
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final pin = _pinController.text;
    final hashedPin = _hashPin(pin); // Хешируем

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ошибка: Пользователь не аутентифицирован."),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Ключи для хранения, специфичные для пользователя
    final pinHashKey = 'pin_hash_$userId';
    final pinEnabledKey = 'pin_enabled_$userId';

    try {
      // Сохраняем хеш и флаг включения
      await _storage.write(key: pinHashKey, value: hashedPin);
      await _storage.write(key: pinEnabledKey, value: 'true');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ПИН-код успешно установлен!'),
            backgroundColor: Colors.green,
          ),
        );
        // Используем GoRouter для закрытия экрана
        context.pop();
      }
    } catch (e) {
      debugPrint("Error saving PIN: $e");
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Не удалось сохранить ПИН-код: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Убедимся, что индикатор сброшен, если виджет еще существует
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI взят из твоего старого файла, стили должны примениться из темы
    return Scaffold(
      appBar: AppBar(title: const Text("Установка ПИН-кода")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Придумайте $_pinLength-значный ПИН-код",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _pinController,
                  decoration: const InputDecoration(
                    labelText: "ПИН-код",
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: _pinLength,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 10),
                  validator: (value) {
                    if (value == null || value.length != _pinLength) {
                      return 'ПИН должен состоять из $_pinLength цифр';
                    }
                    // Можно добавить проверку, что это только цифры, хотя keyboardType помогает
                    if (int.tryParse(value) == null) {
                      return 'Используйте только цифры';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPinController,
                  decoration: const InputDecoration(
                    labelText: "Подтвердите ПИН-код",
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: _pinLength,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 10),
                  validator: (value) {
                    if (value == null || value.length != _pinLength) {
                      return 'Введите подтверждение ПИН-кода';
                    }
                    if (value != _pinController.text) {
                      return 'ПИН-коды не совпадают';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                // Кнопка сохранения или индикатор
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _savePin,
                    child: const Text("СОХРАНИТЬ ПИН-КОД"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
