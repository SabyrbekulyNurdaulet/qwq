import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/grade.dart';
import '../../providers/grades_provider.dart';

class GradesPage extends ConsumerWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradesAsync = ref.watch(gradesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Оценки')),
      body: gradesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
        data: (grades) {
          if (grades.isEmpty) {
            return const Center(child: Text('Нет оценок'));
          }

          // Группируем оценки по семестрам
          final gradesBySemester = <String, List<Grade>>{};
          for (final grade in grades) {
            final semester = '${grade.semester} семестр';
            gradesBySemester.putIfAbsent(semester, () => []).add(grade);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: gradesBySemester.length,
            itemBuilder: (context, index) {
              final semester = gradesBySemester.keys.elementAt(index);
              final semesterGrades = gradesBySemester[semester]!;

              // Вычисляем средний балл только для числовых оценок
              final numericGrades =
                  semesterGrades.where((g) => g.isNumeric).toList();
              final averageGrade =
                  numericGrades.isEmpty
                      ? null
                      : numericGrades
                              .map((g) => g.value)
                              .reduce((a, b) => a + b) /
                          numericGrades.length;

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        semester,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: semesterGrades.length,
                      itemBuilder: (context, index) {
                        final grade = semesterGrades[index];
                        return ListTile(
                          title: Text(grade.subject),
                          subtitle: Text(grade.teacher),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getGradeColor(grade),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              grade.displayValue,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (averageGrade != null) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Средний балл:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getAverageGradeColor(averageGrade),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                averageGrade.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getGradeColor(Grade grade) {
    if (!grade.isNumeric) {
      return grade.value == 1 ? Colors.green : Colors.red;
    }

    if (grade.value >= 90) return Colors.green;
    if (grade.value >= 75) return Colors.lightGreen;
    if (grade.value >= 60) return Colors.orange;
    return Colors.red;
  }

  Color _getAverageGradeColor(double average) {
    if (average >= 90) return Colors.green;
    if (average >= 75) return Colors.lightGreen;
    if (average >= 60) return Colors.orange;
    return Colors.red;
  }
}
