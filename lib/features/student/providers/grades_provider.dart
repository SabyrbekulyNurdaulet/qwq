// lib/features/student/providers/grades_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/journal_entry.dart';
import '../../../core/auth_service.dart';

// Провайдер для получения оценок студента из журналов
final studentGradesProvider = StreamProvider.autoDispose<List<JournalEntry>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final student = authState.valueOrNull;

  if (student == null) {
    print('DEBUG: studentGradesProvider: No student found');
    return Stream.value([]);
  }

  print(
    'DEBUG: studentGradesProvider: Getting grades for student ${student.uid}',
  );

  return FirebaseFirestore.instance
      .collection('journalEntries')
      .where('studentId', isEqualTo: student.uid)
      .where('grade', isNotEqualTo: null) // Только записи с оценками
      .orderBy('grade') // Нужно для where с isNotEqualTo
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) {
        print(
          'DEBUG: studentGradesProvider: Found ${snapshot.docs.length} grade entries',
        );

        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            return JournalEntry.fromJson({...data, 'id': doc.id});
          } catch (e) {
            print(
              'DEBUG: studentGradesProvider: Error parsing grade entry ${doc.id}: $e',
            );
            // Возвращаем базовую запись в случае ошибки
            return JournalEntry(
              id: doc.id,
              journalId: 'unknown',
              studentId: student.uid,
              date: DateTime.now(),
              attendanceStatus: 'present',
              present: true,
              gradeType: 'current',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList();
      });
});

// Провайдер для получения уникальных предметов из оценок студента
final studentSubjectsFromGradesProvider = Provider.autoDispose<List<String>>((
  ref,
) {
  final gradesAsync = ref.watch(studentGradesProvider);

  return gradesAsync.when(
    data: (grades) {
      final subjects = <String>{};

      for (final grade in grades) {
        // Получаем предмет из журнала
        // Нужно будет дополнительно загрузить информацию о журнале
        subjects.add(grade.journalId); // Временно используем journalId
      }

      final sortedSubjects = subjects.toList()..sort();
      return ['Все', ...sortedSubjects];
    },
    loading: () => ['Все'],
    error: (_, __) => ['Все'],
  );
});

// Провайдер для расширенных данных оценок с информацией о предметах
final studentGradesWithSubjectsProvider = StreamProvider.autoDispose<
  List<Map<String, dynamic>>
>((ref) {
  final authState = ref.watch(authStateProvider);
  final student = authState.valueOrNull;

  if (student == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('journalEntries')
      .where('studentId', isEqualTo: student.uid)
      .where('grade', isNotEqualTo: null)
      .orderBy('grade')
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((entriesSnapshot) async {
        print(
          'DEBUG: studentGradesWithSubjectsProvider: Processing ${entriesSnapshot.docs.length} entries',
        );

        final List<Map<String, dynamic>> gradesWithSubjects = [];

        for (final entryDoc in entriesSnapshot.docs) {
          try {
            final entryData = entryDoc.data();
            final entry = JournalEntry.fromJson({
              ...entryData,
              'id': entryDoc.id,
            });

            // Получаем информацию о журнале для получения предмета
            final journalDoc =
                await FirebaseFirestore.instance
                    .collection('journals')
                    .doc(entry.journalId)
                    .get();

            String subjectName = 'Неизвестный предмет';
            String teacherName = 'Неизвестный преподаватель';

            if (journalDoc.exists) {
              final journalData = journalDoc.data()!;
              final subjectId = journalData['subjectId'] as String?;
              final teacherId = journalData['teacherId'] as String?;

              // Получаем название предмета
              if (subjectId != null) {
                final subjectDoc =
                    await FirebaseFirestore.instance
                        .collection('subjects')
                        .doc(subjectId)
                        .get();

                if (subjectDoc.exists) {
                  subjectName =
                      subjectDoc.data()?['name'] ?? 'Предмет не найден';
                }
              }

              // Получаем имя преподавателя
              if (teacherId != null) {
                final teacherDoc =
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(teacherId)
                        .get();

                if (teacherDoc.exists) {
                  final teacherData = teacherDoc.data()!;
                  final firstName = teacherData['firstName'] ?? '';
                  final lastName = teacherData['lastName'] ?? '';
                  final middleName = teacherData['middleName'] ?? '';
                  teacherName = '$lastName $firstName $middleName'.trim();
                }
              }
            }

            gradesWithSubjects.add({
              'entry': entry,
              'subjectName': subjectName,
              'teacherName': teacherName,
            });
          } catch (e) {
            print(
              'DEBUG: studentGradesWithSubjectsProvider: Error processing entry ${entryDoc.id}: $e',
            );
          }
        }

        print(
          'DEBUG: studentGradesWithSubjectsProvider: Processed ${gradesWithSubjects.length} grades with subjects',
        );
        return gradesWithSubjects;
      });
});

// Провайдер для статистики оценок студента
final studentGradesStatsProvider = Provider.autoDispose<Map<String, dynamic>>((
  ref,
) {
  final gradesAsync = ref.watch(studentGradesProvider);

  return gradesAsync.when(
    data: (grades) {
      if (grades.isEmpty) {
        return {
          'totalGrades': 0,
          'averageGrade': 0.0,
          'gradesByType': <String, int>{},
          'gradesBySubject': <String, List<JournalEntry>>{},
          'recentGrades': 0,
        };
      }

      final numericGrades = grades.where((g) => g.hasNumericGrade).toList();
      double averageGrade = 0.0;

      if (numericGrades.isNotEmpty) {
        final sum = numericGrades
            .map((g) => g.numericGradeValue!)
            .reduce((a, b) => a + b);
        averageGrade = sum / numericGrades.length;
      }

      // Группировка по типам оценок
      final gradesByType = <String, int>{};
      for (final grade in grades) {
        gradesByType[grade.gradeType] =
            (gradesByType[grade.gradeType] ?? 0) + 1;
      }

      // Группировка по предметам (временно по journalId)
      final gradesBySubject = <String, List<JournalEntry>>{};
      for (final grade in grades) {
        gradesBySubject.putIfAbsent(grade.journalId, () => []).add(grade);
      }

      // Подсчет недавних оценок (за последнюю неделю)
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final recentGrades = grades.where((g) => g.date.isAfter(weekAgo)).length;

      return {
        'totalGrades': grades.length,
        'averageGrade': averageGrade,
        'gradesByType': gradesByType,
        'gradesBySubject': gradesBySubject,
        'recentGrades': recentGrades,
        'numericGradesCount': numericGrades.length,
      };
    },
    loading:
        () => {
          'totalGrades': 0,
          'averageGrade': 0.0,
          'gradesByType': <String, int>{},
          'gradesBySubject': <String, List<JournalEntry>>{},
          'recentGrades': 0,
        },
    error:
        (_, __) => {
          'totalGrades': 0,
          'averageGrade': 0.0,
          'gradesByType': <String, int>{},
          'gradesBySubject': <String, List<JournalEntry>>{},
          'recentGrades': 0,
        },
  );
});

// Провайдер для получения уникальных предметов с правильными названиями
final studentUniqueSubjectsProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final gradesWithSubjects = await ref.watch(
    studentGradesWithSubjectsProvider.future,
  );

  final subjects = <String>{};
  for (final gradeData in gradesWithSubjects) {
    final subjectName = gradeData['subjectName'] as String;
    subjects.add(subjectName);
  }

  final sortedSubjects = subjects.toList()..sort();
  return ['Все', ...sortedSubjects];
});
