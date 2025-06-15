import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/schedule_entry.dart';
import '../../../services/schedule_service.dart';

// Провайдер для получения расписания учителя
final teacherScheduleProvider = FutureProvider.family<
  List<ScheduleEntry>,
  String
>((ref, teacherId) async {
  print(
    'DEBUG: teacherScheduleProvider: Getting schedule for teacher $teacherId',
  );
  final scheduleService = ScheduleService();
  final scheduleStream = scheduleService.getTeacherSchedule(teacherId);

  // Преобразуем Stream в Future
  final lessons = await scheduleStream.first;
  print('DEBUG: teacherScheduleProvider: Received ${lessons.length} lessons');

  // Дедупликация на основе уникального ключа
  final uniqueLessons = <String, ScheduleEntry>{};
  for (final lesson in lessons) {
    // Создаем уникальный ключ из всех важных параметров урока
    final key =
        '${lesson.dayOfWeek}_${lesson.startTime}_${lesson.endTime}_${lesson.subjectId}_${lesson.groupId}_${lesson.teacherId}';
    uniqueLessons[key] = lesson;
  }

  final deduplicatedLessons = uniqueLessons.values.toList();
  print(
    'DEBUG: teacherScheduleProvider: After deduplication: ${deduplicatedLessons.length} lessons',
  );

  // Сортируем по дню недели и времени
  deduplicatedLessons.sort((a, b) {
    final dayComparison = a.dayOfWeek.compareTo(b.dayOfWeek);
    if (dayComparison != 0) return dayComparison;
    return a.startTime.compareTo(b.startTime);
  });

  return deduplicatedLessons;
});

// Провайдер для получения дней недели с уроками
final teacherScheduleDaysProvider = Provider.family<List<int>, String>((
  ref,
  teacherId,
) {
  final scheduleAsync = ref.watch(teacherScheduleProvider(teacherId));

  return scheduleAsync.when(
    loading: () => [],
    error: (_, __) => [],
    data: (lessons) {
      final days = lessons.map((l) => l.dayOfWeek).toSet().toList();
      days.sort();
      print('DEBUG: teacherScheduleDaysProvider: Available days: $days');
      return days;
    },
  );
});
