import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/schedule_entry.dart';
import '../providers/schedule_provider.dart';
import '../../../core/auth_service.dart';

class SchedulePage extends ConsumerWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    if (user == null) {
      return const Center(child: Text('Пользователь не найден'));
    }

    final scheduleAsync = ref.watch(teacherScheduleProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(teacherScheduleProvider(user.uid)),
          ),
        ],
      ),
      body: scheduleAsync.when(
        data: (lessons) {
          if (lessons.isEmpty) {
            return const Center(child: Text('Нет занятий для отображения'));
          }

          // Группируем занятия по дням недели
          final groupedLessons = <int, List<ScheduleEntry>>{};
          for (var lesson in lessons) {
            groupedLessons.putIfAbsent(lesson.dayOfWeek, () => []).add(lesson);
          }

          // Сортируем занятия по времени начала
          for (var dayLessons in groupedLessons.values) {
            dayLessons.sort((a, b) => a.startTime.compareTo(b.startTime));
          }

          return ListView.builder(
            itemCount: 7, // Дни недели
            itemBuilder: (context, dayIndex) {
              final dayLessons = groupedLessons[dayIndex] ?? [];
              if (dayLessons.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _getDayName(dayIndex),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...dayLessons.map((lesson) => _LessonCard(lesson: lesson)),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }

  String _getDayName(int dayIndex) {
    const days = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    return days[dayIndex];
  }
}

class _LessonCard extends StatelessWidget {
  final ScheduleEntry lesson;

  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text('${lesson.startTime} - ${lesson.endTime}'),
        subtitle: Text(
          lesson.room.isNotEmpty ? lesson.room : 'Аудитория не указана',
        ),
        leading: Icon(
          Icons.access_time,
          color: Theme.of(context).colorScheme.primary,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
