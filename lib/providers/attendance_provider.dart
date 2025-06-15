import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance.dart';

// Тестовые данные для посещаемости
final _mockAttendance = [
  Attendance(
    id: '1',
    subject: 'Программирование',
    teacher: 'Петров П.П.',
    date: DateTime(2024, 3, 15, 9, 0),
    isPresent: true,
    comment: 'Отличная работа на паре',
  ),
  Attendance(
    id: '2',
    subject: 'Программирование',
    teacher: 'Петров П.П.',
    date: DateTime(2024, 3, 15, 10, 30),
    isPresent: false,
    reason: 'Болезнь',
  ),
  Attendance(
    id: '3',
    subject: 'Базы данных',
    teacher: 'Сидорова С.С.',
    date: DateTime(2024, 3, 15, 13, 0),
    isPresent: true,
  ),
  Attendance(
    id: '4',
    subject: 'Веб-разработка',
    teacher: 'Козлов К.К.',
    date: DateTime(2024, 3, 16, 9, 0),
    isPresent: true,
    comment: 'Активное участие в обсуждении',
  ),
  Attendance(
    id: '5',
    subject: 'Английский язык',
    teacher: 'Иванова И.И.',
    date: DateTime(2024, 3, 16, 10, 30),
    isPresent: false,
    reason: 'Семейные обстоятельства',
  ),
];

// Провайдер для получения всех записей посещаемости
final attendanceProvider = FutureProvider<List<Attendance>>((ref) async {
  // В реальном приложении здесь будет запрос к Firestore
  // Сейчас возвращаем тестовые данные
  await Future.delayed(const Duration(seconds: 1)); // Имитация задержки сети
  return _mockAttendance;
});

// Провайдер для получения уникальных предметов
final uniqueSubjectsProvider = Provider<List<String>>((ref) {
  final attendance = ref.watch(attendanceProvider).value ?? [];
  final subjects = attendance.map((a) => a.subject).toSet().toList();
  subjects.sort(); // Сортируем по алфавиту
  return ['Все', ...subjects]; // Добавляем опцию "Все" в начало списка
});

// Провайдер для получения статистики посещаемости
final attendanceStatsProvider = Provider<Map<String, Map<String, int>>>((ref) {
  final attendance = ref.watch(attendanceProvider).value ?? [];
  final stats = <String, Map<String, int>>{};

  for (final record in attendance) {
    if (!stats.containsKey(record.subject)) {
      stats[record.subject] = {'present': 0, 'absent': 0, 'excused': 0};
    }

    if (record.isPresent) {
      stats[record.subject]!['present'] =
          (stats[record.subject]!['present'] ?? 0) + 1;
    } else if (record.reason != null) {
      stats[record.subject]!['excused'] =
          (stats[record.subject]!['excused'] ?? 0) + 1;
    } else {
      stats[record.subject]!['absent'] =
          (stats[record.subject]!['absent'] ?? 0) + 1;
    }
  }

  return stats;
});
