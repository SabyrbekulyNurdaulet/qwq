import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/schedule_entry.dart';
import '../services/schedule_service.dart';
import '../../../core/auth_service.dart';

final scheduleServiceProvider = Provider((ref) => ScheduleService());

final teacherScheduleProvider =
    StreamProvider.family<List<ScheduleEntry>, String>((ref, teacherId) {
      final scheduleService = ref.watch(scheduleServiceProvider);
      return scheduleService.getTeacherSchedule(teacherId);
    });

final groupScheduleProvider =
    StreamProvider.family<List<ScheduleEntry>, String>((ref, groupId) {
      final scheduleService = ref.watch(scheduleServiceProvider);
      return scheduleService.getScheduleByGroup(groupId);
    });

// Провайдер для сгруппированного расписания по дням недели
final groupedScheduleProvider =
    Provider.family<Map<int, List<ScheduleEntry>>, String>((ref, groupId) {
      final scheduleAsync = ref.watch(groupScheduleProvider(groupId));
      return scheduleAsync.when(
        data: (lessons) {
          final grouped = <int, List<ScheduleEntry>>{};
          for (var lesson in lessons) {
            grouped.putIfAbsent(lesson.dayOfWeek, () => []).add(lesson);
          }
          // Сортируем уроки по времени начала
          for (var dayLessons in grouped.values) {
            dayLessons.sort((a, b) => a.startTime.compareTo(b.startTime));
          }
          return grouped;
        },
        loading: () => {},
        error: (_, __) => {},
      );
    });
