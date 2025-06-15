import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/semester_service.dart';
import '../../../models/semester.dart';

final semesterServiceProvider = Provider((ref) => SemesterService());

// Провайдер для текущего активного семестра
final currentSemesterProvider = StreamProvider.autoDispose<Semester?>((ref) {
  final semesterService = ref.watch(semesterServiceProvider);
  return semesterService.getCurrentSemester();
});

// Провайдер для списка всех семестров
final allSemestersProvider = StreamProvider.autoDispose<List<Semester>>((ref) {
  final semesterService = ref.watch(semesterServiceProvider);
  return semesterService.getAllSemesters();
});
