// lib/features/student/attendance_page.dart (ОБНОВЛЕННАЯ ВЕРСИЯ)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/journal_entry.dart';
import 'providers/attendance_provider.dart'; // Используем новый провайдер

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  String _selectedSubject = 'Все';

  @override
  Widget build(BuildContext context) {
    final attendanceWithSubjectsAsync = ref.watch(
      studentAttendanceWithSubjectsProvider,
    );
    final statsAsync = ref.watch(studentAttendanceStatsProvider);
    final uniqueSubjectsAsync = ref.watch(
      studentUniqueSubjectsFromAttendanceProvider,
    );

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя посещаемость'),
        actions: [
          if (_selectedSubject != 'Все')
            IconButton(
              icon: const Icon(Icons.filter_alt_off_outlined),
              tooltip: 'Сбросить фильтр',
              onPressed: () => setState(() => _selectedSubject = 'Все'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Статистика посещаемости
          _buildStatsCard(statsAsync, colorScheme, textTheme),

          // Фильтр по предметам
          _buildSubjectFilter(uniqueSubjectsAsync, colorScheme),

          // Список записей посещаемости
          Expanded(
            child: attendanceWithSubjectsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                debugPrint('Error loading attendance: $error\n$stack');
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
                          'Ошибка загрузки посещаемости',
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
                                studentAttendanceWithSubjectsProvider,
                              ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              data: (attendanceWithSubjects) {
                final filteredAttendance = _filterAttendance(
                  attendanceWithSubjects,
                );

                if (filteredAttendance.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedSubject == 'Все'
                                ? 'Нет данных о посещаемости'
                                : 'Нет данных по предмету "$_selectedSubject"',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_selectedSubject != 'Все') ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed:
                                  () =>
                                      setState(() => _selectedSubject = 'Все'),
                              child: const Text('Показать все предметы'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                // Группируем записи по предметам
                final groupedAttendance =
                    <String, List<Map<String, dynamic>>>{};
                for (final attendanceData in filteredAttendance) {
                  final subjectName = attendanceData['subjectName'] as String;
                  groupedAttendance
                      .putIfAbsent(subjectName, () => [])
                      .add(attendanceData);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(studentAttendanceWithSubjectsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: groupedAttendance.length,
                    itemBuilder: (context, index) {
                      final subjectName = groupedAttendance.keys.elementAt(
                        index,
                      );
                      final records = groupedAttendance[subjectName]!;

                      // Сортируем записи по дате (от новых к старым)
                      records.sort((a, b) {
                        final entryA = a['entry'] as JournalEntry;
                        final entryB = b['entry'] as JournalEntry;
                        return entryB.date.compareTo(entryA.date);
                      });

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок предмета
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withAlpha(
                                  77,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    color: colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      subjectName,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  _buildSubjectStats(
                                    records,
                                    colorScheme,
                                    textTheme,
                                  ),
                                ],
                              ),
                            ),

                            // Список записей посещаемости
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: records.length,
                              separatorBuilder:
                                  (_, __) => const Divider(height: 1),
                              itemBuilder: (context, recordIndex) {
                                final attendanceData = records[recordIndex];
                                final entry =
                                    attendanceData['entry'] as JournalEntry;
                                final teacherName =
                                    attendanceData['teacherName'] as String;

                                return _AttendanceListTile(
                                  entry: entry,
                                  teacherName: teacherName,
                                );
                              },
                            ),
                          ],
                        ),
                      );
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
    final totalLessons = stats['totalLessons'] as int;
    final presentCount = stats['presentCount'] as int;
    final absentCount = stats['absentCount'] as int;
    final attendanceRate = stats['attendanceRate'] as double;

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
            'Статистика посещаемости',
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
                'Всего занятий',
                totalLessons.toString(),
                Icons.calendar_today,
                colorScheme.primary,
                textTheme,
              ),
              _buildStatItem(
                'Присутствовал',
                presentCount.toString(),
                Icons.check_circle,
                Colors.green,
                textTheme,
              ),
              _buildStatItem(
                'Отсутствовал',
                absentCount.toString(),
                Icons.cancel,
                Colors.red,
                textTheme,
              ),
              _buildStatItem(
                'Процент',
                '${attendanceRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                _getAttendanceRateColor(attendanceRate).withAlpha(26),
                textTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubjectFilter(
    AsyncValue<List<String>> uniqueSubjectsAsync,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              isExpanded: true,
              items:
                  subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
              onChanged: (String? value) {
                if (value != null) setState(() => _selectedSubject = value);
              },
            ),
        loading:
            () => const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            ),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  Widget _buildSubjectStats(
    List<Map<String, dynamic>> records,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final presentCount =
        records.where((r) {
          final entry = r['entry'] as JournalEntry;
          return entry.attendanceStatus == 'present';
        }).length;

    final rate =
        records.isNotEmpty ? (presentCount / records.length) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getAttendanceRateColor(rate).withAlpha(26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getAttendanceRateColor(rate).withAlpha(77)),
      ),
      child: Text(
        '${rate.toStringAsFixed(0)}%',
        style: textTheme.bodySmall?.copyWith(
          color: _getAttendanceRateColor(rate),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getAttendanceRateColor(double rate) {
    if (rate >= 90) return Colors.green;
    if (rate >= 75) return Colors.orange;
    return Colors.red;
  }

  List<Map<String, dynamic>> _filterAttendance(
    List<Map<String, dynamic>> attendanceWithSubjects,
  ) {
    if (_selectedSubject == 'Все') {
      return attendanceWithSubjects;
    }

    return attendanceWithSubjects.where((attendanceData) {
      final subjectName = attendanceData['subjectName'] as String;
      return subjectName == _selectedSubject;
    }).toList();
  }
}

class _AttendanceListTile extends StatefulWidget {
  final JournalEntry entry;
  final String teacherName;

  const _AttendanceListTile({required this.entry, required this.teacherName});

  @override
  State<_AttendanceListTile> createState() => _AttendanceListTileState();
}

class _AttendanceListTileState extends State<_AttendanceListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.entry.getAttendanceIcon(),
                  color: widget.entry.getAttendanceColor(),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'd MMMM y',
                          'ru_RU',
                        ).format(widget.entry.date),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.entry.getAttendanceDisplayName(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: widget.entry.getAttendanceColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),

            if (_isExpanded) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              // Преподаватель
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Преподаватель: ${widget.teacherName}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

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
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Тема: ${widget.entry.topicCovered}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Оценка (если есть)
              if (widget.entry.grade != null &&
                  widget.entry.grade!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.grade_outlined,
                      size: 16,
                      color: widget.entry.getGradeColor(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Оценка: ${widget.entry.displayGrade}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: widget.entry.getGradeColor(),
                        fontWeight: FontWeight.w600,
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
                        color: colorScheme.onSurfaceVariant,
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
    );
  }
}
