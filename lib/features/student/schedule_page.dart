// lib/features/student/schedule_page.dart (исправленная версия)
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mycollege/features/student/providers/schedule_provider.dart';
import '../../providers/subject_provider.dart';
import '../../providers/teacher_provider.dart'; // Используем исправленный провайдер
import '../../models/schedule_entry.dart';
import '../../models/subject.dart';
import 'widgets/semester_selector.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<int> _daysOfWeek = List.generate(6, (index) => index + 1);
  final List<String> _dayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _daysOfWeek.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showSemesterDialog(BuildContext context) async {
    final selectedSemester = ref.read(selectedSemesterProvider);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите семестр'),
          content: SemesterSelector(
            selectedSemester: selectedSemester,
            onSemesterSelected: (semester) {
              ref.read(selectedSemesterProvider.notifier).state = semester;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selectedSemester = ref.watch(selectedSemesterProvider);
    final groupedSchedule = ref.watch(groupedScheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note),
            tooltip:
                selectedSemester != null ? selectedSemester.name : 'Семестр',
            onPressed: () => _showSemesterDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: List.generate(
            _daysOfWeek.length,
            (index) => Tab(text: _dayNames[index]),
          ),
        ),
      ),
      body: Expanded(
        child: ref
            .watch(scheduleProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Ошибка загрузки расписания',
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(scheduleProvider),
                            child: const Text('Повторить'),
                          ),
                        ],
                      ),
                    ),
                  ),
              data: (schedule) {
                // Получаем все предметы
                final allSubjectsAsync = ref.watch(subjectsProvider);

                return allSubjectsAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Ошибка загрузки предметов.\n$error',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  data: (allSubjects) {
                    return TabBarView(
                      controller: _tabController,
                      children: List.generate(_daysOfWeek.length, (tabIndex) {
                        final dayOfWeek = _daysOfWeek[tabIndex];
                        final lessonsForDay = groupedSchedule[dayOfWeek] ?? [];

                        return RefreshIndicator(
                          color: colorScheme.primary,
                          onRefresh: () async {
                            ref.invalidate(scheduleProvider);
                            ref.invalidate(subjectsProvider);
                            return;
                          },
                          child:
                              lessonsForDay.isEmpty
                                  ? LayoutBuilder(
                                    builder: (context, constraints) {
                                      return SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minHeight: constraints.maxHeight,
                                          ),
                                          child: Center(
                                            child:
                                                Text(
                                                  'Нет занятий в этот день',
                                                  style: textTheme.titleMedium
                                                      ?.copyWith(
                                                        color:
                                                            colorScheme
                                                                .onSurfaceVariant,
                                                      ),
                                                ).animate().fadeIn(),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(16.0),
                                    itemCount: lessonsForDay.length,
                                    itemBuilder: (context, lessonIndex) {
                                      final lesson = lessonsForDay[lessonIndex];
                                      return _LessonCard(
                                            lesson: lesson,
                                            subject:
                                                allSubjects[lesson.subjectId],
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: (lessonIndex * 80).ms,
                                            duration: 300.ms,
                                          )
                                          .moveX(
                                            begin: -10,
                                            end: 0,
                                            duration: 300.ms,
                                          );
                                    },
                                  ),
                        );
                      }),
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}

class _LessonCard extends ConsumerWidget {
  final ScheduleEntry lesson;
  final Subject? subject;
  const _LessonCard({required this.lesson, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isCurrent = _isCurrentLesson(lesson);

    // ИСПРАВЛЕНО: Используем правильный провайдер
    print(
      'DEBUG: _LessonCard building for lesson with teacherId: ${lesson.teacherId}',
    );
    final teacherNameAsync = ref.watch(
      teacherNameByIdProvider(lesson.teacherId),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape:
          isCurrent
              ? RoundedRectangleBorder(
                side: BorderSide(color: colorScheme.primary, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              )
              : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Время
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.startTime,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isCurrent ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.endTime,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isCurrent)
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Chip(
                          label: const Text('ИДЕТ'),
                          backgroundColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 10,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(
                          duration: 1200.ms,
                          color: colorScheme.primary.withAlpha(80),
                        ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: 1.5,
                height: 50,
                color: colorScheme.outlineVariant.withAlpha(128),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject?.name ?? 'Неизвестный предмет',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      _getLessonType(lesson.type),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: teacherNameAsync.when(
                          data: (name) {
                            print('DEBUG: Teacher name loaded: $name');
                            return Text(
                              name,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                          loading: () {
                            print('DEBUG: Teacher name loading...');
                            return Text(
                              'Загрузка...',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                          error: (e, s) {
                            print('DEBUG: Teacher name error: $e');
                            return Text(
                              'Ошибка: $e',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.error,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          lesson.room.isEmpty
                              ? 'Аудитория не указана'
                              : lesson.room,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isCurrentLesson(ScheduleEntry lesson) {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return lesson.dayOfWeek == now.weekday &&
        lesson.startTime.compareTo(currentTime) <= 0 &&
        lesson.endTime.compareTo(currentTime) >= 0;
  }

  String _getLessonType(String type) {
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
}
