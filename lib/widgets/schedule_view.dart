import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/schedule_entry.dart';
import '../providers/schedule_provider.dart';
import '../providers/subject_provider.dart';
import '../providers/teacher_provider.dart';
import '../providers/user_profile_provider.dart';

// Провайдер для текущего типа недели
final weekTypeProvider = StateProvider<String>((ref) => 'all');

// Провайдер для поискового запроса
final searchQueryProvider = StateProvider<String>((ref) => '');

class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return userProfile.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Пользователь не найден'));
        }

        final scheduleStream =
            user.role == 'teacher'
                ? ref.watch(teacherScheduleProvider)
                : ref.watch(studentScheduleProvider);

        return scheduleStream.when(
          data: (lessons) {
            // Группируем занятия по дням недели
            final lessonsByDay = <int, List<ScheduleEntry>>{};
            for (var lesson in lessons) {
              lessonsByDay.putIfAbsent(lesson.dayOfWeek, () => []).add(lesson);
            }
            // Сортируем уроки по времени начала
            for (var dayLessons in lessonsByDay.values) {
              dayLessons.sort((a, b) => a.startTime.compareTo(b.startTime));
            }
            // ВСЕГДА отображаем все дни недели
            return ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final dayIndex = index + 1; // 1 - Пн, 7 - Вс
                final dayLessons = lessonsByDay[dayIndex] ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      child: Row(
                        children: [
                          Text(
                            _getDayName(index),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${dayLessons.length} ${_getLessonCountText(dayLessons.length)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    ...dayLessons.map((lesson) => LessonCard(lesson: lesson)),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Ошибка: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
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

  String _getLessonCountText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'занятие';
    } else if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'занятия';
    } else {
      return 'занятий';
    }
  }
}

class LessonCard extends ConsumerWidget {
  final ScheduleEntry lesson;

  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectByIdProvider(lesson.subjectId));
    final teacherName = ref.watch(teacherNameByIdProvider(lesson.teacherId));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${lesson.startTime} - ${lesson.endTime}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getLessonTypeName(lesson.type),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                _buildWeekTypeChip(lesson.weekType),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subject?.name ?? 'Неизвестный предмет',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: teacherName.when(
                    data:
                        (name) => Text(
                          name.isEmpty ? 'Не указан' : name,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    loading: () => const Text('Загрузка...'),
                    error: (_, __) => const Text('Не указан'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  lesson.room,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLessonTypeName(String type) {
    switch (type) {
      case 'lecture':
        return 'Лекция';
      case 'practice':
        return 'Практика';
      case 'lab':
        return 'Лабораторная';
      default:
        return type;
    }
  }

  Widget _buildWeekTypeChip(String weekType) {
    Color color;
    String label;

    switch (weekType) {
      case 'all':
        color = Colors.blue;
        label = 'Все';
        break;
      case 'numerator':
        color = Colors.green;
        label = 'Числитель';
        break;
      case 'denominator':
        color = Colors.orange;
        label = 'Знаменатель';
        break;
      default:
        color = Colors.grey;
        label = weekType;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
