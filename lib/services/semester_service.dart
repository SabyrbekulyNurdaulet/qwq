import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/semester.dart';

class SemesterService {
  final _firestore = FirebaseFirestore.instance;

  // Получить текущий активный семестр
  Stream<Semester?> getCurrentSemester() {
    final now = DateTime.now();
    print('DEBUG: SemesterService: Getting current semester');
    return _firestore
        .collection('semesters')
        .where('status', isEqualTo: 'active')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
          print(
            'DEBUG: SemesterService: Got ${snapshot.docs.length} semesters',
          );
          if (snapshot.docs.isEmpty) {
            print('DEBUG: SemesterService: No active semesters found');
            return null;
          }

          // Получаем все семестры
          final semesters =
              snapshot.docs.map((doc) {
                final data = doc.data();
                print(
                  'DEBUG: SemesterService: Semester ${doc.id}: ${data['name']} (status: ${data['status']})',
                );
                return Semester.fromJson({...data, 'id': doc.id});
              }).toList();

          // Берем первый семестр (самый новый)
          final currentSemester = semesters.first;
          print(
            'DEBUG: SemesterService: Selected semester: ${currentSemester.name}',
          );
          return currentSemester;
        });
  }

  // Получить все семестры
  Stream<List<Semester>> getAllSemesters() {
    return _firestore
        .collection('semesters')
        .where('status', whereIn: ['active', 'planning'])
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Semester.fromJson({...doc.data(), 'id': doc.id});
          }).toList();
        });
  }

  // Создать новый семестр
  Future<Semester> createSemester({
    required String name,
    required String academicYear,
    required DateTime startDate,
    required DateTime endDate,
    String status = 'planning',
  }) async {
    final now = DateTime.now();
    final semesterData = {
      'name': name,
      'academicYear': academicYear,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'status': status,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    final docRef = await _firestore.collection('semesters').add(semesterData);
    return Semester.fromJson({...semesterData, 'id': docRef.id});
  }

  // Обновить семестр
  Future<void> updateSemester(Semester semester) async {
    await _firestore.collection('semesters').doc(semester.id).update({
      ...semester.toJson(),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Активировать семестр
  Future<void> activateSemester(String semesterId) async {
    // Сначала архивируем все активные семестры
    final batch = _firestore.batch();
    final activeSemesters =
        await _firestore
            .collection('semesters')
            .where('status', isEqualTo: 'active')
            .get();

    for (final doc in activeSemesters.docs) {
      batch.update(doc.reference, {
        'status': 'archive',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    }

    // Затем активируем нужный семестр
    batch.update(_firestore.collection('semesters').doc(semesterId), {
      'status': 'active',
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });

    await batch.commit();
  }

  // Архивировать семестр
  Future<void> archiveSemester(String semesterId) async {
    await _firestore.collection('semesters').doc(semesterId).update({
      'status': 'archive',
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Удалить семестр
  Future<void> deleteSemester(String semesterId) async {
    await _firestore.collection('semesters').doc(semesterId).delete();
  }
}
