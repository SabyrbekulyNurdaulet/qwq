// lib/providers/journal_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal.dart' as journal_models;
import '../models/journal_entry.dart' as entry_models;

final teacherJournalsProvider =
    StreamProvider.family<List<journal_models.Journal>, String>((
      ref,
      teacherId,
    ) {
      if (teacherId.isEmpty) {
        return Stream.value([]);
      }

      return FirebaseFirestore.instance
          .collection('journals')
          .where('teacherId', isEqualTo: teacherId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              try {
                return journal_models.Journal.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                });
              } catch (e) {
                print('Error parsing journal ${doc.id}: $e');
                // Возвращаем базовый объект в случае ошибки
                return journal_models.Journal(
                  id: doc.id,
                  teacherId: teacherId,
                  groupId: 'unknown',
                  subjectId: 'unknown',
                  semesterId: 'unknown',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
              }
            }).toList();
          });
    });

// Провайдер для получения записей журнала
final journalEntriesProvider =
    StreamProvider.family<List<entry_models.JournalEntry>, String>((
      ref,
      journalId,
    ) {
      if (journalId.isEmpty) {
        return Stream.value([]);
      }

      return FirebaseFirestore.instance
          .collection('journalEntries')
          .where('journalId', isEqualTo: journalId)
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              try {
                final data = doc.data();
                return entry_models.JournalEntry.fromJson({
                  ...(data != null && data is Map<String, dynamic>
                      ? data
                      : <String, dynamic>{}),
                  'id': doc.id,
                });
              } catch (e) {
                print('Error parsing journal entry ${doc.id}: $e');
                // Возвращаем базовый объект в случае ошибки
                return entry_models.JournalEntry(
                  id: doc.id,
                  journalId: journalId,
                  studentId: 'unknown',
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

// Провайдер для получения записей конкретного студента
final studentJournalEntriesProvider = StreamProvider.family<
  List<entry_models.JournalEntry>,
  ({String studentId, String? subjectId})
>((ref, params) {
  if (params.studentId.isEmpty) {
    return Stream.value([]);
  }

  Query query = FirebaseFirestore.instance
      .collection('journalEntries')
      .where('studentId', isEqualTo: params.studentId);

  if (params.subjectId != null && params.subjectId!.isNotEmpty) {
    // Нужно сначала получить журналы по предмету, а затем записи
    // Это более сложный запрос, лучше делать через сервис
  }

  return query.orderBy('date', descending: true).snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      try {
        final data = doc.data();
        return entry_models.JournalEntry.fromJson({
          ...(data != null && data is Map<String, dynamic>
              ? data
              : <String, dynamic>{}),
          'id': doc.id,
        });
      } catch (e) {
        print('Error parsing journal entry ${doc.id}: $e');
        return entry_models.JournalEntry(
          id: doc.id,
          journalId: 'unknown',
          studentId: params.studentId,
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

// Провайдер для статистики журнала
final journalStatsProvider = Provider.family<Map<String, dynamic>, String>((
  ref,
  journalId,
) {
  final entriesAsync = ref.watch(journalEntriesProvider(journalId));

  return entriesAsync.when(
    data: (entries) {
      if (entries.isEmpty) {
        return {
          'totalEntries': 0,
          'averageGrade': 0.0,
          'attendanceRate': 0.0,
          'gradeDistribution': <String, int>{},
          'attendanceStats': <String, int>{},
        };
      }

      final totalEntries = entries.length;
      final entriesWithGrades =
          entries.where((e) => e.hasNumericGrade).toList();
      final presentEntries = entries.where((e) => e.present).length;

      double averageGrade = 0.0;
      if (entriesWithGrades.isNotEmpty) {
        final sum = entriesWithGrades
            .map((e) => e.numericGradeValue!)
            .reduce((a, b) => a + b);
        averageGrade = sum / entriesWithGrades.length;
      }

      final attendanceRate =
          totalEntries > 0 ? (presentEntries / totalEntries) * 100 : 0.0;

      // Распределение оценок
      final gradeDistribution = <String, int>{};
      for (final entry in entriesWithGrades) {
        final grade = entry.numericGradeValue!;
        String range;
        if (grade >= 90) {
          range = '90-100';
        } else if (grade >= 75) {
          range = '75-89';
        } else if (grade >= 60) {
          range = '60-74';
        } else {
          range = '0-59';
        }
        gradeDistribution[range] = (gradeDistribution[range] ?? 0) + 1;
      }

      // Статистика посещаемости
      final attendanceStats = <String, int>{};
      for (final entry in entries) {
        attendanceStats[entry.attendanceStatus] =
            (attendanceStats[entry.attendanceStatus] ?? 0) + 1;
      }

      return {
        'totalEntries': totalEntries,
        'averageGrade': averageGrade,
        'attendanceRate': attendanceRate,
        'gradeDistribution': gradeDistribution,
        'attendanceStats': attendanceStats,
        'entriesWithGrades': entriesWithGrades.length,
      };
    },
    loading:
        () => {
          'totalEntries': 0,
          'averageGrade': 0.0,
          'attendanceRate': 0.0,
          'gradeDistribution': <String, int>{},
          'attendanceStats': <String, int>{},
        },
    error:
        (_, __) => {
          'totalEntries': 0,
          'averageGrade': 0.0,
          'attendanceRate': 0.0,
          'gradeDistribution': <String, int>{},
          'attendanceStats': <String, int>{},
        },
  );
});

// Провайдер для поиска или создания журнала
final findOrCreateJournalProvider = FutureProvider.family<
  String,
  ({String teacherId, String groupId, String subjectId, String semesterId})
>((ref, params) async {
  // Сначала ищем существующий журнал
  final existingJournalQuery =
      await FirebaseFirestore.instance
          .collection('journals')
          .where('teacherId', isEqualTo: params.teacherId)
          .where('groupId', isEqualTo: params.groupId)
          .where('subjectId', isEqualTo: params.subjectId)
          .where('semesterId', isEqualTo: params.semesterId)
          .limit(1)
          .get();

  if (existingJournalQuery.docs.isNotEmpty) {
    return existingJournalQuery.docs.first.id;
  }

  // Создаем новый журнал
  final journalRef = await FirebaseFirestore.instance
      .collection('journals')
      .add({
        'teacherId': params.teacherId,
        'groupId': params.groupId,
        'subjectId': params.subjectId,
        'semesterId': params.semesterId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  return journalRef.id;
});

// Провайдер для добавления записи в журнал
final addJournalEntryProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, entryData) async {
      await FirebaseFirestore.instance
          .collection('journalEntries')
          .add(entryData);
    });

// Провайдер для обновления записи в журнале
final updateJournalEntryProvider = FutureProvider.family<
  void,
  ({String entryId, Map<String, dynamic> updateData})
>((ref, params) async {
  await FirebaseFirestore.instance
      .collection('journalEntries')
      .doc(params.entryId)
      .update({
        ...params.updateData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
});

// Провайдер для удаления записи из журнала
final deleteJournalEntryProvider = FutureProvider.family<void, String>((
  ref,
  entryId,
) async {
  await FirebaseFirestore.instance
      .collection('journalEntries')
      .doc(entryId)
      .delete();
});
