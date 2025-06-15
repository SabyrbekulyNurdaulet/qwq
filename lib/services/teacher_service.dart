import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/teacher.dart';

class TeacherService {
  final _db = FirebaseFirestore.instance;

  Future<Teacher?> getTeacherById(String id) async {
    final doc = await _db.collection('teachers').doc(id).get();
    if (!doc.exists) return null;
    return Teacher.fromJson({...doc.data()!, 'id': doc.id});
  }
}
