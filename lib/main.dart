// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'core/providers/theme_provider.dart'; // Наш провайдер темы
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// --- Константы для удобства ---
const _seedColor = Colors.indigo; // Основной цвет для генерации схемы
const _borderRadiusValue = 12.0; // Общий радиус скругления
const _buttonBorderRadiusValue = 8.0; // Радиус для кнопок
const _inputBorderRadiusValue = 8.0; // Радиус для полей ввода

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Инициализируем форматирование дат для русского языка
  await initializeDateFormatting('ru_RU', null);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeModeAsync = ref.watch(themeNotifierProvider);
    final currentThemeMode = themeModeAsync.valueOrSystem;

    // --- Генерируем Цветовую Схему ---
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
      // Можно немного подстроить темную схему, если стандартная не нравится
      // primary: Colors.indigoAccent[100], // Пример: сделать основной цвет светлее
    );

    // --- Определяем общие настройки BorderRadius ---
    final commonBorderRadius = BorderRadius.circular(_borderRadiusValue);
    final buttonBorderRadius = BorderRadius.circular(_buttonBorderRadiusValue);
    final inputBorderRadius = BorderRadius.circular(_inputBorderRadiusValue);

    // --- Базовая настройка ThemeData (общая для light/dark) ---
    ThemeData configureBaseTheme(ColorScheme colorScheme) {
      return ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,

        // Можно подключить кастомный шрифт через google_fonts
        // fontFamily: GoogleFonts.inter().fontFamily,

        // --- Настройки компонентов ---
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface, // Фон AppBar - цвет поверхности
          foregroundColor: colorScheme.onSurface, // Цвет текста и иконок
          elevation: 0, // Без тени для "плоского" дизайна
          scrolledUnderElevation: 2, // Небольшая тень при скролле под AppBar
          centerTitle: true,
          titleTextStyle: TextStyle(
            // Стиль заголовка
            fontSize: 18,
            fontWeight: FontWeight.w600, // Полужирный
            color: colorScheme.onSurface,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true, // Добавляем фон полю ввода
          fillColor: colorScheme.surfaceContainerHighest, // Цвет фона поля
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14.0,
            horizontal: 16.0,
          ), // Паддинги
          border: OutlineInputBorder(
            // Стандартная рамка
            borderRadius: inputBorderRadius,
            borderSide: BorderSide.none, // Без видимой рамки по умолчанию
          ),
          enabledBorder: OutlineInputBorder(
            // Рамка в неактивном состоянии
            borderRadius: inputBorderRadius,
            borderSide: BorderSide(
              color: colorScheme.outlineVariant.withAlpha(128),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            // Рамка в фокусе
            borderRadius: inputBorderRadius,
            borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            // Рамка при ошибке
            borderRadius: inputBorderRadius,
            borderSide: BorderSide(color: colorScheme.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Рамка при ошибке в фокусе
            borderRadius: inputBorderRadius,
            borderSide: BorderSide(color: colorScheme.error, width: 2.0),
          ),
          labelStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ), // Стиль метки
          prefixIconColor: colorScheme.onSurfaceVariant, // Цвет иконки слева
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary, // Основной цвет фона
            foregroundColor:
                colorScheme.onPrimary, // Цвет текста/иконок на кнопке
            elevation: 2, // Небольшая тень
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 24.0,
            ),
            shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary, // Цвет текста
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: buttonBorderRadius),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        cardTheme: ThemeData().cardTheme.copyWith(
          elevation: 0,
          color: colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: commonBorderRadius,
            side: BorderSide(
              color: colorScheme.outlineVariant.withAlpha(153),
              width: 0.8,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6.0),
        ),

        listTileTheme: ListTileThemeData(
          iconColor: colorScheme.primary, // Цвет иконок (leading)
          tileColor: Colors.transparent, // Прозрачный фон по умолчанию
          shape: RoundedRectangleBorder(
            borderRadius: commonBorderRadius,
          ), // Скругление (для InkWell)
          dense: false, // Не слишком компактно
          minVerticalPadding: 14, // Увеличим вертикальный отступ
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          // Фон берется из Scaffold, можно задать явно:
          // backgroundColor: colorScheme.surfaceContainer,
          selectedItemColor: colorScheme.primary, // Активный элемент
          unselectedItemColor:
              colorScheme.onSurfaceVariant, // Неактивный элемент
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels:
              false, // Скрываем текст у неактивных для чистоты
          elevation: 0, // Убираем тень
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ), // Стиль активного текста
        ),

        chipTheme: ChipThemeData(
          backgroundColor: colorScheme.secondaryContainer.withAlpha(
            204,
          ), // Фон чипа
          labelStyle: TextStyle(
            color: colorScheme.onSecondaryContainer,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          iconTheme: IconThemeData(
            color: colorScheme.onSecondaryContainer,
            size: 14,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none, // Без рамки
        ),

        dividerTheme: DividerThemeData(
          color: colorScheme.outlineVariant.withAlpha(153), // Цвет разделителя
          thickness: 1,
          space: 1, // Минимальное пространство (управляется в ListTile)
        ),

        dialogTheme: ThemeData().dialogTheme.copyWith(
          backgroundColor: colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(borderRadius: commonBorderRadius),
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          contentTextStyle: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),

        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating, // Всплывающий SnackBar
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // Можно задать цвета по умолчанию для разных типов SnackBar
          // backgroundColor: ...,
          // actionTextColor: ...,
        ),
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: colorScheme.inverseSurface.withAlpha(229),
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: TextStyle(color: colorScheme.inversePrimary),
        ),
      );
    }

    // --- Создаем светлую и темную темы ---
    final lightTheme = configureBaseTheme(lightColorScheme);
    final darkTheme = configureBaseTheme(darkColorScheme);

    // --- Собираем MaterialApp ---
    return MaterialApp.router(
      routerConfig: router,
      title: 'myCollege App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: currentThemeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ru', 'RU'), Locale('en', 'US')],
      debugShowCheckedModeBanner: false,
    );
  }
}
