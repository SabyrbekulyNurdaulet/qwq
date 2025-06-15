// lib/features/student/grades_page.dart (ОБНОВЛЕННАЯ ВЕРСИЯ)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../models/journal_entry.dart';
import 'providers/grades_provider.dart'; // Используем новый провайдер

class GradesPage extends ConsumerStatefulWidget {
  const GradesPage({super.key});

  @override
  ConsumerState<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends ConsumerState<GradesPage> {
  String _selectedSubject = 'Все';
  String _selectedGradeType = 'Все';

  @override
  Widget build(BuildContext context) {
    final gradesWithSubjectsAsync = ref.watch(
      studentGradesWithSubjectsProvider,
    );
    final statsAsync = ref.watch(studentGradesStatsProvider);
    final uniqueSubjectsAsync = ref.watch(studentUniqueSubjectsProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои оценки'),
        actions: [
          if (_selectedSubject != 'Все' || _selectedGradeType != 'Все')
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              tooltip: 'Сбросить фильтры',
              onPressed:
                  () => setState(() {
                    _selectedSubject = 'Все';
                    _selectedGradeType = 'Все';
                  }),
            ),
        ],
      ),
      body: Column(
        children: [
          // Статистика
          _buildStatsCard(statsAsync, colorScheme, textTheme),

          // Фильтры
          _buildFilters(uniqueSubjectsAsync, colorScheme),

          // Список оценок
          Expanded(
            child: gradesWithSubjectsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                debugPrint('Error loading grades: $error\n$stack');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
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
                          'Ошибка загрузки оценок',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(error.toString(), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => ref.refresh(
                                studentGradesWithSubjectsProvider,
                              ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              data: (gradesWithSubjects) {
                final filteredGrades = _filterGrades(gradesWithSubjects);

                if (filteredGrades.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.grade_outlined,
                                size: 64,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedSubject == 'Все' &&
                                        _selectedGradeType == 'Все'
                                    ? 'У вас пока нет оценок'
                                    : 'Нет оценок по выбранным фильтрам',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_selectedSubject != 'Все' ||
                                  _selectedGradeType != 'Все') ...[
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed:
                                      () => setState(() {
                                        _selectedSubject = 'Все';
                                        _selectedGradeType = 'Все';
                                      }),
                                  child: const Text('Сбросить фильтры'),
                                ),
                              ],
                            ],
                          ).animate().fadeIn(),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(studentGradesWithSubjectsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredGrades.length,
                    itemBuilder: (context, index) {
                      final gradeData = filteredGrades[index];
                      final entry = gradeData['entry'] as JournalEntry;
                      final subjectName = gradeData['subjectName'] as String;
                      final teacherName = gradeData['teacherName'] as String;

                      return _GradeCard(
                            entry: entry,
                            subjectName: subjectName,
                            teacherName: teacherName,
                          )
                          .animate()
                          .fadeIn(delay: (index * 50).ms, duration: 250.ms)
                          .moveX(begin: -10, duration: 250.ms);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(
    Map<String, dynamic> stats,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final totalGrades = stats['totalGrades'] as int;
    final averageGrade = stats['averageGrade'] as double;
    final recentGrades = stats['recentGrades'] as int;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withAlpha(77),
            colorScheme.secondaryContainer.withAlpha(77),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.primary.withAlpha(77)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика оценок',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Всего оценок',
                totalGrades.toString(),
                Icons.grade,
                colorScheme,
                textTheme,
              ),
              _buildStatItem(
                'Средний балл',
                averageGrade > 0 ? averageGrade.toStringAsFixed(1) : '--',
                Icons.trending_up,
                colorScheme,
                textTheme,
              ),
              _buildStatItem(
                'За неделю',
                recentGrades.toString(),
                Icons.schedule,
                colorScheme,
                textTheme,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilters(
    AsyncValue<List<String>> uniqueSubjectsAsync,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Фильтр по предметам
          Expanded(
            flex: 2,
            child: uniqueSubjectsAsync.when(
              data:
                  (subjects) => DropdownButtonFormField<String>(
                    value: _selectedSubject,
                    decoration: InputDecoration(
                      labelText: 'Предмет',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    isExpanded: true,
                    items:
                        subjects.map((subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(
                              subject,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSubject = value);
                      }
                    },
                  ),
              loading:
                  () => const SizedBox(
                    height: 56,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error: (_, __) => const SizedBox(),
            ),
          ),
          const SizedBox(width: 16),
          // Фильтр по типам оценок
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedGradeType,
              decoration: InputDecoration(
                labelText: 'Тип',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Все', child: Text('Все')),
                DropdownMenuItem(value: 'current', child: Text('Текущие')),
                DropdownMenuItem(value: 'midterm', child: Text('Рубежные')),
                DropdownMenuItem(value: 'final', child: Text('Итоговые')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedGradeType = value);
                }
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  List<Map<String, dynamic>> _filterGrades(
    List<Map<String, dynamic>> gradesWithSubjects,
  ) {
    return gradesWithSubjects.where((gradeData) {
      final entry = gradeData['entry'] as JournalEntry;
      final subjectName = gradeData['subjectName'] as String;

      // Фильтр по предмету
      if (_selectedSubject != 'Все' && subjectName != _selectedSubject) {
        return false;
      }

      // Фильтр по типу оценки
      if (_selectedGradeType != 'Все' &&
          entry.gradeType != _selectedGradeType) {
        return false;
      }

      return true;
    }).toList();
  }
}

class _GradeCard extends StatefulWidget {
  final JournalEntry entry;
  final String subjectName;
  final String teacherName;

  const _GradeCard({
    required this.entry,
    required this.subjectName,
    required this.teacherName,
  });

  @override
  State<_GradeCard> createState() => _GradeCardState();
}

class _GradeCardState extends State<_GradeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final formattedDate = DateFormat(
      'd MMMM yyyy',
      'ru_RU',
    ).format(widget.entry.date);
    final gradeColor = widget.entry.getGradeColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Иконка типа оценки
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.entry.getGradeColor().withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.entry.getGradeColor().withAlpha(77),
                      ),
                    ),
                    child: Icon(
                      widget.entry.getGradeTypeIcon(),
                      color: widget.entry.getGradeColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.subjectName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.entry.getGradeTypeName()} • $formattedDate',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Оценка
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: gradeColor.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gradeColor.withAlpha(77)),
                        ),
                        child: Text(
                          widget.entry.displayGrade,
                          style: textTheme.titleMedium?.copyWith(
                            color: gradeColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ],
              ),

              // Развернутая информация
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Преподаватель
                Row(
                  children: [
                    Icon(
                      Icons.person_outlined,
                      size: 16,
                      color: colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Преподаватель: ${widget.teacherName}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),

                // Посещаемость
                if (widget.entry.attendanceStatus.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        widget.entry.getAttendanceIcon(),
                        size: 16,
                        color: widget.entry.getAttendanceColor(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Посещение: ${widget.entry.getAttendanceDisplayName()}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: widget.entry.getAttendanceColor(),
                        ),
                      ),
                    ],
                  ),
                ],

                // Тема занятия
                if (widget.entry.topicCovered != null &&
                    widget.entry.topicCovered!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.topic_outlined,
                        size: 16,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Тема: ${widget.entry.topicCovered}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Комментарий
                if (widget.entry.comment != null &&
                    widget.entry.comment!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withAlpha(128),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 16,
                          color: colorScheme.onSurface,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.entry.comment!,
                            style: textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
