import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_entry.dart';
import '../models/user.dart' as app;
import '../services/schedule_service.dart';
import 'user_profile_provider.dart';

final scheduleServiceProvider = Provider((ref) => ScheduleService());

// Провайдер для получения расписания студента
final studentScheduleProvider = StreamProvider<List<ScheduleEntry>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final scheduleService = ref.watch(scheduleServiceProvider);

  return userProfile.when(
    data: (user) {
      if (user == null || user.groupId == null) {
        print('DEBUG: No user or groupId found');
        return Stream.value([]);
      }

      print('DEBUG: Fetching schedule for groupId: ${user.groupId}');
      return scheduleService.getScheduleByGroup(user.groupId!);
    },
    loading: () {
      print('DEBUG: User profile is loading');
      return Stream.value([]);
    },
    error: (error, stack) {
      print('DEBUG: Error loading user profile: $error');
      return Stream.value([]);
    },
  );
});

// Провайдер для получения расписания преподавателя
final teacherScheduleProvider = StreamProvider<List<ScheduleEntry>>((ref) {
  final userProfile = ref.watch(userProfileProvider);
  final scheduleService = ref.watch(scheduleServiceProvider);

  return userProfile.when(
    data: (user) {
      if (user == null || user.role != 'teacher') {
        print('DEBUG: No user or not a teacher');
        return Stream.value([]);
      }

      print('DEBUG: Fetching schedule for teacherId: ${user.uid}');
      return scheduleService.getTeacherSchedule(user.uid);
    },
    loading: () {
      print('DEBUG: User profile is loading');
      return Stream.value([]);
    },
    error: (error, stack) {
      print('DEBUG: Error loading user profile: $error');
      return Stream.value([]);
    },
  );
});

// Провайдер для получения расписания в зависимости от роли пользователя
final scheduleProvider = Provider<Stream<List<ScheduleEntry>>>((ref) {
  final userProfile = ref.watch(userProfileProvider);

  return userProfile.when(
    data: (user) {
      if (user == null) {
        print('DEBUG: No user found');
        return Stream.value([]);
      }

      print('DEBUG: User role: ${user.role}');
      if (user.role == 'teacher') {
        return ref.watch(teacherScheduleProvider.stream);
      } else {
        return ref.watch(studentScheduleProvider.stream);
      }
    },
    loading: () {
      print('DEBUG: User profile is loading');
      return Stream.value([]);
    },
    error: (error, stack) {
      print('DEBUG: Error loading user profile: $error');
      return Stream.value([]);
    },
  );
});
