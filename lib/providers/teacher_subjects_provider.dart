// lib/providers/teacher_subjects_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';

// Провайдер для получения предметов конкретного преподавателя
// на основе его расписания
final teacherSubjectsProvider = FutureProvider.family<List<Subject>, String>((
  ref,
  teacherId,
) async {
  print(
    'DEBUG: teacherSubjectsProvider: Getting subjects for teacher $teacherId',
  );

  if (teacherId.isEmpty) {
    print('DEBUG: teacherSubjectsProvider: Empty teacherId');
    return [];
  }

  try {
    // Получаем все документы расписания
    final schedulesSnapshot =
        await FirebaseFirestore.instance.collection('schedules').get();

    print(
      'DEBUG: teacherSubjectsProvider: Found ${schedulesSnapshot.docs.length} schedule documents',
    );

    // Собираем уникальные ID предметов из всех расписаний, где teacherId совпадает
    final Set<String> subjectIds = {};

    for (final scheduleDoc in schedulesSnapshot.docs) {
      final scheduleData = scheduleDoc.data();
      final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];

      print(
        'DEBUG: teacherSubjectsProvider: Processing ${lessons.length} lessons in document ${scheduleDoc.id}',
      );

      for (final lesson in lessons) {
        if (lesson['teacherId'] == teacherId) {
          final subjectId = lesson['subjectId']?.toString();
          if (subjectId != null && subjectId.isNotEmpty) {
            subjectIds.add(subjectId);
            print(
              'DEBUG: teacherSubjectsProvider: Found subject $subjectId for teacher',
            );
          }
        }
      }
    }

    print('DEBUG: teacherSubjectsProvider: Unique subject IDs: $subjectIds');

    if (subjectIds.isEmpty) {
      print('DEBUG: teacherSubjectsProvider: No subjects found in schedule');
      return [];
    }

    // Загружаем полную информацию о предметах
    final subjects = <Subject>[];

    // Получаем данные предметов батчами (Firestore ограничивает whereIn до 10 элементов)
    final subjectIdsList = subjectIds.toList();
    for (int i = 0; i < subjectIdsList.length; i += 10) {
      final batch = subjectIdsList.skip(i).take(10).toList();

      final subjectsSnapshot =
          await FirebaseFirestore.instance
              .collection('subjects')
              .where(FieldPath.documentId, whereIn: batch)
              .get();

      for (final subjectDoc in subjectsSnapshot.docs) {
        try {
          final subject = Subject.fromJson({
            ...subjectDoc.data(),
            'id': subjectDoc.id,
          });
          subjects.add(subject);
          print(
            'DEBUG: teacherSubjectsProvider: Added subject: ${subject.name}',
          );
        } catch (e) {
          print(
            'DEBUG: teacherSubjectsProvider: Error parsing subject ${subjectDoc.id}: $e',
          );
        }
      }
    }

    // Сортируем предметы по названию
    subjects.sort((a, b) => a.name.compareTo(b.name));

    print(
      'DEBUG: teacherSubjectsProvider: Final subjects count: ${subjects.length}',
    );
    return subjects;
  } catch (e, stackTrace) {
    print('DEBUG: teacherSubjectsProvider: Error: $e');
    print('DEBUG: teacherSubjectsProvider: Stack trace: $stackTrace');
    return [];
  }
});

// Провайдер для получения названий предметов преподавателя
final teacherSubjectNamesProvider = FutureProvider.family<List<String>, String>(
  (ref, teacherId) async {
    final subjects = await ref.watch(teacherSubjectsProvider(teacherId).future);
    return subjects.map((subject) => subject.name).toList();
  },
);

// Провайдер для получения предметов преподавателя с дополнительной информацией
final teacherSubjectsWithInfoProvider = FutureProvider.family<
  List<Map<String, dynamic>>,
  String
>((ref, teacherId) async {
  final subjects = await ref.watch(teacherSubjectsProvider(teacherId).future);

  return subjects
      .map(
        (subject) => {
          'subject': subject,
          'displayName': '${subject.name} (${subject.shortName})',
          'shortName': subject.shortName,
          'fullInfo': '${subject.name} - ${subject.department ?? 'Общий'}',
        },
      )
      .toList();
});
