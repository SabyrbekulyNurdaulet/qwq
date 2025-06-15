// lib/features/teacher/pages/grades_history_page.dart (ОБНОВЛЕННАЯ ВЕРСИЯ)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../providers/journal_provider.dart';
import '../../../providers/group_provider.dart';
import '../../../providers/subject_provider.dart';
import '../../../providers/user_provider.dart' as user_prov;
import '../../../models/journal_entry.dart';
import '../../../models/user.dart' as app_user;

class GradesHistoryPage extends ConsumerStatefulWidget {
  const GradesHistoryPage({super.key});

  @override
  ConsumerState<GradesHistoryPage> createState() => _GradesHistoryPageState();
}

class _GradesHistoryPageState extends ConsumerState<GradesHistoryPage> {
  String _filterSubject = 'Все';
  String _filterGradeType = 'Все';
  String _filterGroup = 'Все';

  @override
  Widget build(BuildContext context) {
    final teacherId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final journalsAsync = ref.watch(teacherJournalsProvider(teacherId));

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('История записей в журнале'),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      body: journalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка загрузки журналов',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
        data: (journals) {
          if (journals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Журналов пока нет',
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Журналы создаются автоматически при выставлении первой оценки',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Получаем все записи из всех журналов
          return _buildJournalEntriesList(journals);
        },
      ),
    );
  }

  Widget _buildJournalEntriesList(List journals) {
    // Собираем записи из всех журналов
    final allEntriesFuture = Future.wait(
      journals.map((journal) async {
        final entriesAsync = ref.read(
          journalEntriesProvider(journal.id).future,
        );
        final entries = await entriesAsync;
        return entries
            .map((entry) => {'entry': entry, 'journal': journal})
            .toList();
      }),
    );

    return FutureBuilder<List<List<Map<String, dynamic>>>>(
      future: allEntriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка загрузки записей: ${snapshot.error}'),
          );
        }

        final allEntriesData = snapshot.data ?? [];
        final flatEntries = allEntriesData.expand((list) => list).toList();

        if (flatEntries.isEmpty) {
          return const Center(child: Text('Записей в журналах пока нет'));
        }

        // Сортируем по дате (новые сначала)
        flatEntries.sort((a, b) {
          final entryA = a['entry'] as JournalEntry;
          final entryB = b['entry'] as JournalEntry;
          return entryB.date.compareTo(entryA.date);
        });

        // Подсчитываем статистику
        final totalEntries = flatEntries.length;
        final entriesWithGrades =
            flatEntries
                .where((data) => (data['entry'] as JournalEntry).grade != null)
                .length;
        final avgGrade = _calculateAverageGrade(flatEntries);

        return Column(
          children: [
            // Статистика
            _buildStatsCard(totalEntries, entriesWithGrades, avgGrade),

            // Фильтры
            _buildFilters(flatEntries),

            // Список записей
            Expanded(child: _buildEntriesList(flatEntries)),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(int total, int withGrades, double avgGrade) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Статистика',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Всего записей',
                total.toString(),
                Icons.book,
                colorScheme,
                textTheme,
              ),
              _buildStatItem(
                'С оценками',
                withGrades.toString(),
                Icons.grade,
                colorScheme,
                textTheme,
              ),
              _buildStatItem(
                'Средний балл',
                avgGrade.toStringAsFixed(1),
                Icons.trending_up,
                colorScheme,
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
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilters(List<Map<String, dynamic>> allEntries) {
    // Собираем уникальные значения для фильтров
    final subjects = <String>{'Все'};
    final gradeTypes = <String>{'Все'};
    final groups = <String>{'Все'};

    for (final data in allEntries) {
      final journal = data['journal'];
      final entry = data['entry'] as JournalEntry;

      // Здесь нужно получить названия предметов и групп
      // Для простоты используем ID, но в реальном приложении
      // лучше получать полные названия
      subjects.add(journal.subjectId);
      gradeTypes.add(entry.gradeType);
      groups.add(journal.groupId);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  'Предмет',
                  _filterSubject,
                  subjects.toList(),
                  (value) => setState(() => _filterSubject = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFilterDropdown(
                  'Тип оценки',
                  _filterGradeType,
                  gradeTypes.toList(),
                  (value) => setState(() => _filterGradeType = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFilterDropdown(
            'Группа',
            _filterGroup,
            groups.toList(),
            (value) => setState(() => _filterGroup = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      value: value,
      items:
          items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildEntriesList(List<Map<String, dynamic>> allEntries) {
    // Применяем фильтры
    final filteredEntries =
        allEntries.where((data) {
          final journal = data['journal'];
          final entry = data['entry'] as JournalEntry;

          if (_filterSubject != 'Все' && journal.subjectId != _filterSubject) {
            return false;
          }
          if (_filterGradeType != 'Все' &&
              entry.gradeType != _filterGradeType) {
            return false;
          }
          if (_filterGroup != 'Все' && journal.groupId != _filterGroup) {
            return false;
          }
          return true;
        }).toList();

    if (filteredEntries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет записей по выбранному фильтру',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Попробуйте изменить фильтры',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final data = filteredEntries[index];
        final entry = data['entry'] as JournalEntry;
        final journal = data['journal'];
        return _JournalEntryCard(entry: entry, journal: journal);
      },
    );
  }

  double _calculateAverageGrade(List<Map<String, dynamic>> entries) {
    final entriesWithNumericGrades =
        entries
            .map((data) => data['entry'] as JournalEntry)
            .where((entry) => entry.hasNumericGrade)
            .toList();

    if (entriesWithNumericGrades.isEmpty) return 0.0;

    final sum = entriesWithNumericGrades
        .map((entry) => entry.numericGradeValue!)
        .reduce((a, b) => a + b);

    return sum / entriesWithNumericGrades.length;
  }
}

class _JournalEntryCard extends ConsumerWidget {
  final JournalEntry entry;
  final dynamic journal; // Journal object

  const _JournalEntryCard({required this.entry, required this.journal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('dd.MM.yyyy в HH:mm', 'ru_RU');

    // Получаем дополнительную информацию
    final subjectAsync = ref.watch(subjectByIdProvider(journal.subjectId));
    final groupAsync = ref.watch(groupNameProvider(journal.groupId));
    final studentAsync = ref
        .watch(user_prov.userServiceProvider)
        .getUserById(entry.studentId);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Иконка типа оценки
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    entry.getGradeTypeIcon(),
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Дата и тип оценки
                      Text(
                        '${entry.getGradeTypeName()} • ${DateFormat('dd.MM.yyyy').format(entry.date)}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Студент
                      FutureBuilder<app_user.User?>(
                        future: studentAsync,
                        builder: (context, snapshot) {
                          final studentName =
                              (snapshot.data != null &&
                                      snapshot.data is app_user.User)
                                  ? (snapshot.data as app_user.User).fullName
                                  : 'Загрузка...';
                          return Text(
                            'Студент: $studentName',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Оценка
                if (entry.grade != null && entry.grade!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: entry.getGradeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: entry.getGradeColor().withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      entry.displayGrade,
                      style: textTheme.titleMedium?.copyWith(
                        color: entry.getGradeColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Предмет и группа
            Row(
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: () {
                    final subject = ref.watch(
                      subjectByIdProvider(journal.subjectId),
                    );
                    if (subject != null) {
                      return Text(
                        'Предмет: ${subject.name}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    } else {
                      return Text(
                        'Предмет: ${journal.subjectId}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    }
                  }(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: groupAsync.when(
                    data:
                        (groupName) => Text(
                          'Группа: $groupName',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                    loading: () => const Text('Загрузка группы...'),
                    error:
                        (_, __) => Text(
                          'Группа: ${journal.groupId}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                  ),
                ),
              ],
            ),

            // Посещаемость
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  entry.getAttendanceIcon(),
                  size: 16,
                  color: entry.getAttendanceColor(),
                ),
                const SizedBox(width: 4),
                Text(
                  entry.getAttendanceDisplayName(),
                  style: textTheme.bodySmall?.copyWith(
                    color: entry.getAttendanceColor(),
                  ),
                ),
              ],
            ),

            // Тема занятия
            if (entry.topicCovered != null &&
                entry.topicCovered!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Тема: ${entry.topicCovered}',
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            // Комментарий
            if (entry.comment != null && entry.comment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry.comment!,
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            // Время создания
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Создано: ${dateFormat.format(entry.createdAt)}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                // Можно добавить кнопки редактирования/удаления
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 16,
                      onPressed: () {
                        // TODO: Добавить редактирование записи
                      },
                      tooltip: 'Редактировать',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 16,
                      onPressed: () {
                        // TODO: Добавить удаление записи
                        _showDeleteConfirmation(context, entry.id);
                      },
                      tooltip: 'Удалить',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String entryId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Удалить запись?'),
            content: const Text(
              'Вы уверены, что хотите удалить эту запись из журнала? '
              'Это действие нельзя будет отменить.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // TODO: Реализовать удаление записи
                  // ref.read(deleteJournalEntryProvider(entryId));
                },
                child: const Text(
                  'Удалить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
