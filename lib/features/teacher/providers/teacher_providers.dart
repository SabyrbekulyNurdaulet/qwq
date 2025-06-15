import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/class_session.dart';
import '../models/assignment.dart';
import '../services/firebase_service.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService());

final teacherIdProvider = Provider<String>((ref) => 'CURRENT_TEACHER_UID'); // заменишь на свой uid

final classSessionsProvider = StreamProvider<List<ClassSession>>((ref) {
  final teacherId = ref.watch(teacherIdProvider);
  return ref.watch(firebaseServiceProvider).getTeacherSessions(teacherId);
});

final assignmentsProvider = StreamProvider<List<Assignment>>((ref) {
  final teacherId = ref.watch(teacherIdProvider);
  return ref.watch(firebaseServiceProvider).getAssignmentsByTeacher(teacherId);
});

final teacherNameProvider = Provider<String>((ref) {
  // Заглушка — замени на реальное получение имени, например из Firebase или локального хранилища
  return 'Имя Учителя';
});
