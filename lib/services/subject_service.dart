import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject.dart';

class SubjectService {
  final _firestore = FirebaseFirestore.instance;

  Future<Subject?> getSubject(String subjectId) async {
    try {
      final doc = await _firestore.collection('subjects').doc(subjectId).get();
      if (!doc.exists) return null;
      return Subject.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting subject: $e');
      return null;
    }
  }

  // Получить все предметы
  Stream<List<Subject>> getAllSubjects() {
    return _firestore.collection('subjects').orderBy('name').snapshots().map((
      snapshot,
    ) {
      print('DEBUG: Got ${snapshot.docs.length} subjects');
      return snapshot.docs
          .map((doc) => Subject.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  // Получить предметы по списку ID
  Future<Map<String, Subject>> getSubjectsByIds(List<String> ids) async {
    print('DEBUG: Getting subjects by IDs: $ids');
    if (ids.isEmpty) return {};

    // Используем один запрос с whereIn вместо множества отдельных запросов
    final snapshot =
        await _firestore
            .collection('subjects')
            .where(FieldPath.documentId, whereIn: ids)
            .get();

    print('DEBUG: Found ${snapshot.docs.length} subjects');
    return Map.fromEntries(
      snapshot.docs.map(
        (doc) =>
            MapEntry(doc.id, Subject.fromJson({...doc.data(), 'id': doc.id})),
      ),
    );
  }

  // Получить предметы по ID преподавателя
  Stream<List<Subject>> getSubjectsByTeacher(String teacherId) {
    print('DEBUG: Getting subjects for teacher: $teacherId');
    return _firestore
        .collection('subjects')
        .where('teacherId', isEqualTo: teacherId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          print('DEBUG: Got ${snapshot.docs.length} subjects for teacher');
          return snapshot.docs
              .map((doc) => Subject.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  // Получить предметы по ID группы
  Stream<List<Subject>> getSubjectsByGroup(String groupId) {
    print('DEBUG: Getting subjects for group: $groupId');
    return _firestore
        .collection('subjects')
        .where('groups', arrayContains: groupId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
          print('DEBUG: Got ${snapshot.docs.length} subjects for group');
          return snapshot.docs
              .map((doc) => Subject.fromJson({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  // Инициализация тестовых предметов
  Future<void> initializeTestSubjects() async {
    final subjects = [
      {
        'name': 'Математика',
        'shortName': 'Мат',
        'description': 'Высшая математика',
        'credits': 6,
        'hours': 144,
        'hoursPerSemester': 72,
        'hoursPerWeek': 4,
        'teacherId': 'default_teacher',
        'type': 'lecture',
        'groups': ['default_group'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Физика',
        'shortName': 'Физ',
        'description': 'Общая физика',
        'credits': 4,
        'hours': 108,
        'hoursPerSemester': 54,
        'hoursPerWeek': 3,
        'teacherId': 'default_teacher',
        'type': 'lecture',
        'groups': ['default_group'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Химия',
        'shortName': 'Хим',
        'description': 'Общая химия',
        'credits': 3,
        'hours': 72,
        'hoursPerSemester': 36,
        'hoursPerWeek': 2,
        'teacherId': 'default_teacher',
        'type': 'lecture',
        'groups': ['default_group'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'История',
        'shortName': 'Ист',
        'description': 'История России',
        'credits': 3,
        'hours': 72,
        'hoursPerSemester': 36,
        'hoursPerWeek': 2,
        'teacherId': 'default_teacher',
        'type': 'lecture',
        'groups': ['default_group'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Литература',
        'shortName': 'Лит',
        'description': 'Русская литература',
        'credits': 3,
        'hours': 72,
        'hoursPerSemester': 36,
        'hoursPerWeek': 2,
        'teacherId': 'default_teacher',
        'type': 'lecture',
        'groups': ['default_group'],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
    ];

    final batch = _firestore.batch();
    for (final subject in subjects) {
      final docRef = _firestore.collection('subjects').doc();
      batch.set(docRef, subject);
    }
    await batch.commit();
  }
}
