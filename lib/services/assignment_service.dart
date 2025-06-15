import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';

class AssignmentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получить все задания
  Stream<List<Assignment>> getAssignments() {
    return _db
        .collection('assignments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Assignment.fromJson({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  // Получить задание по ID
  Future<Assignment?> getAssignment(String id) async {
    final doc = await _db.collection('assignments').doc(id).get();
    if (!doc.exists) return null;
    return Assignment.fromJson({...doc.data()!, 'id': doc.id});
  }

  // Добавить задание
  Future<void> addAssignment(Assignment assignment) async {
    await _db.collection('assignments').add(assignment.toJson());
  }

  // Обновить задание
  Future<void> updateAssignment(Assignment assignment) async {
    await _db
        .collection('assignments')
        .doc(assignment.id)
        .update(assignment.toJson());
  }

  // Удалить задание
  Future<void> deleteAssignment(String id) async {
    await _db.collection('assignments').doc(id).delete();
  }
}
