import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/attendance.dart';
import '../../providers/attendance_provider.dart';
import 'package:intl/intl.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedSubject = 'Все';
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Attendance>> _events = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final attendanceAsync = ref.watch(attendanceProvider);
    final subjects = ref.watch(uniqueSubjectsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Посещаемость'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedSubject,
              items:
                  subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSubject = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: attendanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
        data: (attendance) {
          // Фильтруем посещаемость по выбранному предмету
          final filteredAttendance =
              _selectedSubject == 'Все'
                  ? attendance
                  : attendance
                      .where((a) => a.subject == _selectedSubject)
                      .toList();

          // Группируем посещаемость по датам
          _events = {};
          for (final record in filteredAttendance) {
            final date = DateTime(
              record.date.year,
              record.date.month,
              record.date.day,
            );
            _events[date] = [...(_events[date] ?? []), record];
          }

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                eventLoader: (day) => _events[day] ?? [],
                onDaySelected: _onDaySelected,
                calendarStyle: CalendarStyle(
                  markersMaxCount: 1,
                  markerDecoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (_selectedDay != null) ...[
                const Divider(),
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _events[_selectedDay]?.length ?? 0,
                      itemBuilder: (context, index) {
                        final record = _events[_selectedDay]![index];
                        return Card(
                          child: ListTile(
                            leading: Icon(
                              record.getIcon(),
                              color: record.getColor(context),
                            ),
                            title: Text(
                              record.subject,
                              style: textTheme.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.getDisplayName(),
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: record.getColor(context),
                                  ),
                                ),
                                Text(
                                  'Преподаватель: ${record.teacher}',
                                  style: textTheme.bodySmall,
                                ),
                                Text(
                                  'Время: ${DateFormat.Hm().format(record.date)}',
                                  style: textTheme.bodySmall,
                                ),
                                if (record.comment != null)
                                  Text(
                                    'Комментарий: ${record.comment}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
