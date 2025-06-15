import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grade.dart';

class GradesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Grade>> getGrades() async {
    try {
      final snapshot =
          await _firestore.collection('grades').orderBy('semester').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Grade(
          id: doc.id,
          subject: data['subject'] ?? '',
          teacher: data['teacher'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          semester: data['semester'] ?? 1,
          value: (data['value'] ?? 0).toDouble(),
          isNumeric: data['isNumeric'] ?? true,
          isPassFail: data['isPassFail'] ?? false,
        );
      }).toList();
    } catch (e) {
      throw 'Ошибка при получении оценок: $e';
    }
  }

  Future<void> addGrade(Grade grade) async {
    try {
      await _firestore.collection('grades').add({
        'subject': grade.subject,
        'teacher': grade.teacher,
        'date': Timestamp.fromDate(grade.date),
        'semester': grade.semester,
        'value': grade.value,
        'isNumeric': grade.isNumeric,
        'isPassFail': grade.isPassFail,
      });
    } catch (e) {
      throw 'Ошибка при добавлении оценки: $e';
    }
  }

  Future<void> updateGrade(Grade grade) async {
    try {
      await _firestore.collection('grades').doc(grade.id).update({
        'subject': grade.subject,
        'teacher': grade.teacher,
        'date': Timestamp.fromDate(grade.date),
        'semester': grade.semester,
        'value': grade.value,
        'isNumeric': grade.isNumeric,
        'isPassFail': grade.isPassFail,
      });
    } catch (e) {
      throw 'Ошибка при обновлении оценки: $e';
    }
  }

  Future<void> deleteGrade(String gradeId) async {
    try {
      await _firestore.collection('grades').doc(gradeId).delete();
    } catch (e) {
      throw 'Ошибка при удалении оценки: $e';
    }
  }
}
