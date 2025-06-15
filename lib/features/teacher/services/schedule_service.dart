import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/schedule_entry.dart';

class ScheduleService {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<ScheduleEntry>> getScheduleByGroup(String groupId) {
    print('DEBUG: ScheduleService: Getting schedule for group $groupId');
    return _firestore.collection('schedules').where('groupId', isEqualTo: groupId).snapshots().map((
      snapshot,
    ) {
      print(
        'DEBUG: ScheduleService: Received ${snapshot.docs.length} schedule documents',
      );
      if (snapshot.docs.isEmpty) {
        print('DEBUG: ScheduleService: No schedule documents found');
        return [];
      }

      // Get the first schedule document (there should be only one per group)
      final scheduleDoc = snapshot.docs.first;
      final scheduleData = scheduleDoc.data();
      print('DEBUG: ScheduleService: Schedule data: $scheduleData');

      // Extract lessons array from the schedule document
      final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];
      print('DEBUG: ScheduleService: Lessons array: $lessons');

      final parsedLessons = <ScheduleEntry>[];
      final seenKeys = <String>{};

      for (final lessonData in lessons) {
        print('DEBUG: ScheduleService: Processing lesson: $lessonData');
        try {
          // Проверяем наличие всех обязательных полей
          final requiredFields = [
            'id',
            'groupId',
            'semesterId',
            'subjectId',
            'teacherId',
            'startTime',
            'endTime',
          ];
          for (final field in requiredFields) {
            if (lessonData[field] == null) {
              print('DEBUG: ScheduleService: Missing required field: $field');
              print('DEBUG: ScheduleService: Lesson data: $lessonData');
            }
          }

          // Создаем копию данных с дефолтными значениями
          final Map<String, dynamic> processedData = {
            'id': lessonData['id']?.toString() ?? '',
            'groupId': lessonData['groupId']?.toString() ?? groupId,
            'semesterId': lessonData['semesterId']?.toString() ?? '',
            'subjectId': lessonData['subjectId']?.toString() ?? '',
            'teacherId': lessonData['teacherId']?.toString() ?? '',
            'startTime': lessonData['startTime']?.toString() ?? '',
            'endTime': lessonData['endTime']?.toString() ?? '',
            'dayOfWeek': lessonData['dayOfWeek'] ?? 1,
            'type': lessonData['type']?.toString() ?? 'lecture',
            'weekType': lessonData['weekType']?.toString() ?? 'all',
            'room': lessonData['room']?.toString() ?? '',
            'duration': lessonData['duration'] ?? 90,
            'isFloating': lessonData['isFloating'] ?? false,
            'createdAt': lessonData['createdAt'],
            'updatedAt': lessonData['updatedAt'],
          };

          // Создаем уникальный ключ для дедупликации
          final uniqueKey =
              '${processedData['dayOfWeek']}_${processedData['startTime']}_${processedData['endTime']}_${processedData['subjectId']}_${processedData['groupId']}_${processedData['teacherId']}';

          if (!seenKeys.contains(uniqueKey)) {
            seenKeys.add(uniqueKey);
            print('DEBUG: ScheduleService: Processed data: $processedData');

            final entry = ScheduleEntry.fromJson(processedData);
            print('DEBUG: ScheduleService: Created ScheduleEntry: $entry');
            parsedLessons.add(entry);
          } else {
            print(
              'DEBUG: ScheduleService: Skipping duplicate lesson with key: $uniqueKey',
            );
          }
        } catch (e, stackTrace) {
          print('DEBUG: ScheduleService: Error creating ScheduleEntry: $e');
          print('DEBUG: ScheduleService: Stack trace: $stackTrace');
          print(
            'DEBUG: ScheduleService: Lesson data that caused error: $lessonData',
          );
        }
      }

      print(
        'DEBUG: ScheduleService: Final lessons count: ${parsedLessons.length}',
      );
      return parsedLessons;
    });
  }

  Stream<List<ScheduleEntry>> getTeacherSchedule(String teacherId) {
    print('DEBUG: ScheduleService: Getting schedule for teacher $teacherId');
    return _firestore.collection('schedules').snapshots().map((snapshot) {
      print(
        'DEBUG: ScheduleService: Received ${snapshot.docs.length} schedule documents',
      );

      if (snapshot.docs.isEmpty) {
        print('DEBUG: ScheduleService: No schedule documents found');
        return [];
      }

      // Collect all lessons from all schedules where teacherId matches
      final allLessons = <ScheduleEntry>[];
      final seenKeys = <String>{}; // Для дедупликации

      for (final scheduleDoc in snapshot.docs) {
        final scheduleData = scheduleDoc.data();
        print(
          'DEBUG: ScheduleService: Processing schedule document: ${scheduleDoc.id}',
        );

        final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];
        print(
          'DEBUG: ScheduleService: Found ${lessons.length} lessons in document',
        );

        for (final lessonData in lessons) {
          if (lessonData['teacherId'] == teacherId) {
            try {
              // Создаем уникальный ключ для дедупликации
              final uniqueKey =
                  '${lessonData['dayOfWeek']}_${lessonData['startTime']}_${lessonData['endTime']}_${lessonData['subjectId']}_${lessonData['groupId']}_${lessonData['teacherId']}';

              if (!seenKeys.contains(uniqueKey)) {
                seenKeys.add(uniqueKey);

                final entry = ScheduleEntry.fromJson({
                  ...lessonData,
                  'id': lessonData['id'],
                });
                allLessons.add(entry);
                print('DEBUG: ScheduleService: Added lesson: ${entry.id}');
              } else {
                print(
                  'DEBUG: ScheduleService: Skipping duplicate lesson with key: $uniqueKey',
                );
              }
            } catch (e) {
              print('DEBUG: ScheduleService: Error parsing lesson: $e');
              print('DEBUG: ScheduleService: Lesson data: $lessonData');
            }
          }
        }
      }

      print(
        'DEBUG: ScheduleService: Total unique lessons found: ${allLessons.length}',
      );
      return allLessons;
    });
  }
}
