// lib/features/settings/pin/change_pin_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart'; // Для навигации

// Не импортируем PinSetupScreen напрямую, используем роутинг

class ChangePinScreen extends StatefulWidget {
  // Убрали const
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPinController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  bool _isLoading = false;
  String? _errorMessage;
  final int _pinLength = 4; // Должно совпадать

  @override
  void dispose() {
    _currentPinController.dispose();
    super.dispose();
  }

  // Функция хеширования (идентична PinSetupScreen)
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Функция проверки текущего ПИН и перехода к установке нового
  Future<void> _verifyCurrentPin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Ошибка: Пользователь не найден.";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!), backgroundColor: Colors.red),
        );
      }
      return;
    }

    final storedPinHashKey = 'pin_hash_$userId';

    try {
      final storedPinHash = await _storage.read(key: storedPinHashKey);

      if (storedPinHash == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Ошибка: ПИН-код не найден.";
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final enteredPinHash = _hashPin(_currentPinController.text);

      if (enteredPinHash == storedPinHash) {
        // Успех! Переходим на экран установки нового ПИН-кода, ЗАМЕНЯЯ текущий экран
        if (mounted) {
          // Используем pushReplacementNamed из GoRouter для замены
          context.pushReplacement(
            '/settings/pin/setup',
          ); // Заменит /settings/pin/change на /settings/pin/setup
        }
      } else {
        // Неверный ПИН
        setState(() {
          _isLoading = false;
          _errorMessage = "Неверный текущий ПИН-код.";
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage!),
              backgroundColor: Colors.orange,
            ),
          );
        }
        // TODO: Добавить счетчик попыток и блокировку?
      }
    } catch (e) {
      debugPrint("Error verifying PIN: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Ошибка проверки ПИН-кода.";
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$_errorMessage\n$e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted && _isLoading) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI взят из старого файла
    return Scaffold(
      appBar: AppBar(title: const Text("Смена ПИН-кода")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.password_outlined, size: 60),
                const SizedBox(height: 20),
                Text(
                  "Введите текущий ПИН-код",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _currentPinController,
                  decoration: const InputDecoration(
                    labelText: "Текущий ПИН-код",
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
                    if (int.tryParse(value) == null) {
                      return 'Используйте только цифры';
                    }
                    return null;
                  },
                ),
                if (_errorMessage != null) // Отображение ошибки
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
                const SizedBox(height: 40),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _verifyCurrentPin,
                    child: const Text("ПОДТВЕРДИТЬ"),
                  ),
                // Можно добавить кнопку "Забыли ПИН?"
              ],
            ),
          ),
        ),
      ),
    );
  }
}
