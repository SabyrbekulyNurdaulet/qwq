import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/schedule_entry.dart';
import '../models/class_session.dart';
import '../models/group.dart';
import '../models/student.dart';
import '../models/grade.dart';
import '../models/assignment.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получить расписание по группе
  Future<List<ScheduleEntry>> getScheduleEntriesForGroup(String groupId) async {
    final snapshot =
        await _db
            .collection('schedules')
            .where('groupId', isEqualTo: groupId)
            .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    final scheduleDoc = snapshot.docs.first;
    final scheduleData = scheduleDoc.data();
    final lessons = scheduleData['lessons'] as List<dynamic>? ?? [];

    return lessons.map((lessonData) {
      return ScheduleEntry.fromJson({...lessonData, 'id': lessonData['id']});
    }).toList();
  }

  // Получить занятия преподавателя (поток)
  Stream<List<ClassSession>> getTeacherSessions(String teacherId) {
    return _db
        .collection('class_sessions')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ClassSession.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  // Получить список групп
  Future<List<Group>> getGroups() async {
    final snapshot = await _db.collection('groups').get();
    return snapshot.docs
        .map((doc) => Group.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Получить студентов по группе
  Future<List<Student>> getStudentsByGroup(String groupId) async {
    final snapshot =
        await _db
            .collection('students')
            .where('groupId', isEqualTo: groupId)
            .get();
    return snapshot.docs
        .map((doc) => Student.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Добавить оценку
  Future<void> addGrade(Grade grade) async {
    await _db.collection('grades').add(grade.toMap());
  }

  // Добавить задание
  Future<void> addAssignment(Assignment assignment) async {
    await _db.collection('assignments').add(assignment.toMap());
  }

  // Получить задания по учителю (поток)
  Stream<List<Assignment>> getAssignmentsByTeacher(String teacherId) {
    return _db
        .collection('assignments')
        .where('teacherId', isEqualTo: teacherId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Assignment.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }
}
