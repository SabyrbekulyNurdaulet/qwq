// lib/features/student/providers/schedule_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Наши модели
import '../../../models/schedule_entry.dart';
import '../../../models/semester.dart';
import '../../../core/auth_service.dart';
import '../../../services/schedule_service.dart';
import '../../../services/semester_service.dart';

final scheduleServiceProvider = Provider((ref) => ScheduleService());
final semesterServiceProvider = Provider((ref) => SemesterService());

// Провайдер для текущего семестра
final currentSemesterProvider = StreamProvider<Semester?>((ref) {
  return ref.watch(semesterServiceProvider).getCurrentSemester();
});

// Провайдер для выбранного семестра
final selectedSemesterProvider = StateProvider<Semester?>((ref) {
  // По умолчанию используем текущий активный семестр
  final currentSemester = ref.watch(currentSemesterProvider).valueOrNull;
  print('DEBUG: Selected semester: ${currentSemester?.name}');
  return currentSemester;
});

// Провайдер для стрима расписания текущего пользователя
final scheduleProvider = StreamProvider.autoDispose<List<ScheduleEntry>>((ref) {
  final authState = ref.watch(authStateProvider);
  final user = authState.valueOrNull;
  final scheduleService = ref.watch(scheduleServiceProvider);
  final selectedSemester = ref.watch(selectedSemesterProvider);

  print('DEBUG: ScheduleProvider: Auth state: ${authState.valueOrNull?.email}');
  print(
    'DEBUG: ScheduleProvider: Selected semester: ${selectedSemester?.name}',
  );

  if (user == null || user.groupId == null) {
    print('DEBUG: ScheduleProvider: No user or groupId found');
    return Stream.value([]);
  }

  if (selectedSemester == null) {
    print('DEBUG: ScheduleProvider: No semester selected');
    return Stream.value([]);
  }

  print(
    'DEBUG: ScheduleProvider: Fetching schedule for groupId: ${user.groupId} and semester: ${selectedSemester.name}',
  );
  return scheduleService.getScheduleByGroupAndSemester(
    user.groupId!,
    selectedSemester,
  );
});

// Провайдер для группировки расписания по дням недели
final groupedScheduleProvider = Provider.autoDispose<
  Map<int, List<ScheduleEntry>>
>((ref) {
  final asyncSchedule = ref.watch(scheduleProvider);
  print(
    'DEBUG: GroupedScheduleProvider: Schedule state: ${asyncSchedule.valueOrNull?.length} entries',
  );

  return asyncSchedule.when(
    data: (lessons) {
      print(
        'DEBUG: GroupedScheduleProvider: Processing ${lessons.length} lessons',
      );
      final grouped = <int, List<ScheduleEntry>>{};
      for (var i = 1; i <= 6; i++) {
        grouped[i] = [];
      }
      for (final lesson in lessons) {
        grouped[lesson.dayOfWeek]?.add(lesson);
      }
      print(
        'DEBUG: GroupedScheduleProvider: Grouped lessons: ${grouped.map((k, v) => MapEntry(k, v.length))}',
      );
      return grouped;
    },
    loading: () {
      print('DEBUG: GroupedScheduleProvider: Loading state');
      return {};
    },
    error: (error, stack) {
      print('DEBUG: GroupedScheduleProvider: Error state: $error');
      return {};
    },
  );
});
