// lib/core/providers/theme_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themePrefsKey = 'appThemeMode';

// Используем AsyncNotifierProvider для управления асинхронным состоянием ThemeMode
final themeNotifierProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  () {
    return ThemeNotifier();
  },
);

// Наш AsyncNotifier
class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  late SharedPreferences _prefs; // SharedPreferences будут загружены в build

  // Метод build вызывается один раз для инициализации состояния
  @override
  FutureOr<ThemeMode> build() async {
    // Асинхронно загружаем SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    // Загружаем сохраненную тему или возвращаем системную по умолчанию
    final savedThemeIndex = _prefs.getInt(_themePrefsKey);
    ThemeMode initialMode;
    if (savedThemeIndex != null && savedThemeIndex < ThemeMode.values.length) {
      initialMode = ThemeMode.values[savedThemeIndex];
    } else {
      initialMode = ThemeMode.system;
    }
    debugPrint("[ThemeNotifier] Initialized with theme: $initialMode");
    return initialMode;
  }

  // Метод для установки и сохранения новой темы
  Future<void> setThemeMode(ThemeMode mode) async {
    // Проверяем, отличается ли новая тема от текущей УСПЕШНО ЗАГРУЖЕННОЙ
    if (state.valueOrNull == mode) return;

    // Оптимистично обновляем состояние на новое значение
    state = AsyncData(mode);
    debugPrint("[ThemeNotifier] Setting theme: $mode");

    // Пытаемся сохранить в SharedPreferences
    try {
      await _prefs.setInt(_themePrefsKey, mode.index);
    } catch (e) {
      // Если сохранить не удалось, можно откатить состояние или показать ошибку
      debugPrint("Error saving theme: $e");
      // state = AsyncError(e, StackTrace.current); // Пример отката состояния
    }
  }

  // --- Вспомогательные методы для определения текущей темы ---
  // (Лучше вызывать их там, где есть BuildContext, передавая текущее состояние)
  // Этот метод теперь менее полезен внутри Notifier, лучше использовать в UI:
  // Brightness getCurrentBrightness(BuildContext context) { ... }
  // bool isDarkMode(BuildContext context) => ... ;
}

// Убираем отдельный sharedPreferencesProvider, т.к. он теперь загружается внутри AsyncNotifier

// --- Вспомогательная функция для использования в UI (например, в SettingsScreen) ---
// Помогает получить текущее значение ThemeMode или дефолтное, если идет загрузка/ошибка
extension ThemeModeValue on AsyncValue<ThemeMode> {
  ThemeMode get valueOrSystem => maybeWhen(
    data: (mode) => mode,
    orElse: () => ThemeMode.system, // Возвращаем system по умолчанию
  );
}
