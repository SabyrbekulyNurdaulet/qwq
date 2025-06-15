import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schedule_entry.dart';
import '../models/semester.dart';
import 'semester_service.dart';

class ScheduleService {
  final _firestore = FirebaseFirestore.instance;
  final _semesterService = SemesterService();

  Stream<List<ScheduleEntry>> getScheduleByGroup(String groupId) {
    print('DEBUG: ScheduleService: Getting schedule for group $groupId');

    return _semesterService.getCurrentSemester().asyncMap((semester) async {
      if (semester == null) {
        print('DEBUG: ScheduleService: No active semester found');
        return [];
      }

      print('DEBUG: ScheduleService: Using semester: ${semester.name}');

      final snapshot =
          await _firestore
              .collection('schedules')
              .where('groupId', isEqualTo: groupId)
              .where('semesterId', isEqualTo: semester.id)
              .get();

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

      return lessons.map((lessonData) {
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
            'semesterId': lessonData['semesterId']?.toString() ?? semester.id,
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
          print('DEBUG: ScheduleService: Processed data: $processedData');

          final entry = ScheduleEntry.fromJson(processedData);
          print('DEBUG: ScheduleService: Created ScheduleEntry: $entry');
          return entry;
        } catch (e, stackTrace) {
          print('DEBUG: ScheduleService: Error creating ScheduleEntry: $e');
          print('DEBUG: ScheduleService: Stack trace: $stackTrace');
          print(
            'DEBUG: ScheduleService: Lesson data that caused error: $lessonData',
          );
          rethrow;
        }
      }).toList();
    });
  }

  // Получить расписание для конкретного семестра
  Stream<List<ScheduleEntry>> getScheduleByGroupAndSemester(
    String groupId,
    Semester semester,
  ) {
    print(
      'DEBUG: ScheduleService: Getting schedule for group $groupId and semester ${semester.name}',
    );

    return _firestore
        .collection('schedules')
        .where('groupId', isEqualTo: groupId)
        .where('semesterId', isEqualTo: semester.id)
        .snapshots()
        .asyncMap((snapshot) async {
          print(
            'DEBUG: ScheduleService: Received ${snapshot.docs.length} schedule documents',
          );

          if (snapshot.docs.isEmpty) {
            print('DEBUG: ScheduleService: No schedule documents found');
            return [];
          }

          final scheduleDoc = snapshot.docs.first;
          final scheduleData = scheduleDoc.data();
          final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];

          print('DEBUG: ScheduleService: Found ${lessons.length} lessons');

          final List<ScheduleEntry> scheduleEntries = [];

          for (final lessonData in lessons) {
            try {
              final Map<String, dynamic> processedData = {
                'id': lessonData['id']?.toString() ?? '',
                'groupId': lessonData['groupId']?.toString() ?? groupId,
                'semesterId':
                    lessonData['semesterId']?.toString() ?? semester.id,
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

              final entry = ScheduleEntry.fromJson(processedData);
              scheduleEntries.add(entry);
              print('DEBUG: ScheduleService: Added lesson: ${entry.id}');
            } catch (e) {
              print('DEBUG: ScheduleService: Error creating ScheduleEntry: $e');
              print('DEBUG: ScheduleService: Lesson data: $lessonData');
            }
          }

          print(
            'DEBUG: ScheduleService: Total lessons processed: ${scheduleEntries.length}',
          );
          return scheduleEntries;
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
              final entry = ScheduleEntry.fromJson({
                ...lessonData,
                'id': lessonData['id'],
              });
              allLessons.add(entry);
              print('DEBUG: ScheduleService: Added lesson: ${entry.id}');
            } catch (e) {
              print('DEBUG: ScheduleService: Error parsing lesson: $e');
              print('DEBUG: ScheduleService: Lesson data: $lessonData');
            }
          }
        }
      }

      print(
        'DEBUG: ScheduleService: Total lessons found: ${allLessons.length}',
      );
      return allLessons;
    });
  }
}
