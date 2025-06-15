// lib/features/student/providers/attendance_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/journal_entry.dart';
import '../../../core/auth_service.dart';

// Провайдер для получения записей посещаемости студента из журналов
final studentAttendanceProvider = StreamProvider.autoDispose<
  List<JournalEntry>
>((ref) {
  final authState = ref.watch(authStateProvider);
  final student = authState.valueOrNull;

  if (student == null) {
    print('DEBUG: studentAttendanceProvider: No student found');
    return Stream.value([]);
  }

  print(
    'DEBUG: studentAttendanceProvider: Getting attendance for student ${student.uid}',
  );

  return FirebaseFirestore.instance
      .collection('journalEntries')
      .where('studentId', isEqualTo: student.uid)
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) {
        print(
          'DEBUG: studentAttendanceProvider: Found ${snapshot.docs.length} attendance entries',
        );

        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            // Добавляем проверки на null и значения по умолчанию
            final entryData = {
              ...data,
              'id': doc.id,
              'attendanceStatus': data['attendanceStatus'] ?? 'present',
              'present': data['present'] ?? true,
              'gradeType': data['gradeType'] ?? 'current',
              'grade': data['grade'],
              'comment': data['comment'],
              'topicCovered': data['topicCovered'],
              'lessonId': data['lessonId'],
            };
            return JournalEntry.fromJson(entryData);
          } catch (e) {
            print(
              'DEBUG: studentAttendanceProvider: Error parsing attendance entry ${doc.id}: $e',
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

// Провайдер для расширенных данных посещаемости с информацией о предметах
final studentAttendanceWithSubjectsProvider = StreamProvider.autoDispose<
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
      .orderBy('date', descending: true)
      .snapshots()
      .asyncMap((entriesSnapshot) async {
        print(
          'DEBUG: studentAttendanceWithSubjectsProvider: Processing ${entriesSnapshot.docs.length} entries',
        );

        final List<Map<String, dynamic>> attendanceWithSubjects = [];

        for (final entryDoc in entriesSnapshot.docs) {
          try {
            final entryData = entryDoc.data();
            // Добавляем проверки на null и значения по умолчанию
            final processedData = {
              ...entryData,
              'id': entryDoc.id,
              'attendanceStatus': entryData['attendanceStatus'] ?? 'present',
              'present': entryData['present'] ?? true,
              'gradeType': entryData['gradeType'] ?? 'current',
              'grade': entryData['grade'],
              'comment': entryData['comment'],
              'topicCovered': entryData['topicCovered'],
              'lessonId': entryData['lessonId'],
            };
            final entry = JournalEntry.fromJson(processedData);

            // Проверяем, что journalId не пустой
            if (entry.journalId.isEmpty) {
              print(
                'DEBUG: studentAttendanceWithSubjectsProvider: Empty journalId for entry ${entryDoc.id}',
              );
              attendanceWithSubjects.add({
                'entry': entry,
                'subjectName': 'Неизвестный предмет',
                'teacherName': 'Неизвестный преподаватель',
              });
              continue;
            }

            // Получаем информацию о журнале для получения предмета
            try {
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
                if (subjectId != null && subjectId.isNotEmpty) {
                  try {
                    final subjectDoc =
                        await FirebaseFirestore.instance
                            .collection('subjects')
                            .doc(subjectId)
                            .get();

                    if (subjectDoc.exists) {
                      subjectName =
                          subjectDoc.data()?['name'] ?? 'Предмет не найден';
                    }
                  } catch (e) {
                    print(
                      'DEBUG: studentAttendanceWithSubjectsProvider: Error getting subject: $e',
                    );
                  }
                }

                // Получаем имя преподавателя
                if (teacherId != null && teacherId.isNotEmpty) {
                  try {
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
                  } catch (e) {
                    print(
                      'DEBUG: studentAttendanceWithSubjectsProvider: Error getting teacher: $e',
                    );
                  }
                }
              }

              attendanceWithSubjects.add({
                'entry': entry,
                'subjectName': subjectName,
                'teacherName': teacherName,
              });
            } catch (e) {
              print(
                'DEBUG: studentAttendanceWithSubjectsProvider: Error getting journal: $e',
              );
              attendanceWithSubjects.add({
                'entry': entry,
                'subjectName': 'Неизвестный предмет',
                'teacherName': 'Неизвестный преподаватель',
              });
            }
          } catch (e) {
            print(
              'DEBUG: studentAttendanceWithSubjectsProvider: Error processing entry ${entryDoc.id}: $e',
            );
          }
        }

        print(
          'DEBUG: studentAttendanceWithSubjectsProvider: Processed ${attendanceWithSubjects.length} attendance records with subjects',
        );
        return attendanceWithSubjects;
      });
});

// Провайдер для получения уникальных предметов из посещаемости
final studentUniqueSubjectsFromAttendanceProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
      final attendanceWithSubjects = await ref.watch(
        studentAttendanceWithSubjectsProvider.future,
      );

      final subjects = <String>{};
      for (final attendanceData in attendanceWithSubjects) {
        final subjectName = attendanceData['subjectName'] as String;
        subjects.add(subjectName);
      }

      final sortedSubjects = subjects.toList()..sort();
      return ['Все', ...sortedSubjects];
    });

// Провайдер для статистики посещаемости студента
final studentAttendanceStatsProvider =
    Provider.autoDispose<Map<String, dynamic>>((ref) {
      final attendanceAsync = ref.watch(studentAttendanceProvider);

      return attendanceAsync.when(
        data: (attendance) {
          if (attendance.isEmpty) {
            return {
              'totalLessons': 0,
              'presentCount': 0,
              'absentCount': 0,
              'lateCount': 0,
              'attendanceRate': 0.0,
              'attendanceBySubject': <String, Map<String, int>>{},
              'recentAttendance': 0,
            };
          }

          final totalLessons = attendance.length;
          final presentCount =
              attendance.where((a) => a.attendanceStatus == 'present').length;
          final absentCount =
              attendance.where((a) => a.attendanceStatus == 'absent').length;
          final lateCount =
              attendance.where((a) => a.attendanceStatus == 'late').length;

          final attendanceRate =
              totalLessons > 0 ? (presentCount / totalLessons) * 100 : 0.0;

          // Группировка по предметам (временно по journalId)
          final attendanceBySubject = <String, Map<String, int>>{};
          for (final record in attendance) {
            attendanceBySubject.putIfAbsent(
              record.journalId,
              () => {'present': 0, 'absent': 0, 'late': 0},
            );

            attendanceBySubject[record.journalId]![record.attendanceStatus] =
                (attendanceBySubject[record.journalId]![record
                        .attendanceStatus] ??
                    0) +
                1;
          }

          // Подсчет недавней посещаемости (за последнюю неделю)
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          final recentAttendance =
              attendance.where((a) => a.date.isAfter(weekAgo)).length;

          return {
            'totalLessons': totalLessons,
            'presentCount': presentCount,
            'absentCount': absentCount,
            'lateCount': lateCount,
            'attendanceRate': attendanceRate,
            'attendanceBySubject': attendanceBySubject,
            'recentAttendance': recentAttendance,
          };
        },
        loading:
            () => {
              'totalLessons': 0,
              'presentCount': 0,
              'absentCount': 0,
              'lateCount': 0,
              'attendanceRate': 0.0,
              'attendanceBySubject': <String, Map<String, int>>{},
              'recentAttendance': 0,
            },
        error:
            (_, __) => {
              'totalLessons': 0,
              'presentCount': 0,
              'absentCount': 0,
              'lateCount': 0,
              'attendanceRate': 0.0,
              'attendanceBySubject': <String, Map<String, int>>{},
              'recentAttendance': 0,
            },
      );
    });
