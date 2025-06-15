// lib/utils/debug_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DebugHelper {
  static Future<void> checkUserData() async {
    print('=== ОТЛАДКА ДАННЫХ ПОЛЬЗОВАТЕЛЕЙ ===');

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'student')
              .get();

      print('Найдено студентов: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
        final data = doc.data();
        print('Студент ${doc.id}: ${data['firstName']} ${data['lastName']}');
        print('  - Группа: ${data['groupId']}');
        print('  - Статус: ${data['status']}');
        print('  - Роль: ${data['role']}');
        print('---');
      }
    } catch (e) {
      print('Ошибка при проверке данных пользователей: $e');
    }
  }

  static Future<void> checkGroupData() async {
    print('=== ОТЛАДКА ДАННЫХ ГРУПП ===');

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('groups').get();

      print('Найдено групп: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
        final data = doc.data();
        print('Группа ${doc.id}: ${data['name']}');
        print('  - Специализация: ${data['specialization']}');
        print('  - Курс: ${data['year']}');
        print('---');
      }
    } catch (e) {
      print('Ошибка при проверке данных групп: $e');
    }
  }

  static Future<void> checkScheduleData(String teacherId) async {
    print('=== ОТЛАДКА РАСПИСАНИЯ ДЛЯ ПРЕПОДАВАТЕЛЯ $teacherId ===');

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('schedules').get();

      print('Найдено документов расписания: ${snapshot.docs.length}');

      int totalLessons = 0;
      int teacherLessons = 0;
      Set<String> teacherGroups = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final lessons = data['lessons'] as List<dynamic>? ?? [];
        totalLessons += lessons.length;

        print('Документ ${doc.id}: ${lessons.length} уроков');

        for (final lesson in lessons) {
          if (lesson['teacherId'] == teacherId) {
            teacherLessons++;
            teacherGroups.add(lesson['groupId']?.toString() ?? '');
            print(
              '  - Урок преподавателя: ${lesson['subjectId']} для группы ${lesson['groupId']}',
            );
          }
        }
      }

      print('Общее количество уроков: $totalLessons');
      print('Уроков преподавателя: $teacherLessons');
      print('Группы преподавателя: ${teacherGroups.toList()}');
    } catch (e) {
      print('Ошибка при проверке расписания: $e');
    }
  }
}
